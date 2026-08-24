-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- === App launchers ===

-- VS Code (overrides the default Calendar binding on SUPER+SHIFT+C)
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "VS Code", "code")

-- Activity (btop) — duplicate of the default SUPER+CTRL+T, kept on its old key too.
o.bind("SUPER + SHIFT + T", "Activity", { tui = "btop" })

-- === Web apps ===

-- Claude (overrides the default ChatGPT binding on SUPER+SHIFT+A)
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "Claude", { webapp = "https://claude.ai" })

-- Google Calendar (key was free, no default binding there)
o.bind("SUPER + SHIFT + L", "Google Calendar", { webapp = "https://calendar.google.com/" })

-- Gmail (overrides the default HEY email binding on SUPER+SHIFT+E)
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Gmail", { webapp = "https://mail.google.com/" })

-- Feedly (overrides the default Editor launcher on SUPER+SHIFT+N)
hl.unbind("SUPER + SHIFT + N")
o.bind("SUPER + SHIFT + N", "Feedly", { webapp = "https://feedly.com" })

-- Amazon Music (overrides the default Music TUI/cliamp binding on SUPER+SHIFT+ALT+M)
hl.unbind("SUPER + SHIFT + ALT + M")
o.bind("SUPER + SHIFT + ALT + M", "Amazon Music", { webapp = "https://music.amazon.com" })

-- Google Messages (overrides the default Signal binding on SUPER+SHIFT+G --
-- Signal wasn't used per the old dotfiles anyway. Google Messages is still
-- reachable at the default SUPER+SHIFT+CTRL+G too.)
hl.unbind("SUPER + SHIFT + G")
o.bind("SUPER + SHIFT + G", "Google Messages", { webapp = "https://messages.google.com/web/conversations", focus = true })

-- Amazon (overrides the default Google Maps binding on SUPER+SHIFT+S)
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Amazon", { webapp = "https://amazon.com" })

-- === Capture ===

-- Screenshot, second key of choice (key was free). No mode arg, so this
-- defaults to "smart" -- same behavior as the default PRINT binding.
o.bind("ALT + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")

-- === Floating window nudging ===

-- Move the focused floating window with Vim-style HJKL.
-- (The old dotfiles also bound this to SUPER+SHIFT+ALT+arrows, but that combo
-- is now Omarchy's default "move workspace to monitor" binding, which is
-- worth keeping now that a second monitor is in the mix -- so only the HJKL
-- variant was carried forward.)
o.bind("SUPER + SHIFT + ALT + H", "Move floating window left", hl.dsp.window.move({ x = -20, y = 0, relative = true }))
o.bind("SUPER + SHIFT + ALT + L", "Move floating window right", hl.dsp.window.move({ x = 20, y = 0, relative = true }))
o.bind("SUPER + SHIFT + ALT + K", "Move floating window up", hl.dsp.window.move({ x = 0, y = -20, relative = true }))
o.bind("SUPER + SHIFT + ALT + J", "Move floating window down", hl.dsp.window.move({ x = 0, y = 20, relative = true }))
