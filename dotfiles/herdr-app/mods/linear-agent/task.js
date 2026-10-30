// Pure helpers for the agent dialog: the branch name and the task the agent starts with.
// No Herdr imports, so `node --test` can load this file.

const DESCRIPTION_MAX = 600;

const slug = (text) => text.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase()
  .replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "").split("-").slice(0, 5).join("-");

// Linear's own suggested branch (Settings > Git), else `<identifier>-<first five title words>`.
export function branchFor(issue) {
  if (issue.branchName?.trim()) return issue.branchName.trim();
  return `${issue.identifier.toLowerCase()}-${slug(issue.title)}`;
}

// One path segment for the worktree folder.
export const folderName = (branch) => branch.replace(/[^A-Za-z0-9._-]+/g, "-").replace(/^-+|-+$/g, "");

// The worktree's folder; the issue's identifier when the branch leaves nothing usable ("", ".", "..").
export function worktreeFolder(branch, identifier) {
  const name = folderName(branch);
  return name.replace(/\./g, "") ? name : folderName(identifier);
}

// Why git can't take this branch name safely, or null. A leading "-" would reach
// `git branch` as an option through `git worktree add -b`; git check-ref-format does the rest.
export function branchProblem(branch) {
  if (!branch.trim()) return "The branch name is empty";
  if (branch.startsWith("-")) return 'A branch name cannot start with "-"';
  return null;
}

// Control characters (a carriage return, ctrl-c, escapes) would act on the agent's terminal.
const plain = (text) => String(text ?? "").replace(/[\u0000-\u001f\u007f-\u009f\s]+/g, " ").trim();

function summary(description) {
  const flat = plain(description);
  if (!flat) return null;
  return flat.length > DESCRIPTION_MAX ? `${flat.slice(0, DESCRIPTION_MAX)}…` : flat;
}

// Typed into the agent as one line: a newline would send it early.
export function taskFor(raw, rawBranch, { subagents }) {
  const issue = { identifier: plain(raw.identifier), title: plain(raw.title), url: plain(raw.url) };
  const branch = plain(rawBranch), about = summary(raw.description);
  return [
    `Work on Linear issue ${issue.identifier}: ${issue.title} (${issue.url}).`,
    about ? `Summary: ${about}` : null,
    "If you have Linear access (MCP or CLI), read the full issue and its comments first.",
    `You are in a fresh worktree on branch ${branch}.`,
    "Read the repo's AGENTS.md / CLAUDE.md before changing code.",
    subagents ? "Delegate exploration and verification to subagents where your tool supports them." : null,
    "Run the project's lint, typecheck and tests before committing.",
    `Commit with conventional commits, push the branch and open a PR that mentions ${issue.identifier}.`,
    "Do not merge or deploy.",
  ].filter(Boolean).join(" ");
}
