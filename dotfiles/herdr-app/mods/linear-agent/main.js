// Start an agent on a Linear issue: props { issue, cwd, on }.
// Makes a worktree from the default branch and a space running the agent with the issue as its task.
// Adapted from the `issue-agent` mod in obrunogonzaga/herdr-mods (MIT, Copyright (c) 2026 Bruno Gonzaga):
// Linear issues instead of GitHub ones, the base branch from git instead of gh, a repository line
// and a subagents option.

import { View, div, svg, image } from "gpui-kit";
import { v_flex, h_flex, InputState, Input, Scrollbar, v_virtual_list, VirtualListScrollHandle, Select, Popup } from "gpui-base";
import { exec, run, props, closeOverlay, theme, knownAgents, home, shared, setShared, spaces, terminals, focused } from "herdr";
import { adapterFor } from "./agents.js";
import { branchFor, worktreeFolder, branchProblem, taskFor } from "./task.js";

const LAST_CHOICE = "linear-agent.last";
const MODEL_CACHE = "linear-agent.models";
const CACHE_MS = 60 * 60 * 1000;
// A virtual list needs every row's height up front: the row plus the 1px gap below it.
const MODEL_ROW_H = 27;

async function git(cwd, args, on) {
  const r = await exec("git", args, { cwd, on });
  return { ok: r.code === 0, out: (r.stdout ?? "").trim(), err: (r.stderr || r.stdout || "").trim() };
}

async function userHome(on) {
  if (!on) return home();
  const r = await exec("sh", ["-c", 'printf %s "$HOME"'], { on });
  if (r.code !== 0 || !r.stdout.trim()) throw new Error("Could not find the remote home folder.");
  return r.stdout.trim();
}

