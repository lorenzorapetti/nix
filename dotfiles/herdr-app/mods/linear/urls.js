// Issue URLs come from Linear, so only https reaches the system's opener:
// no file:, no app schemes, nothing read as an option.
export function safeUrl(url) {
  try {
    const parsed = new URL(url);
    return parsed.protocol === "https:" ? parsed.href : null;
  } catch {
    return null;
  }
}
