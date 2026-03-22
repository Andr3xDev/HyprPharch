pragma Singleton

import QtQuick
import Quickshell

/*!
    Provides Colombian public holidays for any given year.

    Supports:
      - Fixed holidays (never moved)
      - Ley Emiliani mobile holidays (moved to next Monday)
      - Easter-relative holidays (computed via Meeus/Jones/Butcher)

    Results are cached per year — recomputed only when the year changes.
*/
Singleton {
    id: root

    property int _cachedYear: -1
    property var _holidays:   ({})

    // ─────────────────────────────────────────────── Public API ──

    /*!
        Returns true if (year, month, day) is a Colombian public holiday.
        Month is 1-based (January = 1).
    */
    function isHoliday(year, month, day) {
        if (_cachedYear !== year)
            _buildCache(year)
        return !!_holidays[month + "-" + day]
    }

    // ─────────────────────────────────────────── Private helpers ──

    /*!
        Builds and caches the holiday set for the given year.
    */
    function _buildCache(year) {
        const h = {}
        function mark(d) { h[(d.getMonth() + 1) + "-" + d.getDate()] = true }

        // Fixed holidays — never moved regardless of day of week
        mark(new Date(year,  0,  1))  // Año Nuevo
        mark(new Date(year,  4,  1))  // Día del Trabajo
        mark(new Date(year,  6, 20))  // Independencia
        mark(new Date(year,  7,  7))  // Batalla de Boyacá
        mark(new Date(year, 11,  8))  // Inmaculada Concepción
        mark(new Date(year, 11, 25))  // Navidad

        // Ley Emiliani holidays — moved to next Monday if not already Monday
        mark(_emiliani(year,  1,  6))  // Reyes Magos
        mark(_emiliani(year,  3, 19))  // San José
        mark(_emiliani(year,  6, 29))  // San Pedro y San Pablo
        mark(_emiliani(year,  8, 15))  // Asunción de la Virgen
        mark(_emiliani(year, 10, 12))  // Día de la Raza
        mark(_emiliani(year, 11,  1))  // Todos los Santos
        mark(_emiliani(year, 11, 11))  // Independencia de Cartagena

        // Easter-relative holidays
        const easter = _easter(year)
        mark(_offset(easter,  -3))                // Jueves Santo
        mark(_offset(easter,  -2))                // Viernes Santo
        mark(_emilianiDate(_offset(easter,  43))) // Ascensión del Señor
        mark(_emilianiDate(_offset(easter,  60))) // Corpus Christi
        mark(_emilianiDate(_offset(easter,  68))) // Sagrado Corazón de Jesús

        _cachedYear = year
        _holidays   = h
    }

    /*!
        Returns the Monday on or after the given calendar date (Ley Emiliani).
        If the date is already Monday, returns it unchanged.
    */
    function _emiliani(year, month, day) {
        return _emilianiDate(new Date(year, month - 1, day))
    }

    function _emilianiDate(d) {
        const dow  = d.getDay()  // 0 = Sunday, 1 = Monday
        if (dow === 1) return d
        const diff = (dow === 0) ? 1 : (8 - dow)
        return new Date(d.getFullYear(), d.getMonth(), d.getDate() + diff)
    }

    function _offset(date, days) {
        return new Date(date.getFullYear(), date.getMonth(), date.getDate() + days)
    }

    /*!
        Computes Easter Sunday using the Meeus/Jones/Butcher algorithm.
        No external libraries required.
    */
    function _easter(year) {
        const a = year % 19
        const b = Math.floor(year / 100)
        const c = year % 100
        const d = Math.floor(b / 4)
        const e = b % 4
        const f = Math.floor((b + 8) / 25)
        const g = Math.floor((b - f + 1) / 3)
        const h = (19 * a + b - d - g + 15) % 30
        const i = Math.floor(c / 4)
        const k = c % 4
        const l = (32 + 2 * e + 2 * i - h - k) % 7
        const m = Math.floor((a + 11 * h + 22 * l) / 451)
        const month = Math.floor((h + l - 7 * m + 114) / 31)
        const day   = ((h + l - 7 * m + 114) % 31) + 1
        return new Date(year, month - 1, day)
    }
}
