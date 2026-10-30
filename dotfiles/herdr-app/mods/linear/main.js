// Your open Linear issues, with an `Agent` button that starts an agent on one in a new worktree.
import { View, div, svg } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { spaces, panes, focused, exec, theme, home, appHome, readTextFile, nextCommand, openOverlay, closeOverlay, run, props, shared, setShared } from "herdr";
import { API_URL, ISSUES_QUERY, STATUSES, parseConfig, parseIssues, linearError, filterIssues, ago } from "./linear.js";
import { openUrl } from "./open.js";

const REFRESH_MS = 60000;
// The last issues fetched, persisted, so the panel opens with them while it fetches fresh ones.
const CACHE_KEY = "linear.issues";
const NO_KEY = "No Linear API key. Add it to ~/.config/herdr-app/linear.json or set LINEAR_API_KEY.";

// LINEAR_API_KEY from the shell agents start in, when linear.json has none.
async function envKey() {
  const r = await exec("sh", ["-c", 'printf %s "$LINEAR_API_KEY"']).catch(() => null);
  return r?.code === 0 && r.stdout.trim() ? r.stdout.trim() : null;
}

async function loadConfig() {
  const text = await readTextFile(`${appHome()}/linear.json`).catch(() => null);
  const config = parseConfig(text, home());
  if (!config.apiKey && !config.error) config.apiKey = await envKey();
  return config;
}

async function fetchIssues(apiKey) {
  const r = await fetch(API_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: apiKey },
    body: JSON.stringify({ query: ISSUES_QUERY }),
  });
  const body = await r.text();
  if (!r.ok) throw new Error(linearError(r.status, body));
  return parseIssues(JSON.parse(body));
}

// The focused pane's folder (else the focused terminal's, else the shown space's) and its machine.
function location() {
  const space = spaces().find((s) => s.active), f = focused();
  const pane = f?.pane ? panes().find((p) => p.pane === f.pane) : null;
  const on = f?.pane === null ? (f.terminal?.includes("/") ? f.terminal.split("/")[0] : null) : space?.machine ?? null;
  return { cwd: pane?.cwd || f?.cwd || space?.folder, on };
}

// The space already on the issue's branch (its worktree, say), if any.
const spaceFor = (issue) => (issue.branchName ? spaces().find((s) => s.branch === issue.branchName) : null);

const PRIORITY_COLORS = { 1: "ansi1", 2: "working" };
// A row plus the 2px gap below it: the list pages by whole rows.
const ROW_H = 62;
const LIST_PAD = 6;
const STATUS_KEYS = { a: "all", t: "todo", i: "doing", b: "backlog" };

export default class Linear extends View {
  init(_props, cx) {
    const cached = shared(CACHE_KEY);
    this.issues = Array.isArray(cached?.issues) ? cached.issues : []; this.fetchedAt = cached?.at ?? null;
    this.status = "all"; this.text = ""; this.generation = 0; this.loading = false;
    this.search = InputState.new({ placeholder: "Filter by id or title" });
    this.search.on("change", (_e, cx) => { this.text = this.search.value(); this.selected = null; this.top = 0; cx.notify(); });
    this.search.on("focus", (_e, cx) => { this.typing = true; cx.notify(); });
    this.search.on("blur", (_e, cx) => { this.typing = false; cx.notify(); });
    this.selected = null; // the selected issue's id, so a refresh or filter keeps it; the pointer selects too
    // The list draws only the rows that fit from `top` down, rather than being a virtual list: one of
    // those can't tell which row the pointer is on, and the keys must act on the hovered row.
    this.top = 0; // the first row drawn, numbered 1
    this.fits = 8; // how many rows fit, from the list's size
    this.listH = 0;
    this.wheel = 0; // scrolled pixels not yet a whole row
    this.focus = cx.focus_handle();
    // Again once the overlay has opened, as the shipped picker does: it takes the keyboard as it opens.
    this.focus.focus();
    cx.timer.after(300, () => this.focus.focus());
    cx.timer.after(700, () => { if (!this.typing) this.focus.focus(); });
    // Escape is a binding (the overlay's close), so only a deeper context's binding beats it.
    cx.bind_keys([{ keystroke: "escape", action: "linear.blur_search", context: "LinearSearch" }]);
    this.refresh(cx);
    cx.timer.every(REFRESH_MS, (cx) => this.refresh(cx));
    cx.spawn(async (cx) => {
      for (;;) {
        const command = await nextCommand();
        if (command === "refresh") this.refresh(cx);
        cx.notify();
      }
    });
  }

  refresh(cx) {
    const generation = ++this.generation;
    this.loading = true;
    cx.spawn(async (cx) => {
      try {
        const config = await loadConfig();
        this.config = config;
        if (config.error) throw new Error(config.error);
        if (!config.apiKey) throw new Error(NO_KEY);
        const issues = await fetchIssues(config.apiKey);
        if (generation === this.generation) {
          this.issues = issues; this.error = null; this.fetchedAt = new Date().toISOString();
          setShared(CACHE_KEY, { issues, at: this.fetchedAt });
        }
      } catch (e) { if (generation === this.generation) this.error = String(e.message ?? e); }
      finally { if (generation === this.generation) this.loading = false; cx.notify(); }
    });
    cx.notify();
  }

