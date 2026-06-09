.pragma library

/*!
    Produced by MonitorAdapter.parse() from raw hyprctl JSON.
    Consumed by MonitorService (state) and MonitorAdapter.toViewModel() (UI).
*/
function create(
  name,
  serial,
  identity,
  activeMode,
  position,
  scale,
  transform,
  enabled,
  availableModes,
  connected,
  cm,
) {
  return {
    name: name,
    serial: serial,
    identity: identity,
    activeMode: {
      width: activeMode.width,
      height: activeMode.height,
      refreshRate: activeMode.refreshRate,
    },
    position: { x: position.x, y: position.y },
    scale: scale,
    transform: transform,
    enabled: enabled,
    availableModes: availableModes.map((m) => ({
      width: m.width,
      height: m.height,
      refreshRate: m.refreshRate,
    })),
    connected: connected,
    cm: cm || "srgb",
  };
}