// origin's default branch: origin/HEAD (set by clone), else main or master.
async function defaultBranch(cwd, on) {
  const head = await git(cwd, ["symbolic-ref", "--short", "refs/remotes/origin/HEAD"], on);
  if (head.ok) return head.out.replace(/^origin\//, "");
  for (const name of ["main", "master"]) {
    if ((await git(cwd, ["show-ref", "--verify", "--quiet", `refs/remotes/origin/${name}`], on)).ok) return name;
  }
  return "";
}

// origin/<default branch>, fetched; HEAD when there's no origin to fetch from.
async function baseRef(cwd, on) {
  const name = await defaultBranch(cwd, on);
  if (!name || !(await git(cwd, ["fetch", "origin", name], on)).ok) return "HEAD";
  return `origin/${name}`;
}

// The main checkout of the repo `cwd` is in, so a worktree made from another worktree lands beside the rest.
async function mainCheckout(cwd, on) {
  if (!cwd) throw new Error("Open a space in a git repo, or map this team in linear.json");
  const common = await git(cwd, ["rev-parse", "--path-format=absolute", "--git-common-dir"], on);
  if (!common.ok) throw new Error(`Not a git repository: ${cwd}`);
  return common.out.endsWith("/.git") ? common.out.slice(0, -5) : common.out;
}

// Herdr's own worktree path, so the spaces sidebar nests it and Herdr's worktree dialog can remove it.
async function createWorktree(cwd, on, branch, identifier) {
  const problem = branchProblem(branch);
  if (problem) throw new Error(problem);
  const main = await mainCheckout(cwd, on);
  if (!(await git(main, ["check-ref-format", "--branch", branch], on)).ok) throw new Error(`Not a valid branch name: ${branch}`);
  const path = `${await userHome(on)}/.herdr/worktrees/${main.split("/").pop()}/${worktreeFolder(branch, identifier)}`;
  const exists = (await git(main, ["show-ref", "--verify", "--quiet", `refs/heads/${branch}`], on)).ok;
  const add = exists ? ["worktree", "add", path, branch] : ["worktree", "add", "-b", branch, path, await baseRef(main, on)];
  const r = await git(main, add, on);
  if (!r.ok) throw new Error(r.err.split("\n").pop() || "git worktree add failed");
  return path;
}

async function modelsFor(agent, on) {
  const cache = shared(MODEL_CACHE) ?? {};
  const key = `${on ?? ""}:${agent.key}`;
  if (cache[key] && Date.now() - cache[key].at < CACHE_MS) return cache[key].models;
  const models = await adapterFor(agent).models(on);
  setShared(MODEL_CACHE, { ...cache, [key]: { at: Date.now(), models } });
  return models;
}

export default class LinearAgent extends View {
  init(_props, cx) {
    this.issue = props()?.issue ?? { identifier: "", title: "Open this from an issue in the Linear panel", url: "", branchName: "" };
    this.agents = []; this.models = []; this.filter = "";
    // Where the worktree comes from: what the Linear panel passed, until a space is picked.
    this.target = { cwd: props()?.cwd ?? null, on: props()?.on ?? null };
    const last = shared(LAST_CHOICE) ?? {};
    this.subagents = Boolean(last.subagents);
    this.branchInput = InputState.new({ value: this.issue.identifier ? branchFor(this.issue) : "", placeholder: "branch name" });
    this.filterInput = InputState.new({ placeholder: "filter or type a model" });
    this.filterInput.on("change", (_e, cx) => { this.filter = this.filterInput.value().trim(); cx.notify(); });
    this.branchInput.on("submit", (_e, cx) => this.start(cx));
    this.modelScroll = VirtualListScrollHandle.new();
    this.spaceOpen = false; this.spaceAt = 0;
    this.spaceTrigger = cx.focus_handle(); this.spaceList = cx.focus_handle();
    // Something in the dialog must hold the keyboard, or Tab goes to whatever is behind it.
    // Again once the overlay has opened, as the shipped picker does.
    this.spaceTrigger.focus();
    cx.timer.after(600, () => this.spaceTrigger.focus());
    this.loadAgents(cx);
  }

  // Each space's folder: the focused pane's for the space you're in (as the Linear panel picks it),
  // else where the terminal it shows is now, else where its new terminals start.
  spaceChoices() {
    const cwds = new Map(terminals().map((x) => [x.address, x.cwd])), here = focused()?.cwd;
    return spaces().map((s) => {
      const shown = s.tabs.find((tab) => tab.active)?.terminals?.[0]?.terminal;
      return { id: s.id, name: s.name, cwd: (s.active && here) || cwds.get(shown) || s.folder, on: s.machine };
    }).filter((s) => s.cwd);
  }

  // Agents are per machine, so a space on another one lists its agents again.
  pickSpace(space, cx) {
    const moved = space.on !== this.target.on;
    this.target = { cwd: space.cwd, on: space.on };
    if (moved) { this.agents = []; this.loadAgents(cx); }
  }

  setSpaceOpen(open, choices) {
    this.spaceOpen = open;
    if (open) this.spaceAt = Math.max(0, choices.findIndex((s) => s.cwd === this.target.cwd && s.on === this.target.on));
    else this.spaceTrigger.focus();
  }

  // Select draws nothing and moves no highlight: the trigger, the list and its arrow keys are ours.
  repoSection(t) {
    const choices = this.spaceChoices(), { cwd, on } = this.target;
    const current = choices.find((s) => s.cwd === cwd && s.on === on);
    const choose = (s, cx) => { this.pickSpace(s, cx); this.setSpaceOpen(false, choices); };
    const trigger = h_flex().id("space-trigger").h(30).px(10).gap(8).items_center().rounded(8).cursor_pointer()
      .tab_index(0).border_1().border_color(this.spaceOpen ? t.accent : t.border).bg(t.background)
      .focus((s) => s.border_color(t.accent))
      .child(div().flex_none().text_color(t.foreground).child(current?.name ?? (props()?.mapped ? "From linear.json" : cwd ? "This folder" : "Pick a space")))
      .child(div().flex_1().min_w(0).truncate().text_size(11).text_color(cwd ? t.dim : t.ansi1)
        .child(cwd ? `${cwd}${on ? `  ·  ${on}` : ""}` : "No folder: pick a space in a git repo"))
      .child(div().flex_none().text_color(t.dim).child("▾"));
    const list = v_flex().id("space-list").track_focus(this.spaceList).w(448).p(4).gap(1).rounded(8)
      .border_1().border_color(t.border).bg(t.popover).shadow_lg()
      .on_key_down((e, cx) => {
        const step = { down: 1, j: 1, up: -1, k: -1 }[e.keystroke];
        if (step) {
          this.spaceAt = (this.spaceAt + step + choices.length) % choices.length;
        } else if (e.keystroke === "enter" && choices[this.spaceAt]) choose(choices[this.spaceAt], cx);
        else return;
        cx.stop_propagation(); cx.notify();
      })
      .children(choices.map((s, i) => h_flex().id(`space-${s.id}`).h(30).px(8).gap(8).items_center().rounded(6).cursor_pointer()
        .when(i === this.spaceAt, (e) => e.bg(t.hover)).when(s === current, (e) => e.text_color(t.foreground))
        .hover((st) => st.bg(t.hover)).on_click((_e, cx) => { choose(s, cx); cx.notify(); })
        .child(div().flex_none().w(110).truncate().child(s.name))
        .child(div().flex_1().min_w(0).truncate().text_size(11).text_color(t.dim).child(s.cwd))));
    return Select.new("space-select").open(Boolean(this.spaceOpen))
      .track_focus(this.spaceTrigger).content_focus_handle(this.spaceList)
      .on_open_change((open, cx) => { this.setSpaceOpen(open, choices); cx.notify(); })
      .child(Popup.new("space-popup", trigger).anchor("top_left")
        .when(Boolean(this.spaceOpen) && choices.length > 0, (el) => el.content(list)));
  }

  loadAgents(cx) {
    cx.spawn(async (cx) => {
      try {
        this.agents = (await knownAgents({ on: this.target.on })).filter((a) => a.installed);
        const last = shared(LAST_CHOICE) ?? {};
        this.pickAgent(this.agents.find((a) => a.key === last.agent) ?? this.agents[0], cx, last);
      } catch (e) { this.error = `Could not list agents: ${e}`; }
      cx.notify();
    });
  }

  pickAgent(agent, cx, last = {}) {
    if (!agent) { this.error = "No agent installed on this machine"; return; }
    this.agent = agent; this.models = []; this.model = null; this.effort = null; this.modelsError = null;
    this.filterInput.set_value(""); this.filter = "";
    if (!adapterFor(agent)) return cx.notify();
    this.loadingModels = true;
    cx.spawn(async (cx) => {
      try {
        const models = await modelsFor(agent, this.target.on);
        if (this.agent !== agent) return;
        this.models = models;
        const remembered = last.agent === agent.key ? models.find((m) => m.id === last.model) : null;
        this.pickModel(remembered ?? null, remembered ? last.effort : null);
      } catch (e) { if (this.agent === agent) this.modelsError = String(e.message ?? e); }
      finally { if (this.agent === agent) this.loadingModels = false; cx.notify(); }
    });
    cx.notify();
  }

  pickModel(model, effort = null) {
    this.model = model;
    const efforts = model?.efforts ?? [];
    this.effort = efforts.includes(effort) ? effort : efforts.includes(model?.effort) ? model.effort : null;
  }

  // The typed model when it matches none, so models a CLI can't list still work.
  chosenModelId() {
    if (this.model) return this.model.id;
    return this.filter && !this.models.some((m) => m.id === this.filter) ? this.filter : null;
  }

  start(cx) {
    const branch = this.branchInput.value().trim();
    if (this.busy || !this.agent || !branch || !this.issue.identifier) return;
    const { cwd, on } = this.target, agent = this.agent, model = this.chosenModelId(), effort = this.effort;
    const subagents = this.subagents, issue = this.issue;
    const argv = [...agent.run, ...(adapterFor(agent)?.flags(model, effort) ?? [])];
    this.busy = true; this.error = null;
    cx.spawn(async (cx) => {
      try {
        const folder = await createWorktree(cwd, on, branch, issue.identifier);
        setShared(LAST_CHOICE, { agent: agent.key, model, effort, subagents });
        run("space.new", { folder, machine: on, tab: issue.identifier, argv, task: taskFor(issue, branch, { subagents }) });
        closeOverlay(props().overlay);
      } catch (e) { this.error = String(e.message ?? e); }
      finally { this.busy = false; cx.notify(); }
    });
    cx.notify();
  }

  section(title, child, t) {
    return v_flex().gap(6).child(div().text_size(11).text_color(t.dim).child(title)).child(child);
  }

  // A Tab stop: an accent ring while it has the keyboard, and Enter or Space does what a click does.
  stop(el, ring, act, t) {
    return el.tab_index(0).border_1().border_color(ring).focus((s) => s.border_color(t.accent))
      .on_key_down((e, cx) => {
        if (e.keystroke !== "enter" && e.keystroke !== "space") return;
        act(cx); cx.stop_propagation(); cx.notify();
      });
  }

  // A chip that is no Tab stop of its own, for a row that takes the keyboard as a whole.
  chipBody(id, label, selected, onClick, t, icon = null) {
    return h_flex().id(id).h(26).px(9).gap(6).items_center().rounded(7).cursor_pointer().flex_none()
      .bg(selected ? t.selected : t.raised).text_color(selected ? t.foreground : t.muted)
      .hover((s) => s.bg(t.hover)).on_click((_e, cx) => { onClick(cx); cx.notify(); })
      .when(Boolean(icon), (e) => e.child(icon)).child(label);
  }

  chip(id, label, selected, onClick, t, icon = null) {
    return this.stop(this.chipBody(id, label, selected, onClick, t, icon), selected ? t.selected : t.raised, onClick, t);
  }

  field(state, t) {
    return div().h(30).px(10).flex().items_center().rounded(8).border_1().border_color(t.border).bg(t.background)
      .child(Input.new(state).h_full().text_size(12).text_color(t.foreground));
  }

  agentIcon(a, t) {
    if (!a.icon) return null;
    return a.tint ? svg(a.icon).size(14).text_color(t.foreground) : image(a.icon).size(14);
  }

  agentRow(t) {
    if (!this.agents.length) return div().text_color(t.dim).child(this.error ?? "Checking installed agents…");
    return h_flex().flex_wrap().gap(6).children(this.agents.map((a) =>
      this.chip(`agent-${a.key}`, a.name, this.agent === a, (cx) => this.pickAgent(a, cx), t, this.agentIcon(a, t))));
  }

  // The agent's default (or the typed model), then the models matching the filter.
  modelRows() {
    const f = this.filter.toLowerCase();
    const shown = this.models.filter((m) => !f || `${m.id} ${m.label ?? ""}`.toLowerCase().includes(f)).slice(0, 100);
    const custom = this.chosenModelId() && !this.model ? this.chosenModelId() : null;
    return [{ id: "default", label: custom ? `Use "${custom}"` : "Agent's default", model: null },
      ...shown.map((m) => ({ id: m.id, label: m.label && m.label !== m.id ? `${m.label}  ·  ${m.id}` : m.id, model: m }))];
  }

  // Up/down or j/k while the model list has the keyboard: one Tab stop rather than one per model.
  stepModel(step) {
    const rows = this.modelRows();
    const next = Math.max(0, Math.min(rows.length - 1, rows.findIndex((r) => r.model === this.model) + step));
    this.pickModel(rows[next].model, this.effort);
    this.modelScroll.scroll_to_item(next);
  }

  // Drawn inside the virtual list's renderer, where handlers throw: clicks go through the list's on_item_click.
  modelRow(row, t) {
    const selected = this.model === row.model;
    return div().w_full().h(MODEL_ROW_H).pb(1).child(h_flex().id(`model-${row.id}`).h_full().px(8).items_center().rounded(6).cursor_pointer()
      .when(selected, (e) => e.bg(t.selected)).hover((s) => s.bg(t.hover))
      .child(div().flex_1().min_w(0).truncate().text_color(selected ? t.foreground : t.muted).child(row.label)));
  }

  modelList(t) {
    const rows = this.modelRows();
    return v_flex().gap(6).child(this.field(this.filterInput, t))
      .child(div().id("models").h(150).relative().rounded(7).tab_index(0).border_1().border_color(t.popover)
        .focus((s) => s.border_color(t.accent))
        .on_key_down((e, cx) => {
          const step = { down: 1, j: 1, up: -1, k: -1 }[e.keystroke];
          if (!step) return;
          this.stepModel(step); cx.stop_propagation(); cx.notify();
        })
        .child(v_virtual_list("model-list", rows.length, MODEL_ROW_H, (i) => rows[i].id,
          (range) => rows.slice(range.start, range.end).map((r) => this.modelRow(r, t)))
          .track_scroll(this.modelScroll).size_full()
          .on_item_click((id) => { const row = rows.find((r) => r.id === id); if (row) this.pickModel(row.model, this.effort); }))
        .child(Scrollbar.vertical("model-list").absolute().inset_0()))
      .when(this.loadingModels, (e) => e.child(div().px(8).text_color(t.dim).child("Loading models…")))
      .when(Boolean(this.modelsError), (e) => e.child(div().px(8).text_color(t.ansi1).child(this.modelsError)));
  }

  effortRow(t) {
    const efforts = this.model?.efforts ?? [];
    if (!efforts.length) return div().text_color(t.dim).child(this.model ? "This model has no reasoning levels" : "Agent's default");
    // "auto" (null) passes no level, so the agent picks its own.
    const levels = [null, ...efforts];
    // One Tab stop: h/l or left/right picks the level beside the chosen one, so the ring and the choice agree.
    return h_flex().id("efforts").flex_wrap().gap(6).p(3).rounded(9).tab_index(0).border_1().border_color(t.popover)
      .focus((s) => s.border_color(t.accent))
      .on_key_down((e, cx) => {
        const step = { right: 1, l: 1, left: -1, h: -1 }[e.keystroke];
        if (!step) return;
        const at = levels.indexOf(this.effort);
        this.effort = levels[Math.max(0, Math.min(levels.length - 1, at + step))];
        cx.stop_propagation(); cx.notify();
      })
      .children(levels.map((e) =>
        this.chipBody(`effort-${e ?? "auto"}`, e ?? "auto", this.effort === e, () => { this.effort = e; }, t)));
  }

  footer(t) {
    const ready = Boolean(this.agent) && !this.busy;
    return h_flex().gap(8).items_center()
      .child(div().flex_1().min_w(0).text_size(11).text_color(t.ansi1).child(this.error ?? ""))
      .child(this.stop(h_flex().id("cancel").h(30).px(12).items_center().rounded(8).cursor_pointer().text_color(t.muted)
        .hover((s) => s.bg(t.hover)).on_click(() => closeOverlay(props().overlay)).child("Cancel"),
        t.popover, () => closeOverlay(props().overlay), t))
      .child(this.stop(h_flex().id("start").h(30).px(14).items_center().rounded(8).cursor_pointer()
        .bg(ready ? t.solid : t.raised).text_color(ready ? t.solid_foreground : t.dim)
        .on_click((_e, cx) => this.start(cx)).child(this.busy ? "Starting…" : "Start agent"),
        ready ? t.solid : t.raised, (cx) => this.start(cx), t));
  }

  render() {
    const t = theme(), hasModels = this.agent && adapterFor(this.agent);
    // The sections scroll and the footer stays, so Start is always reachable in a short window.
    return v_flex().id("linear-agent").size_full().p(16).gap(14).bg(t.popover).text_color(t.foreground).text_size(12.5)
      .child(v_flex().flex_none().gap(2)
        .child(div().text_size(14).font_semibold().child(`Start an agent on ${this.issue.identifier}`))
        .child(div().text_color(t.dim).truncate().child(this.issue.title)))
      .child(v_flex().id("linear-agent-body").flex_1().min_h(0).overflow_y_scrollbar().gap(14)
        .child(this.section("Repository", this.repoSection(t), t))
        .child(this.section("Branch", this.field(this.branchInput, t), t))
        .child(this.section("Agent", this.agentRow(t), t))
        .when(Boolean(hasModels), (e) => e.child(this.section("Model", this.modelList(t), t)).child(this.section("Reasoning", this.effortRow(t), t)))
        .child(this.section("Options", h_flex().child(this.chip("subagents", this.subagents ? "✓ Ask it to use subagents" : "Ask it to use subagents",
          this.subagents, () => { this.subagents = !this.subagents; }, t)), t)))
      .child(div().flex_none().child(this.footer(t)));
  }
}
