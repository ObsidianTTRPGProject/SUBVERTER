# Changelog

All notable changes to SUBVERTER. Format loosely follows [Keep a Changelog](https://keepachangelog.com/); this project uses [Semantic Versioning](https://semver.org/).

## [1.4.1] — 2026-06-11

Hardening release after a reported in-the-wild failure: a transition/airhorn loop with the decks cutting back and forth.

### Fixed
- **Transition circuit breaker.** Transitions can no longer cascade: if three start within ~3s of each other (broken files, bad analysis, recovery loops), the engine halts the storm for 10s, replans the exit, and holds the current track.
- **Watchdog backoff.** End-of-track recovery is rate-limited to once per 2s; four recoveries inside 30s now switch to replaying the current track instead of cutting between (possibly broken) decks.
- **Silent rescues.** Watchdog recovery cuts no longer fire airhorns/impacts — FX celebrate planned mixes, not failures. (This was the airhorn loop: every recovery cut at peak energy fired the horn.)
- **Short-track guard.** Files that decode to under 20s of audio (truncated downloads, corrupt rips, expired-URL fragments) are rejected at analysis with a clear reason — previously they could enter the crate, instantly "end" on air, and trigger the recovery cascade.

### Added
- **🩺 Diag button** (Controller row) — one click saves a diagnostics JSON: the last ~300 auto-DJ decisions (every mix with style/timing, watchdog fire, FX, error with stack), full engine/deck/crate state, and any crash snapshot. Caught autopilot errors now auto-save a snapshot to IndexedDB so the *next* Diag dump includes the previous session's failure.

## [1.4.0] — 2026-06-11

The "best damn rave party app" release: sound polish, a projector-ready stage view, and host tools.

### Audio
- **Per-track loudness normalization.** Analysis now measures each track's sustained loudness (90th-percentile RMS window) and auto-trims it toward a reference level (×0.5–×1.8) through a dedicated per-deck trim node — blends never jump in volume between a quiet rip and a brickwalled master. Teases, spinback zips and rewind zips honour the trim too.
- **Master limiter.** A brickwall-style compressor (−4.5 dB threshold, 12:1, 2 ms attack) sits on the master bus so stacked moments (double drop + airhorn + impact) can't clip the output.

### Stage view
- **⛶ Stage** — fullscreen, beat-reactive party visuals on one click (with browser fullscreen): radial spectrum in deck colours, kick-flash core driven by the on-air deck's actual beat grid, downbeat room-flash, now playing, live BPM/key/section, next-mix countdown, and huge animated callouts for every transition, DOUBLE DROP and crowd-sing. Esc exits. Runs full-rate even in Lite UI.

### Host tools & reliability
- **⏭ Play next** on any request — jumps the whole queue unconditionally and re-cues the idle deck immediately.
- **Crate sorting** (name / BPM / key / 🔥 energy) and a per-track **energy badge** computed from tempo + loudness.
- **Settings persistence** — peak BPM, set length, min/track, tuning sliders, DJ-brain toggles and pad mappings are saved (IndexedDB) and restored on load. Pad-bank persistence graduates off the roadmap.
- **Screen wake lock** while the party runs (re-acquired when the tab returns to the foreground), released on stop.

## [1.3.0] — 2026-06-11

### MIDI controller — one double-click to connect
- **Double-click launchers.** New `Start-SUBVERTER.bat` (Windows, zero dependencies — a pure PowerShell TCP listener, no Python, no admin rights) and `start-subverter.sh` (macOS/Linux, uses python3) serve the app on `localhost` and open the browser. This is the supported way to run from disk with the DDJ-200, since Chrome refuses the Web MIDI permission on `file://` pages.
- **MIDI auto-reconnect.** If the origin already holds the MIDI permission from a previous visit, the controller hooks up automatically on page load — no clicking Connect MIDI every session.
- **No more hard `file://` block.** Connect MIDI now always *attempts* the connection (future browsers may allow it) and only shows guidance — pointing at the launchers — if the browser refuses.

## [1.2.0] — 2026-06-11

Festival-technique release: the auto-pilot now mixes the way big-room / peak-time festival DJs actually do.

### Added
- **Drop swap transition** — the signature festival move: ride the outgoing track's breakdown/outro while the incoming runs its *own* build underneath (half-faded, bass killed, drop-aligned to the phrase), then kill the old track dead the instant the incoming's drop lands. Becomes the most common peak-time transition for key-compatible tracks with a detected drop.
- **Crowd-sing moment** — at peak energy, on a sustained vocal (from the per-track vocal map), the auto-pilot occasionally cuts the music for one bar so the room sings the hook back, then slams in with an impact. Once per track, ~75s cooldown, scaled by FX intensity.
- **Pitch-push build (⚡ Epic)** — the loop build now rides the outgoing track up ~5% (key-shift up) across the stutter roll into the slam — the classic hands-up adrenaline shot.
- **Downlifters** — big slams (silence cut, spinback, drop swap, double drop) get a falling noise sweep so they never land dry.

### Changed
- **Festival pacing** — minimum ride length now scales with the energy curve: warm-up tracks ride ~18% longer, peak-time tracks mix ~17% sooner.
- **Smart entry points** — at higher energy, incoming tracks enter on their own 32-beat phrase grid so their first drop lands ~48 beats after they appear, instead of riding a full-length intro.

## [1.1.0] — 2026-06-11

### Transitions — smoother and harder
- **Sample-accurate blends.** Crossfades, bass swaps and filter sweeps are now pre-scheduled on the audio clock as eased equal-power ramps instead of being driven frame-by-frame from `requestAnimationFrame`. No more zipper-stepping, and mixes stay perfectly smooth when the tab is backgrounded (previously they degraded to ~2 updates/sec).
- **True bass swap.** The low-end handover is no longer a linear trade (which left both basslines at −13 dB mid-blend). The outgoing keeps its bass, the incoming stays killed, and they swap over ~2 beats at the phrase point (~62% through the blend; later/longer for tops layers).
- **Post-mix tempo glide.** The new on-air track now glides onto the energy-curve BPM over a few seconds after the blend, instead of snapping instantly (an audible pitch lurch). Manual tempo moves cancel the glide.
- **New: spinback transition.** The megamix classic — the outgoing dies on the phrase with an accelerating reverse zip, two beats of wind-back, then the incoming's drop slams on the downbeat with an impact. Used for clashing-key peak mixes and occasionally in ⚡ Epic.
- Eased fades per style: smooth (blend/tops), linear (filter — the sweep carries it), front-loaded (echo-out exits fast and lets the tail fill the space).
- The controller TRANSITION FX blend uses the same scheduled fade + bass swap.

### Mobile
- Fixed the vertical EQ sliders overflowing their columns on narrow screens (the rotated input's 120px layout box was being clipped at the deck edges) — they're now absolutely centred.
- New ≤520px layout: tighter paddings, full-width tune sliders, flexible VU/peak-BPM controls, full-screen request drawer, single-column help.
- Bigger slider thumbs/tracks on touch devices (`pointer: coarse`).
- `viewport-fit=cover` plus safe-area insets so nothing hides behind notches/rounded corners.

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
- **Set recording** — tap the master bus into a MediaRecorder and save the night as an audio file.
- **Mic input MC mode** — getUserMedia routed through auto-duck for live shout-outs.
- **Named pad banks** — multiple saved pad layouts (single layout now persists as of 1.4.0).
- **True jog-scratch** — sample-accurate AudioWorklet engine for scratching.
- **Streaming playlist matcher** — import a Spotify/TIDAL playlist and match it against local files (since DRM blocks direct playback).
- **Request enhancements** — per-request "play next" override, drag-reorder, and a phone-friendly request page.

[1.4.1]: https://github.com/ObsidianTTRPGProject/SUBVERTER/releases/tag/v1.4.1
[1.4.0]: https://github.com/ObsidianTTRPGProject/SUBVERTER/compare/v1.0.0...v1.4.1
[1.0.0]: https://github.com/ObsidianTTRPGProject/SUBVERTER/releases/tag/v1.0.0
