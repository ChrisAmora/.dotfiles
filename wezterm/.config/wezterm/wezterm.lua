local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Font ──────────────────────────────────────────────────────────────────────
-- Matches Ghostty config
config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")
config.font_size = 19

-- ── Colors ────────────────────────────────────────────────────────────────────
-- Matches Neovim (tokyo-night-storm is a built-in WezTerm scheme)
config.color_scheme = "Tokyo Night Storm"

-- ── Window ────────────────────────────────────────────────────────────────────
config.window_padding = { left = 20, right = 20, top = 10, bottom = 10 }
config.window_decorations = "TITLE | RESIZE"
config.window_background_opacity = 1.0
-- Size + center the window on startup (WezTerm doesn't do this by default:
-- it defers placement/sizing to the WM/compositor, which matters on tiling WMs)
wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  local gui = window:gui_window()
  local screen = wezterm.gui.screens().active
  local width = math.floor(screen.width * 0.6)
  local height = math.floor(screen.height * 0.7)
  gui:set_inner_size(width, height)
  gui:set_position(
    screen.x + (screen.width - width) / 2,
    screen.y + (screen.height - height) / 2
  )
end)

-- ── Tab bar ───────────────────────────────────────────────────────────────────
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

-- ── Scrollback ────────────────────────────────────────────────────────────────
config.scrollback_lines = 10000

-- ── Bell ──────────────────────────────────────────────────────────────────────
config.audible_bell = "Disabled"

-- ── Keys ──────────────────────────────────────────────────────────────────────
-- Minimal bindings — tmux handles multiplexing inside WSL2
-- Keep WezTerm's own leader out of the way of Ctrl-a (tmux prefix)
config.disable_default_key_bindings = false
config.keys = {
  -- Copy / paste that works everywhere
  { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
  -- Shift+Enter → newline for TUIs that opt in (Claude Code, etc.)
  { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\x1b\r") },
}

-- Strip trailing newlines so paste doesn't auto-execute in the shell
wezterm.on("format-paste", function(info)
  if type(info.text) ~= "string" or info.text == "" then
    return nil
  end
  return (info.text:gsub("[\r\n]+$", ""))
end)

-- ── Platform: WSL2 on Windows ─────────────────────────────────────────────────
-- On macOS/Linux this block is skipped entirely
if wezterm.target_triple:find("windows") then
  -- Run `wsl -l` to find your distro name and update if needed
  config.default_domain = "WSL:Ubuntu"
  config.default_cwd = "~"

  -- Native Windows font rendering
  config.font = wezterm.font("CaskaydiaCove Nerd Font Mono", { weight = "Regular" })
end

return config
