.pragma library

/*!
    Represents the persistent identity of a physical monitor, independent
    of the port it is connected to. Equality is defined by serial, not
    by object reference.
*/
function create(serial, make, model, alias, tags) {
  return Object.freeze({
    serial: serial,
    make: make,
    model: model,
    alias: alias,
    tags: Object.freeze([...tags]),
  });
}
