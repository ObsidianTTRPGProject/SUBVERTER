@echo off
title SUBVERTER
rem Double-click me: serves SUBVERTER on localhost (so the DDJ-200 / Web MIDI works)
rem and opens it in your default browser. Close this window to stop.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start-subverter.ps1"
pause
