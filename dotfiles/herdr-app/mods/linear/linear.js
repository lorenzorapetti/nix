// Pure helpers for the Linear panel: the GraphQL query, config and response parsing, filters.
// No Herdr imports, so `node --test` can load this file.

export const API_URL = "https://api.linear.app/graphql";

// The viewer's open issues: anything not completed or canceled, most recently updated first.
export const ISSUES_QUERY = `query AssignedIssues {
  viewer {
    assignedIssues(first: 100, orderBy: updatedAt, filter: { state: { type: { nin: ["completed", "canceled"] } } }) {
      nodes {
        id identifier title url branchName priority priorityLabel updatedAt description
        state { name type color }
        team { key name }
        labels { nodes { name color } }
        attachments { nodes { url createdAt } }
      }
    }
  }
}`;

// Status chips, by Linear's workflow state types.
export const STATUSES = [
  { id: "all", label: "All", types: null },
  { id: "todo", label: "Todo", types: ["unstarted"] },
  { id: "doing", label: "In progress", types: ["started"] },
  { id: "backlog", label: "Backlog", types: ["backlog", "triage"] },
];

const expand = (path, home) => (path.startsWith("~/") ? `${home}${path.slice(1)}` : path);

// `~/.config/herdr-app/linear.json`: { "apiKey": "lin_api_…", "repos": { "<TEAM KEY>": "~/dev/repo" } }.
export function parseConfig(text, home) {
  if (text == null) return { apiKey: null, repos: {} };
  let raw;
  try { raw = JSON.parse(text); } catch { return { apiKey: null, repos: {}, error: "linear.json is not valid JSON" }; }
  const apiKey = typeof raw?.apiKey === "string" && raw.apiKey.trim() ? raw.apiKey.trim() : null;
  const repos = {};
  for (const [team, folder] of Object.entries(raw?.repos ?? {})) {
    if (typeof folder === "string" && folder.trim()) repos[team.toUpperCase()] = expand(folder.trim(), home);
  }
  return { apiKey, repos };
}

const isAuthError = (message) => /authenticat/i.test(message ?? "");

// A short reason for a failed request, from its status and body.
export function linearError(status, body) {
  if (status === 401) return "Invalid Linear API key";
  try {
    const message = JSON.parse(body)?.errors?.[0]?.message;
    if (message) return isAuthError(message) ? "Invalid Linear API key" : message;
  } catch { /* not JSON */ }
  return `Linear answered ${status}`;
}

const PULL_URL = /^https:\/\/github\.com\/[^/]+\/[^/]+\/pull\/\d+/;

// The newest GitHub pull request attached to an issue (Linear's GitHub integration links them), or null.
function pullRequest(attachments) {
  const pulls = (attachments ?? []).filter((a) => PULL_URL.test(a.url ?? ""));
  pulls.sort((a, b) => Date.parse(b.createdAt) - Date.parse(a.createdAt));
  return pulls[0]?.url ?? null;
}

export function parseIssues(json) {
  const message = json?.errors?.[0]?.message;
  if (message) throw new Error(isAuthError(message) ? "Invalid Linear API key" : message);
  return (json?.data?.viewer?.assignedIssues?.nodes ?? []).map((n) => ({
    id: n.id, identifier: n.identifier, title: n.title, url: n.url, branchName: n.branchName ?? null,
    priority: n.priority ?? 0, priorityLabel: n.priorityLabel ?? "", updatedAt: n.updatedAt,
    description: n.description ?? null,
    state: n.state?.name ?? "", stateType: n.state?.type ?? "", stateColor: n.state?.color ?? null,
    team: n.team?.key ?? "", teamName: n.team?.name ?? "",
    labels: (n.labels?.nodes ?? []).map((l) => ({ name: l.name, color: l.color })),
    prUrl: pullRequest(n.attachments?.nodes),
  }));
}

export function filterIssues(issues, { status, text }) {
  const types = STATUSES.find((s) => s.id === status)?.types ?? null;
  const needle = (text ?? "").trim().toLowerCase();
  return issues.filter((i) => (!types || types.includes(i.stateType))
    && (!needle || `${i.identifier} ${i.title}`.toLowerCase().includes(needle)));
}

export function ago(iso, now = Date.now()) {
  const minutes = Math.max(0, Math.round((now - Date.parse(iso)) / 60000));
  if (minutes < 60) return `${minutes}m`;
  if (minutes < 1440) return `${Math.round(minutes / 60)}h`;
  return `${Math.round(minutes / 1440)}d`;
}