  // A space already on the issue's branch (its worktree, say) is shown instead: no second agent on it.
  // Otherwise a team mapped in linear.json works on that folder here, else the space you're in.
  startAgent(issue) {
    const existing = spaceFor(issue);
    if (existing) {
      run("space.select", { id: existing.id });
      closeOverlay(props()?.overlay);
      return;
    }
    const { cwd, on } = location(), mapped = this.config?.repos?.[issue.team];
    openOverlay({ mod: "linear-agent", kind: "dialog", width: 480, height: 660,
      props: { issue, cwd: mapped ?? cwd, on: mapped ? null : on, mapped: Boolean(mapped) } });
  }

  visible() {
    return filterIssues(this.issues, { status: this.status, text: this.text });
  }

  setStatus(id) {
    this.status = id; this.selected = null; this.top = 0;
  }

  scrollTo(top, count) {
    this.top = Math.max(0, Math.min(Math.max(0, count - this.fits), top));
  }

  // j/k or down/up: the next or previous issue, scrolled into view.
  move(step) {
    const list = this.visible();
    if (!list.length) return;
    const at = list.findIndex((i) => i.id === this.selected);
    const next = at < 0 ? this.top : Math.max(0, Math.min(list.length - 1, at + step));
    this.selected = list[next].id;
    if (next < this.top) this.scrollTo(next, list.length);
    else if (next >= this.top + this.fits) this.scrollTo(next - this.fits + 1, list.length);
  }

  // Whole rows at a time, keeping the remainder so a touchpad's small steps add up.
  onWheel(e, count) {
    this.wheel -= e.delta.y;
    const rows = Math.trunc(this.wheel / (ROW_H / 2));
    if (!rows) return false;
    this.wheel -= rows * (ROW_H / 2);
    const before = this.top;
    this.scrollTo(this.top + rows, count);
    return this.top !== before;
  }

  // Letters navigate anywhere in the panel, except while typing in the search bar.
  onKey(e, cx) {
    if (this.typing) return;
    const m = e.modifiers;
    if (m.control || m.alt || m.platform || m.shift) return;
    const issue = this.visible().find((i) => i.id === this.selected);
    if (STATUS_KEYS[e.key]) this.setStatus(STATUS_KEYS[e.key]);
    else if (e.key === "f") this.search.focus();
    else if (e.key === "r") this.refresh(cx);
    else if (e.key === "j" || e.key === "down") this.move(1);
    else if (e.key === "k" || e.key === "up") this.move(-1);
    else if (e.key === "enter" && issue) this.startAgent(issue);
    else if (e.key === "o" && issue) openUrl(issue.url);
    else if (e.key === "g" && issue?.prUrl) openUrl(issue.prUrl);
    else if (/^[0-9]$/.test(e.key)) this.selectNumbered(e.key);
    else return;
    cx.stop_propagation();
    cx.notify();
  }

  // 1-9 then 0: the rows from the top of the scrolled view, as their badges show. Only selects:
  // a row has several actions (enter, o, g), so the next key picks one.
  selectNumbered(digit) {
    const slot = digit === "0" ? 9 : Number(digit) - 1;
    const issue = slot < this.fits ? this.visible()[this.top + slot] : null;
    if (issue) this.selected = issue.id;
  }

  chip(status, t) {
    const active = this.status === status.id;
    return h_flex().id(`status-${status.id}`).h(24).px(8).flex_none().items_center().rounded(6).cursor_pointer().text_size(11)
      .bg(active ? t.selected : t.raised).text_color(active ? t.foreground : t.muted)
      .hover((s) => s.bg(t.hover)).on_click((_e, cx) => { this.setStatus(status.id); cx.notify(); }).child(status.label);
  }

  meta(issue, t) {
    const priority = issue.priority > 0 ? issue.priorityLabel : null;
    return h_flex().flex_1().min_w(0).gap(8).items_center().overflow_hidden()
      .child(h_flex().flex_none().gap(5).items_center()
        .child(div().size(7).rounded_full().bg(issue.stateColor ?? t.dim))
        .child(div().text_color(t.muted).child(issue.state)))
      .when(Boolean(priority), (e) => e.child(div().flex_none().text_color(t[PRIORITY_COLORS[issue.priority]] ?? t.dim).child(priority)))
      .children(issue.labels.slice(0, 2).map((l) => div().flex_none().px(5).rounded(4).border_1()
        .border_color(`${l.color}88`).text_color(t.muted).child(l.name)));
  }

