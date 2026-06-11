# SUBVERTER

A self-contained, single-file browser DJ rig built on the Web Audio API. No build step, no dependencies, no server — open `index.html` and it runs. Two decks, beat/key analysis, an autonomous auto-pilot DJ, a transition repertoire, FX weapons, a TTS MC, hardware controller support (Pioneer DDJ-200), a mappable 16-pad performance grid, a request queue, and an online crate loader.

> Built for hard dance / hardstyle sets, but it'll mix anything you feed it.

## Quick start

Open `index.html` in a recent Chrome or Edge. Drag in audio files (or use **+Files** / **Connect folder**), hit play on a deck, and either mix manually or press **START PARTY** to let the auto-pilot run the set.

**Using a DDJ-200 / MIDI controller?** Don't open the file directly — double-click **`Start-SUBVERTER.bat`** (Windows) or **`start-subverter.sh`** (macOS/Linux) instead. It serves the app on `localhost` (no install, no admin rights) and opens your browser; Chrome only grants the Web MIDI permission to `http(s)` pages, never to `file://`. Once allowed, the controller auto-reconnects on every load. Hosting it (see below) works too.

## Host it on GitHub Pages

This app is an ideal fit for Pages: it's one static file served over HTTPS, which unlocks the secure-context features that `file://` blocks.

1. Create a repo and drop these files in at the root (the app must be named `index.html`).
2. Push to `main`.
3. **Settings → Pages → Build and deployment → Deploy from a branch**, select `main` and `/ (root)`.
4. Open `https://<you>.github.io/<repo>/` after a minute or two.

The included `.nojekyll` file tells Pages to skip Jekyll processing and serve everything as-is.

**Why it's worth hosting:**
- **Web MIDI works** without the `localhost` workaround — the DDJ-200 connects straight from the hosted page.
- Online crate fetches run from a real HTTPS origin (not the `null` origin `file://` gives you), so CORS behaves normally.
- The connected-folder handle persists per origin, so a stable `github.io` URL re-grants your crate folder more reliably.

**Caveats:**
- A published Pages site is **publicly reachable by URL** regardless of repo visibility. Nothing sensitive lives in the file (API client IDs are typed in at runtime, never baked in), and your music isn't uploaded — but anyone with the link can load the player.
- HTTPS blocks mixed content, so any **From URL** crate links must be `https://` (the loader already enforces this).
- Pages sits behind a CDN with ~10-minute caching; after a push, give it a couple minutes or hard-refresh.

## Features

**Decks & mixing.** Two decks with independent EQ (low/mid/high), filter sweep, tempo/pitch, cue, and an equal-power crossfader. Master echo (delay) and reverb sends. Per-deck waveform with beat grid, drop flags, vocal-presence band, and mix-point markers. Every track is loudness-normalized from analysis and a master limiter keeps stacked drops from clipping.

**⛶ Stage view.** One click for fullscreen, beat-reactive party visuals — radial spectrum, kick-flash synced to the live beat grid, now playing, next-mix countdown, and big animated callouts for every transition. Made for the TV/projector at the party.

**Track analysis.** On load each track is analysed for BPM + beat offset, musical key (mapped to Camelot for harmonic mixing), energy envelope, vocal presence, and structural drops. The auto-pilot and transition planner use all of it.

**Auto-pilot DJ.** `START PARTY` runs an autonomous set: it builds an energy curve over your chosen set length, picks the next track for BPM/key/energy fit, and mixes at phrase-aware boundaries using structure-aware timing (it waits for musical mix points rather than mixing on a fixed timer). Recovers automatically if the crate runs dry or a stream URL expires. Pacing follows the energy curve (long rides in the warm-up, quick mixing at peak), incoming tracks enter near their first drop at high energy, and at peak vocal moments it occasionally cuts the music for a bar so the crowd sings the hook back.

