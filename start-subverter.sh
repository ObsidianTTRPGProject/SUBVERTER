#!/bin/sh
# SUBVERTER local launcher (macOS / Linux)
# Serves this folder on http://localhost so Chrome grants the Web MIDI permission
# (the DDJ-200 doesn't work from file://), then opens your default browser.
# Requires python3 (preinstalled on macOS and most Linux distros).
cd "$(dirname "$0")" || exit 1
PORT=8421
URL="http://localhost:$PORT/"
echo ""
echo "  SUBVERTER is live at $URL"
echo "  Web MIDI (DDJ-200) works on this address — click 'Connect MIDI' in the app."
echo "  Keep this terminal open while you play. Ctrl+C to stop."
echo ""
( sleep 1; open "$URL" 2>/dev/null || xdg-open "$URL" 2>/dev/null ) &
exec python3 -m http.server "$PORT" --bind 127.0.0.1
