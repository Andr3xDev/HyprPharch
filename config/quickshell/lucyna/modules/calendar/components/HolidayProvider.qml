pragma Singleton
import QtQuick
import Quickshell

/*!
    Colombian public holiday provider with per-year caching.

    Handles three holiday classes:
      - Fixed dates (never moved)
      - Ley Emiliani dates (shifted to next Monday when not already Monday)
      - Easter-relative dates (computed via Meeus/Jones/Butcher algorithm)
*/
Singleton {
    id: root

    property var _cache: ({
        "year": -1,
        "holidays": {}
    })

    /*!
        Returns true if the given date is a Colombian public holiday.
        month is 1-based (January = 1).
    */
    function isHoliday(year, month, day) {
        if (_cache.year !== year)
            _buildCache(year);
        return !!_cache.holidays[month + "-" + day];
    }

    function _buildCache(year) {
        const h = {};
        function mark(d) { h[(d.getMonth() + 1) + "-" + d.getDate()] = true; }

        mark(new Date(year, 0, 1));   // Año Nuevo
        mark(new Date(year, 4, 1));   // Día del Trabajo
        mark(new Date(year, 6, 20));  // Independencia
        mark(new Date(year, 7, 7));   // Batalla de Boyacá
        mark(new Date(year, 11, 8));  // Inmaculada Concepción
        mark(new Date(year, 11, 25)); // Navidad

        mark(_emiliani(year, 1,  6));  // Reyes Magos
        mark(_emiliani(year, 3,  19)); // San José
        mark(_emiliani(year, 6,  29)); // San Pedro y San Pablo
        mark(_emiliani(year, 8,  15)); // Asunción de la Virgen
        mark(_emiliani(year, 10, 12)); // Día de la Raza
        mark(_emiliani(year, 11, 1));  // Todos los Santos
        mark(_emiliani(year, 11, 11)); // Independencia de Cartagena

        const easter = _easter(year);
        mark(_offset(easter, -3));                    // Jueves Santo
        mark(_offset(easter, -2));                    // Viernes Santo
        mark(_emilianiDate(_offset(easter, 43)));     // Ascensión del Señor
        mark(_emilianiDate(_offset(easter, 60)));     // Corpus Christi
        mark(_emilianiDate(_offset(easter, 68)));     // Sagrado Corazón de Jesús

        _cache.year     = year;
        _cache.holidays = h;
    }

    function _emiliani(year, month, day) {
        return _emilianiDate(new Date(year, month - 1, day));
    }

    function _emilianiDate(d) {
        const dow = d.getDay();
        if (dow === 1) return d;
        return new Date(d.getFullYear(), d.getMonth(), d.getDate() + (dow === 0 ? 1 : 8 - dow));
    }

    function _offset(date, days) {
        return new Date(date.getFullYear(), date.getMonth(), date.getDate() + days);
    }

    function _easter(year) {
        const a = year % 19;
        const b = Math.floor(year / 100), c = year % 100;
        const d = Math.floor(b / 4), e = b % 4;
        const f = Math.floor((b + 8) / 25);
        const g = Math.floor((b - f + 1) / 3);
        const h = (19 * a + b - d - g + 15) % 30;
        const i = Math.floor(c / 4), k = c % 4;
        const l = (32 + 2 * e + 2 * i - h - k) % 7;
        const m = Math.floor((a + 11 * h + 22 * l) / 451);
        const month = Math.floor((h + l - 7 * m + 114) / 31);
        const day   = ((h + l - 7 * m + 114) % 31) + 1;
        return new Date(year, month - 1, day);
    }
}
