.pragma library

/*!
    Consumed by LuaSerializer to produce the final Lua string written
    by FileWriter to monitors.generated.lua.

    Entry fields:
      output    — Wayland output name or "" for the catch-all fallback
      mode      — "WxH@R" string  (e.g. "2560x1440@144") or "preferred"
      position  — "XxY" string    (e.g. "0x0") or "auto"
      scale     — Float
      transform — Int | null  (omitted from output when null)
      disabled  — Boolean  (when true, entry disables the output)
*/
function create() {
  return {
    entries: [],
    hasFallback: false,
  };
}

/*!
    Appends the mandatory catch-all fallback entry and marks the document.
    MonitorConfigBuilder calls this as the last build step.
*/
function addFallback(doc) {
  doc.entries.push({
    output: "",
    mode: "preferred",
    position: "auto",
    scale: 1.0,
    transform: null,
    disabled: false,
  });
  doc.hasFallback = true;
  return doc;
}
