-- Pin specific apps to specific workspaces, regardless of how they're
-- launched (keybind, launcher, or the start-workspaces.sh script).
-- Workspace-to-monitor pinning lives in hypr/monitors.lua since that's
-- host-specific; this file is the same on every machine.
--
-- Window classes found via `hyprctl clients`.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Workspace 1: Chromium-based browsers.
o.window("^(google-chrome|chromium|microsoft-edge)$", { workspace = "1" })

-- Workspace 2: IDEs.
o.window("^(code|cursor)$", { workspace = "2" })

-- Workspace 3: Chatbots, either native apps or web apps.
o.window("^(claude|Claude|chatgpt|ChatGPT|gemini|Gemini)$", { workspace = "3" })
o.window("^chrome-claude.ai__-Default$", { workspace = "3" })
o.window("^chrome-chatgpt.com__-Default$", { workspace = "3" })
o.window("^chrome-gemini.google.com__app-Default$", { workspace = "3" })

-- Workspace 4: Obsidian
-- (real class is md.obsidian.Obsidian, not "obsidian" -- confirmed via
-- `hyprctl clients`; the default keybind's focus regex was misleading)
o.window("^md.obsidian.Obsidian$", { workspace = "4" })

-- Workspace 5: Spotify and terminals, tiled together on the portrait monitor.
o.window("^Spotify$", { workspace = "5" })
o.window("^(com.mitchellh.ghostty|foot|kitty|Alacritty|org.wezfurlong.wezterm|konsole|xterm)$", { workspace = "5" })
