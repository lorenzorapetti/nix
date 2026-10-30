import { div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { machines, spaces, panes, exec, run, theme, notify, openOverlay, closeOverlay } from "herdr";
import { DOCKER, PROBE, parseProbe, containerHealth, needsAttention, usage, containerAlerts, processHealth, processNeedsAttention, processAlerts } from "./probe.js";
import { DEMO } from "./demo.js";

const REFRESH_MS = 30000;
const METER_PX = 84;
const label = (machine) => machine ?? "This computer";
// The pane showing the Herdr terminal a `devenv up` runs in; another machine's are "<machine>/t5".
function paneFor(machine, terminal) {
  if (!terminal) return null;
  const address = machine ? `${machine}/${terminal}` : terminal;
  return panes().find((p) => p.terminal === address) ?? null;
}

// One row's key, for its confirm and restarting states: a container's name, or a devenv process's project and name.
const rowKey = (machine, name, dir = null) => `${label(machine)}/${dir ? `${dir}:` : ""}${name}`;

// Herdr's machines by name, then this computer.
function machineList() {
  const list = machines();
  const offline = new Set(list.filter((m) => m.layout === "unavailable").map((m) => m.name));
  const names = [...new Set(list.map((m) => m.name).filter(Boolean))].sort();
  return [...names, null].map((name) => ({ name, offline: offline.has(name) }));
}

function healthColor(health, t) {
  return { ok: t.ansi2, starting: t.blocked, restarting: t.blocked, unhealthy: t.ansi1, down: t.ansi1 }[health] ?? t.dim;
}

function levelColor(pct, t) {
  if (pct >= 90) return t.ansi1;
  return pct >= 75 ? t.blocked : t.accent;
}

const days = (seconds) => (seconds >= 86400 ? `${Math.floor(seconds / 86400)}d` : `${Math.floor(seconds / 3600)}h`);

function sortContainers(list) {
  return [...list].sort((a, b) => needsAttention(b) - needsAttention(a) || a.project.localeCompare(b.project) || a.name.localeCompare(b.name));
}

export class Panel {
  init(p, cx) {
    this.demo = Boolean(p?.demo); this.expanded = new Set(); this.overlay = p?.overlay ?? null;
    this.stats = this.demo ? Object.fromEntries(DEMO.map((m) => [m.name, { data: m.stats }])) : {};
    if (this.demo) return;
    this.refresh(cx);
    cx.timer.every(REFRESH_MS, (cx) => this.refresh(cx));
  }

  machinesShown() {
    return this.demo ? DEMO.map((m) => ({ name: m.name, offline: false })) : machineList();
  }

  refresh(cx) {
    if (this.loading || this.demo) return;
    this.loading = true;
    cx.spawn(async (cx) => {
      try { await Promise.all(machineList().map((m) => this.probe(m))); }
      finally { this.loading = false; cx.notify(); }
    });
    cx.notify();
  }

  async probe(machine) {
    const key = label(machine.name);
    if (machine.offline) { this.stats[key] = { offline: true }; return; }
    try {
      const r = await exec("sh", ["-c", PROBE], { on: machine.name });
      const data = parseProbe(r.stdout);
      this.announce(key, this.stats[key]?.data, data);
      this.stats[key] = { data };
    } catch (e) { this.stats[key] = { error: String(e.message ?? e) }; }
  }

  announce(machine, before, after) {
    for (const alert of [...containerAlerts(before, after), ...processAlerts(before, after)]) {
      if (alert.down) notify({ title: `${alert.name} is ${alert.health}`, body: machine, level: "error" });
      else notify({ title: `${alert.name} is back`, body: machine, level: "success", timeout: 6000 });
    }
  }

  // A container: `docker restart`; a devenv process (`dir` set): `devenv processes restart` in its project.
  restart(machine, name, cx, dir = null) {
    const key = rowKey(machine, name, dir);
    const script = dir ? 'cd "$2" && devenv processes restart "$1"' : `${DOCKER}\n$docker restart -- "$1"`;
    this.confirming = null; this.restarting = key;
    cx.spawn(async (cx) => {
      try {
        const r = await exec("sh", ["-c", script, "sh", name, dir ?? ""], { on: machine });
        if (r.code !== 0) notify({ title: `Couldn't restart ${name}`, body: (r.stderr || r.stdout).trim().split("\n")[0], level: "error" });
        await this.probe(machineList().find((m) => m.name === machine) ?? { name: machine });
      } finally { this.restarting = null; cx.notify(); }
    });
    cx.notify();
  }

  // Shows the pane's space and tab, focuses it, and closes the popup so it's in view.
  goTo(pane) {
    const space = spaces().find((s) => (s.tabs ?? []).some((tab) => tab.id === pane.tab));
    if (space) run("space.select", { id: space.id });
    run("tab.select", { id: pane.tab });
    run("pane.focus", { pane: pane.pane });
    if (this.overlay) closeOverlay(this.overlay);
  }

  showLogs(machine, name, dir = null) {
    openOverlay({ mod: "servers", kind: "dialog", width: 760, height: 520, props: { view: "logs", machine, container: name, dir } });
  }

  meter(name, pct, t) {
    const color = pct === null ? t.dim : levelColor(pct, t);
    return v_flex().flex_1().min_w(0).gap(4)
      .child(h_flex().justify_between().text_size(10.5)
        .child(div().text_color(t.dim).child(name))
        .child(div().text_color(color).child(pct === null ? "–" : `${pct}%`)))
      .child(div().w(METER_PX).h(4).rounded(2).bg(t.raised)
        .child(div().h(4).rounded(2).bg(color).w(Math.round((METER_PX * (pct ?? 0)) / 100))));
  }

  action(id, text, onClick, t, color = t.muted) {
    return div().id(id).px(6).h(20).flex().items_center().rounded(5).cursor_pointer().text_size(11).text_color(color)
      .hover((s) => s.bg(t.raised)).on_click((_e, cx) => onClick(cx)).child(text);
  }

  confirmRow(machine, name, dir, t) {
    const key = rowKey(machine, name, dir);
    return h_flex().gap(6).items_center().flex_1().min_w(0)
      .child(div().flex_1().min_w(0).truncate().text_color(t.ansi1).child(`Restart ${name}?`))
      .child(this.action(`yes-${key}`, "Restart", (cx) => this.restart(machine, name, cx, dir), t, t.ansi1))
      .child(this.action(`no-${key}`, "Cancel", (cx) => { this.confirming = null; cx.notify(); }, t));
  }

  // A container or devenv process: health dot, name, status, then Logs and Restart.
  serviceRow(machine, name, dir, health, status, t) {
    const key = rowKey(machine, name, dir);
    const row = h_flex().id(`ct-${key}`).h(26).px(6).gap(8).items_center().rounded(6).hover((s) => s.bg(t.hover))
      .child(div().size(7).flex_none().rounded(4).bg(healthColor(health, t)));
    if (this.confirming === key) return row.child(this.confirmRow(machine, name, dir, t));
    const busy = this.restarting === key;
    return row
      .child(div().flex_none().max_w(150).truncate().child(name))
      .child(div().flex_1().min_w(0).truncate().text_size(11).text_color(busy ? t.blocked : t.dim).child(busy ? "Restarting…" : status))
      .when(!busy, (e) => e
        .child(this.action(`logs-${key}`, "Logs", () => this.showLogs(machine, name, dir), t))
        .child(this.action(`restart-${key}`, "Restart", (cx) => { this.confirming = key; cx.notify(); }, t)));
  }

  containerRow(machine, c, t) {
    return this.serviceRow(machine, c.name, null, containerHealth(c), c.status, t);
  }

  processRow(machine, p, t) {
    const status = [p.state, p.ports, p.restarts ? `${p.restarts} restarts` : ""].filter(Boolean).join(" · ");
    return this.serviceRow(machine, p.name, p.dir, processHealth(p), status, t);
  }

  // Every running `devenv up`, one group per project; nothing at all on a machine without one.
  processesSection(machine, processes, t) {
    const projects = [...new Set(processes.map((p) => p.dir))].sort();
    return v_flex().gap(2).children(projects.map((dir) => {
      const list = processes.filter((p) => p.dir === dir), bad = list.filter(processNeedsAttention).length;
      const pane = paneFor(machine, list[0].terminal);
      return v_flex().gap(2)
        .child(h_flex().gap(8).items_center().text_size(11).text_color(t.dim)
          .child(div().flex_none().text_color(t.muted).child(dir.split("/").pop()))
          .child(div().flex_1().min_w(0).truncate().child(`devenv · ${list.length} processes`))
          .when(bad > 0, (e) => e.child(div().flex_none().text_color(t.ansi1).child(`${bad} need you`)))
          .when(Boolean(pane), (e) => e.child(this.action(`go-${rowKey(machine, dir)}`, "Go to terminal", () => this.goTo(pane), t))))
        .children(list.map((p) => this.processRow(machine, p, t)));
    }));
  }

  // A `compose up` running in a Herdr terminal, matched to its containers by their project folder.
  composeRows(machine, containers, compose, t) {
    const runs = [...new Map(compose.map((c) => [c.dir, c])).values()]
      .map((run) => ({ ...run, pane: paneFor(machine, run.terminal), containers: containers.filter((c) => c.workdir === run.dir) }))
      .filter((run) => run.pane && run.containers.length);
    return runs.map((run) => h_flex().gap(8).items_center().text_size(11).text_color(t.dim)
      .child(div().flex_none().text_color(t.muted).child(run.containers[0].project || run.dir.split("/").pop()))
      .child(div().flex_1().min_w(0).truncate().child(`compose up · ${run.containers.length} containers`))
      .child(this.action(`go-${rowKey(machine, run.dir)}`, "Go to terminal", () => this.goTo(run.pane), t)));
  }

  dockerSection(machine, docker, t, compose = []) {
    if (docker.error) return div().text_size(11).text_color(t.dim).child(`Docker: ${docker.error}`);
    const all = sortContainers(docker.containers), key = label(machine);
    if (!all.length) return div().text_size(11).text_color(t.dim).child("No containers");
    const open = this.expanded.has(key), bad = all.filter(needsAttention);
    const running = all.filter((c) => c.state === "running").length;
    const shown = open ? all : bad;
    return v_flex().gap(2)
      .child(h_flex().gap(8).items_center().text_size(11).text_color(t.dim)
        .child(div().child(`${all.length} containers · ${running} running`))
        .when(bad.length > 0, (e) => e.child(div().text_color(t.ansi1).child(`${bad.length} need you`)))
        .child(div().flex_1())
        .child(this.action(`toggle-${key}`, open ? "Hide" : "Show all", (cx) => {
          if (open) this.expanded.delete(key); else this.expanded.add(key);
          cx.notify();
        }, t)))
      .children(this.composeRows(machine, all, compose, t))
      .children(shown.map((c) => this.containerRow(machine, c, t)));
  }

  card(machine, t) {
    const entry = this.stats[label(machine.name)];
    const head = h_flex().gap(8).items_center()
      .child(div().size(8).rounded(4).bg(entry?.data ? t.ansi2 : entry ? t.ansi1 : t.dim))
      .child(div().font_semibold().child(label(machine.name)))
      .child(div().flex_1())
      .when(Boolean(entry?.data?.uptime), (e) => e.child(div().text_size(11).text_color(t.dim).child(`up ${days(entry.data.uptime)}`)));
    const box = v_flex().id(`machine-${label(machine.name)}`).flex_none().p(12).gap(10).rounded(9).border_1().border_color(t.border).bg(t.surface).child(head);
    if (!entry) return box.child(div().text_size(11).text_color(t.dim).child("Loading…"));
    if (entry.offline) return box.child(div().text_size(11).text_color(t.dim).child("Offline"));
    if (entry.error) return box.child(div().text_size(11).text_color(t.ansi1).child(entry.error));
    const u = usage(entry.data);
    return box
      .child(h_flex().gap(12).child(this.meter("CPU", u.cpu, t)).child(this.meter("MEM", u.mem, t)).child(this.meter("DISK", u.disk, t)))
      .child(this.dockerSection(machine.name, entry.data.docker, t, entry.data.compose ?? []))
      .when(Boolean(entry.data.processes?.length), (e) => e.child(this.processesSection(machine.name, entry.data.processes, t)));
  }

  render() {
    const t = theme(), shown = this.machinesShown();
    const attention = Object.values(this.stats).reduce((n, s) => n + (s.data?.docker.containers ?? []).filter(needsAttention).length
      + (s.data?.processes ?? []).filter(processNeedsAttention).length, 0);
    return v_flex().id("servers").size_full().min_h(0).rounded(10).overflow_hidden().bg(t.background).border_1().border_color(t.border).text_color(t.foreground).text_size(12.5)
      .child(h_flex().h(42).flex_none().px(14).gap(8).items_center().border_b(1).border_color(t.border)
        .child(div().font_semibold().child("Servers"))
        .when(attention > 0, (e) => e.child(div().px(6).rounded(5).bg(`${t.ansi1}33`).text_size(11).text_color(t.ansi1).child(`${attention} need you`)))
        .child(div().flex_1())
        .child(div().id("servers-refresh").px(8).h(26).flex().items_center().rounded(7).cursor_pointer().text_size(11).text_color(t.muted)
          .hover((s) => s.bg(t.hover)).on_click((_e, cx) => this.refresh(cx)).child(this.loading ? "…" : "Refresh")))
      .child(v_flex().id("servers-list").flex_1().min_h(0).overflow_y_scrollbar().p(8).gap(8)
        .children(shown.map((m) => this.card(m, t))));
  }
}
