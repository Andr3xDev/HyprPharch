.pragma library

/*!
    Stored in data/profiles.json by ProfileService.
    Matched against connected monitors by ProfileMatcher.
*/
function create(id, name, description, autoApply, trigger, monitors) {
  return {
    id: id,
    name: name,
    description: description,
    autoApply: autoApply,
    trigger: {
      require: [...trigger.require],
      absent: [...trigger.absent],
    },
    monitors: monitors.map((m) => ({
      identitySerial: m.identitySerial,
      mode: m.mode,
      position: m.position,
      scale: m.scale,
      transform: m.transform,
      enabled: m.enabled,
    })),
  };
}
