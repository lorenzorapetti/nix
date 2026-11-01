// Names each tab after what runs in it: its agent, else its focused or first terminal's program
// ("Claude Code", "Neovim", "fish"). The agents list shows an agent's own title in place of a tab
// named after its program, so an agent's row reads "space · <session title>".
// A tab someone renames by hand is left alone. Draws nothing: it lives in a 0px layout block.

import { View, div } from "gpui-kit";
import { spaces, panes, run } from "herdr";

const KEY = "tab-names.ours";

// The pane a tab is about, as the agents list picks it.
function lead(tab, all) {
  const mine = all.filter((p) => p.tab === tab.id && p.terminal);
  return mine.find((p) => p.program?.agent) ?? mine.find((p) => p.focused) ?? mine[0];
}

export default class TabNames extends View {
  init(_props, cx) {
    // Tab id -> the name this mod gave it; a named tab with another name was renamed by hand.
    try { this.ours = JSON.parse(localStorage.getItem(KEY) ?? "{}"); } catch { this.ours = {}; }
    cx.timer.every(1000, () => this.sync());
    this.sync();
  }

  sync() {
    const all = panes();
    const tabs = spaces().flatMap((s) => s.tabs ?? []);
    const ours = {};
    for (const tab of tabs) {
      if (tab.named && tab.name !== this.ours[tab.id]) continue;
      const name = lead(tab, all)?.program?.name ?? this.ours[tab.id];
      if (!name) continue;
      if (name !== tab.name) run("tab.rename", { id: tab.id, name });
      ours[tab.id] = name;
    }
    if (JSON.stringify(ours) === JSON.stringify(this.ours)) return;
    this.ours = ours;
    try { localStorage.setItem(KEY, JSON.stringify(ours)); } catch { /* names are redone next tick */ }
  }

  render() {
    return div();
  }
}