  // Hovering selects, so the keys act on the row under the pointer.
  row(issue, t, slot, open) {
    return div().w_full().h(ROW_H).flex_none().pb(2).child(v_flex().id(`issue-${issue.id}`).h_full().justify_center().px(10).gap(3).rounded(7).cursor_pointer()
      .when(this.selected === issue.id, (e) => e.bg(t.selected))
      .hover((s) => s.bg(t.hover))
      .on_hover((hovered, cx) => { if (hovered && this.selected !== issue.id) { this.selected = issue.id; cx.notify(); } })
      .on_click((_e, cx) => { this.selected = issue.id; openUrl(issue.url); cx.notify(); })
      .child(h_flex().gap(8).items_center()
        .child(div().flex_none().text_size(11).text_color(t.accent).child(issue.identifier))
        .child(div().flex_1().min_w(0).truncate().child(issue.title))
        .when(open, (e) => e.child(svg("mods/workspace-chrome/git-branch.svg").size(13).flex_none().text_color(t.working)))
        .when(Boolean(issue.prUrl), (e) => e.child(svg("mods/workspace-chrome/git-compare.svg").size(13).flex_none().text_color(t.done)))
        .child(div().flex_none().w(16).h(16).flex().items_center().justify_center().rounded(4).border_1().border_color(t.border)
          .text_size(10).text_color(t.dim).when(slot < 10, (e) => e.child(String((slot + 1) % 10)))
          .when(slot >= 10, (e) => e.border_color(t.background))))
      .child(h_flex().gap(8).items_center().text_size(11).text_color(t.dim)
        .child(this.meta(issue, t))
        .child(div().flex_none().child(`${issue.team} · ${ago(issue.updatedAt)}`))));
  }

  // Cached issues show at once, so say how old they are and whether the refresh behind them failed.
  freshness() {
    if (!this.issues.length) return "";
    if (this.loading) return "updating…";
    if (this.error) return this.error;
    return this.fetchedAt ? `updated ${ago(this.fetchedAt)} ago` : "";
  }

  emptyText() {
    if (this.error) return this.error;
    if (this.loading) return "Loading…";
    return this.issues.length ? "No issues match these filters" : "No open issues assigned to you";
  }

  render() {
    const t = theme(), list = this.visible(), branches = new Set(spaces().map((s) => s.branch).filter(Boolean));
    this.scrollTo(this.top, list.length); // a refresh or a filter can leave fewer rows
    const top = this.top;
    return v_flex().id("linear").track_focus(this.focus).size_full().min_h(0).rounded(10).overflow_hidden().bg(t.background).border_1().border_color(t.border)
      .text_color(t.foreground).text_size(13)
      .on_key_down((e, cx) => this.onKey(e, cx))
      .on_mouse_down("left", () => this.focus.focus())
      .child(h_flex().h(42).flex_none().px(14).gap(8).items_center().border_b(1).border_color(t.border)
        .child(div().font_semibold().child("Linear"))
        .child(div().flex_none().text_size(11).text_color(t.dim).child(`${this.issues.length} open`))
        .child(div().flex_1().min_w(0).truncate().text_size(11).text_color(this.error ? t.ansi1 : t.dim).child(this.freshness()))
        .child(div().id("refresh").px(8).h(26).flex().items_center().rounded(7).cursor_pointer().text_size(11).text_color(t.muted)
          .hover((s) => s.bg(t.hover)).on_click((_e, cx) => this.refresh(cx)).child(this.loading ? "…" : "Refresh (r)")))
      .child(h_flex().h(38).flex_none().px(8).gap(6).items_center().border_b(1).border_color(t.border)
        .children(STATUSES.map((s) => this.chip(s, t)))
        .child(div().id("linear-search").flex_1().min_w(0).h(24).px(8).flex().items_center().rounded(6).border_1()
          .border_color(this.typing ? t.accent : t.border).bg(t.background)
          .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
          .key_context("LinearSearch").on_action("linear.blur_search", (_e, cx) => { this.typing = false; this.focus.focus(); cx.notify(); })
          .child(Input.new(this.search).h_full().text_size(11).text_color(t.foreground))))
      .child(v_flex().id("linear-list").flex_1().min_h(0).relative().overflow_hidden().p(LIST_PAD)
        .on_size_change((size, cx) => {
          this.listH = size.height;
          this.fits = Math.max(1, Math.floor((size.height - 2 * LIST_PAD) / ROW_H));
          cx.notify();
        })
        .on_scroll_wheel((e, cx) => { if (this.onWheel(e, list.length)) cx.notify(); })
        .children(list.slice(top, top + this.fits).map((issue, i) => this.row(issue, t, i, branches.has(issue.branchName))))
        .when(list.length > this.fits, (e) => e.child(this.scrollbar(top, list.length, t)))
        .when(!list.length, (e) => e.child(div().p(8).text_color(this.error ? t.ansi1 : t.dim).child(this.emptyText()))));
  }

  // Where the shown rows sit in the whole list; for reading, not dragging.
  scrollbar(top, count, t) {
    const track = this.listH - 2 * LIST_PAD;
    const h = Math.max(24, track * this.fits / count);
    return div().absolute().right(2).top(LIST_PAD + (track - h) * top / Math.max(1, count - this.fits))
      .w(4).h(h).rounded(2).bg(t.border);
  }
}
