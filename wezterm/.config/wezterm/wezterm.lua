local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Font ──────────────────────────────────────────────────────────────────────
-- Matches Ghostty config
config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")
config.font_size = 19

-- ── Colors ────────────────────────────────────────────────────────────────────
-- Matches Neovim (tokyo-night-storm is a built-in WezTerm scheme)
config.color_scheme = "tokyo-night-storm"

-- ── Window ────────────────────────────────────────────────────────────────────
config.window_padding = { left = 20, right = 20, top = 10, bottom = 10 }
config.window_decorations = "RESIZE" -- no title bar, borderless
config.window_background_opacity = 1.0
config.initial_cols = 220
config.initial_rows = 50

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
}

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
