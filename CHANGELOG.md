# Changelog

All notable changes to SUBVERTER. Format loosely follows [Keep a Changelog](https://keepachangelog.com/); this project uses [Semantic Versioning](https://semver.org/).

## [1.0.0] — 2026-06-05

First public release. A complete single-file browser DJ rig.

### Core
- Two decks with low/mid/high EQ, filter sweep, tempo/pitch, cue, and an equal-power crossfader.
- Master echo (delay) and reverb sends.
- Per-deck waveform with beat grid, drop flags, vocal-presence band, and mix-point markers.
- Track analysis on load: BPM + beat offset, musical key → Camelot, energy envelope, vocal presence, and structural drop detection.

### Auto-pilot
- Autonomous set builder with a configurable energy curve over a target set length.
- Next-track selection scored on BPM / key (Camelot) / energy fit.
- **Structure-aware mix timing** — mixes at scored phrase boundaries rather than on a fixed timer, with a minimum-play floor and a sanctioned double-drop exception.
- **Trailing-silence aware** — detects a track's effective end (blank/quiet tail trimmed) during analysis and finishes the mix before it, so a song's silent outro never leaves dead air. The detected end is shaded on the waveform.
- Self-healing: a watchdog plus keep-alive interval recover from stalls, expired stream URLs, or an empty crate (falls back to replaying the current track from its first drop so the set never goes silent).

### Transitions & FX
- Named transition repertoire (blend, filter, echo, cut, double-drop, tops-swap, build, silence) selected to fit both tracks and the adventure setting.
- EPIC mode: beat-roll stutters into double-drops, rewind-reloads, peak-time sirens.
- FX weapons: airhorn, siren, impact, riser→drop, rewind-reload, beat-rolls (1/½/¼/⅛), latching beat-loops (1/2/4/8).
- Auto-pilot SFX cooldown gate so effects don't stack into mud (manual hits stay ungated).
- MC drop: beat-synced TTS announcer with duck/horn/echo.

### Hardware & performance
- Pioneer DDJ-200 Web MIDI mapping: jog nudge + seek, play/cue, sync, 3-band EQ, faders, crossfader, CFX filters, tempo, headphone-cue hard-swap, master-cue centre, transition trigger.
- Mappable 16-pad grid (2 decks × 8, with SHIFT layer), remappable to any FX/roll/loop/control action, driven from hardware pads and on-screen.

### Crate & requests
- Local files via drag-drop, **+Files**, or **Connect folder** (File System Access + IndexedDB).
- Online crate: direct URL, GitHub repo, Jamendo search, SoundCloud search (user-supplied client ID).
- Online buffer caching so expiring stream URLs aren't re-fetched mid-set.
- Request queue drawer with auto-pilot steering toward queued tracks (plays when it fits, otherwise bridges toward it).

### UI
- Dark neon/rave aesthetic (Chakra Petch + Spline Sans Mono).
- Live mix-tuning sliders: patience, FX density, adventurousness, transition length.
- Lite-UI toggle to pause heavy drawing for lower overhead.
- Measured-latency readout on MIDI connect.

## Roadmap (unreleased)

Ideas under consideration, not yet built:
- **Pad-bank persistence** — save remapped pad layouts (IndexedDB) and named banks.
- **True jog-scratch** — sample-accurate AudioWorklet engine for scratching.
- **Streaming playlist matcher** — import a Spotify/TIDAL playlist and match it against local files (since DRM blocks direct playback).
- **Request enhancements** — per-request "play next" override, drag-reorder, and a phone-friendly request page.

[1.0.0]: https://github.com/OWNER/REPO/releases/tag/v1.0.0
