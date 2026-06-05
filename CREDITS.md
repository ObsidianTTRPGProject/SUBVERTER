# Credits

## Embedded audio samples

SUBVERTER ships with two short sound-effect samples embedded directly in the HTML. They are used as the default airhorn and siren; if you load your own samples, those override the defaults.

- **Airhorn** — "DJ airhorn" by **pfranzen** — https://freesound.org/s/528807/ — **CC0 1.0** (public domain). No attribution required; included here for completeness.
- **Siren** — "Siren" by **sean_eryx** — https://freesound.org/s/197559/ — **CC BY 4.0**. Trimmed and transcoded to mono. **Attribution required** — keep this credit if you redistribute. License: https://creativecommons.org/licenses/by/4.0/

Both credits are also shown inside the app's in-app help panel, satisfying the CC BY attribution requirement at point of use.

## Technique & references

The transition repertoire and mix-timing logic are informed by general DJ mixing technique (phrase-aware blending, harmonic/Camelot mixing, build/drop structure, double-drops). No third-party code or copyrighted text is included.

## Stack

- [Web Audio API](https://developer.mozilla.org/docs/Web/API/Web_Audio_API) — all audio routing, analysis, and effects.
- [Web MIDI API](https://developer.mozilla.org/docs/Web/API/Web_MIDI_API) — hardware controller support.
- Web Speech (`speechSynthesis`) — the MC voice.
- Fonts: Chakra Petch and Spline Sans Mono (Google Fonts).

No build tooling, frameworks, or runtime dependencies — everything is in `index.html`.
