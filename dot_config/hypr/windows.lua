-- Pin specific apps to specific workspaces, regardless of how they're
-- launched (keybind, launcher, or the start-workspaces.sh script).
-- Workspace-to-monitor pinning lives in hypr/monitors.lua since that's
-- host-specific; this file is the same on every machine.
--
-- Window classes found via `hyprctl clients`.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Workspace 1: IDEs (default interface to the chatbots)
o.window("^code$", { workspace = "1" })
-- (real class is lowercase "cursor", not "Cursor" from the .desktop
-- StartupWMClass -- confirmed via hyprctl clients)
o.window("^cursor$", { workspace = "1" })

-- Workspace 2: Chatbots
o.window("^chrome-claude.ai__-Default$", { workspace = "2" })
-- ChatGPT is the native desktop app (openai-codex-desktop package), not a
-- Chrome webapp -- confirmed via hyprctl clients + /proc/<pid>/cmdline.
o.window("^chatgpt$", { workspace = "2" })
o.window("^chrome-gemini.google.com__app-Default$", { workspace = "2" })

-- Workspace 3: Chrome
o.window("^google-chrome$", { workspace = "3" })

-- Workspace 4: Obsidian
-- (real class is md.obsidian.Obsidian, not "obsidian" -- confirmed via
-- `hyprctl clients`; the default keybind's focus regex was misleading)
o.window("^md.obsidian.Obsidian$", { workspace = "4" })

-- Workspace 5: Spotify + Ghostty, tiled together on the portrait monitor.
o.window("^Spotify$", { workspace = "5" })
o.window("^com.mitchellh.ghostty$", { workspace = "5" })