**Transition repertoire.** A library of named transition styles (blend, filter fade, echo-out, hard cut, double-drop, tops-swap, build-up, silence-drop, spinback, drop-swap) selected to fit the two tracks and your "adventure" setting — grounded in real DJ technique, not random. Blends are pre-scheduled on the audio clock (sample-accurate equal-power fades with a true ~2-beat bass swap at the phrase point), and the tempo glides back onto the energy curve after each mix instead of snapping.

**EPIC mode.** Forces the energy higher: beat-roll stutters into double-drops, occasional rewind-and-reload, extra peak-time sirens.

**FX weapons.** Airhorn, siren, impact/slam, riser→drop, rewind-reload, beat-rolls (1/½/¼/⅛), and latching beat-loops (1/2/4/8 beats) — all tempo-synced. Manual fire from buttons or pads; the auto-pilot fires them through a cooldown gate so they don't stack into mud.

**MC drop.** A TTS announcer (`speechSynthesis`) with a deep, beat-synced voice, optional duck/horn/echo glued to the utterance.

**Online crate.** Load tracks from a direct URL, a GitHub repo, Jamendo search, or SoundCloud search (you supply a SoundCloud client ID). Note: DRM/HLS-only sources can't be decoded by Web Audio; progressive/downloadable audio works.

**Hardware: Pioneer DDJ-200.** Full Web MIDI mapping — jog nudge + seek, play/cue, sync, 3-band EQ, channel faders, crossfader, CFX filters, tempo, headphone-cue hard-swap, master-cue centre, and a transition-FX trigger. Auto-reconnects on load once the permission is granted; use the bundled launcher (`Start-SUBVERTER.bat` / `start-subverter.sh`) when running from disk. (Tempo range and true jog-scratch are intentionally not mapped; scratch needs an AudioWorklet engine, which isn't built.)

**16-pad performance grid.** Two decks × 8 pads with a SHIFT layer, fully remappable to any FX/roll/loop/control action. Works from the DDJ-200's pads and on-screen. Mappings persist across reloads.

**Request queue.** A slide-out drawer to search the crate and queue requests. The auto-pilot steers toward them: it plays a request the moment it fits the current BPM/key, otherwise biases track selection toward bridge tracks that close the gap, widening tolerance each pass so it always lands.

**Mix tuning.** Live sliders for patience (how long tracks play), FX density, adventurousness, and transition length. Settings, toggles and pad mappings persist between sessions; the screen stays awake while a set runs. The crate sorts by name/BPM/key/energy, and any request can be forced to play next.

## Browser support

- **Chrome / Edge:** everything, including Web MIDI.
- **Firefox / Safari:** audio, analysis, auto-pilot, and FX work; **Web MIDI is unsupported**, so no hardware controller.
- Best on desktop. Mobile browsers vary and lack MIDI.

## Honest limitations

- **Latency has a floor.** A browser can't reach ASIO-level latency; `latencyHint: 'interactive'` and a measured-latency readout help, but this won't match native software on a pro setup.
- **No true scratch.** Jog scratching needs a sample-accurate AudioWorklet engine, which isn't built (offered on the roadmap).
- **Streaming services.** Spotify and TIDAL deliver DRM (Widevine) audio that Web Audio can't route, and their metadata endpoints are largely closed to new apps — full-track playback from those isn't possible in a browser. SoundCloud is the most open (progressive/HLS), hence the built-in search. For streaming-sourced DJ sets, a native app (rekordbox/Serato/VirtualDJ) with a licensed streaming add-on is the realistic path.
- **Unattended sets in a hidden tab.** A keep-alive interval keeps mixing when the tab is backgrounded, but Chrome's intensive throttling can still pause a long-hidden tab. Keep the window visible for fully unattended sets.

## Sound & research credits

See [CREDITS.md](CREDITS.md). Two embedded samples are licensed; the siren (CC BY 4.0) requires attribution, which the app shows in its in-app help and which is reproduced in CREDITS.

## License

Code is MIT — see [LICENSE](LICENSE). The embedded audio samples carry their own licenses (see CREDITS); preserve the CC BY 4.0 attribution if you redistribute.
