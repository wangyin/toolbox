local wezterm = require("wezterm")
local act = wezterm.action

--- cmd+keys that we want to send to neovim.
local super_vim_keys_map = {
	s = utf8.char(0xAA),
	x = utf8.char(0xAB),
	-- b = utf8.char(0xAC),
	-- ['.'] = utf8.char(0xAD),
	-- o = utf8.char(0xAF),
}

local function bind_super_key_to_vim(key)
	return {
		key = key,
		mods = "CMD",
		action = wezterm.action_callback(function(win, pane)
			local char = super_vim_keys_map[key]
			if char then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = char, mods = nil },
				}, pane)
			else
				win:perform_action({
					SendKey = {
						key = key,
						mods = "CMD",
					},
				}, pane)
			end
		end),
	}
end

local keys = {
	{ key = [[\]], mods = "ALT", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = [[-]], mods = "ALT", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "h", mods = "ALT", action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "ALT", action = act({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "ALT", action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "ALT", action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "z", mods = "ALT", action = act.TogglePaneZoomState },
  { key = "[", mods = "ALT", action = act.MoveTabRelative(-1) },
  { key = "]", mods = "ALT", action = act.MoveTabRelative(1) },
	{ key = "y", mods = "ALT", action = act.ActivateCopyMode },
	{ key = "c", mods = "CTRL|SHIFT", action = act({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL|SHIFT", action = act({ PasteFrom = "Clipboard" }) },
	{ key = "1", mods = "CTRL", action = act.Multiple({ act.SendKey( {mods = "CTRL", key = "a" } ), act.SendKey( { key = "1" } ) }) },
	{ key = "2", mods = "CTRL", action = act.Multiple({ act.SendKey( {mods = "CTRL", key = "a" } ), act.SendKey( { key = "2" } ) }) },
	{ key = "3", mods = "CTRL", action = act.Multiple({ act.SendKey( {mods = "CTRL", key = "a" } ), act.SendKey( { key = "3" } ) }) },
	{ key = "4", mods = "CTRL", action = act.Multiple({ act.SendKey( {mods = "CTRL", key = "a" } ), act.SendKey( { key = "4" } ) }) },
	{ key = "5", mods = "CTRL", action = act.Multiple({ act.SendKey( {mods = "CTRL", key = "a" } ), act.SendKey( { key = "5" } ) }) },
	{ key = "`", mods = "CTRL", action = act.Multiple({ act.SendKey( {mods = "CTRL", key = "a" } ), act.SendKey( { key = "z" } ) }) },

	-- CTRL+, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	-- CTRL+, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = "a",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "activate_pane",
			one_shot = false,
			-- timeout_milliseconds = 1000,
		}),
	},

	bind_super_key_to_vim("s"),
	bind_super_key_to_vim("x"),
}

local key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "h", action = act.ActivatePaneDirection("Left") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	  { key = "u", action = act({ ScrollByPage = -1 }) },
	  { key = "d", action = act({ ScrollByPage = 1 }) },
		{ key = "[", action = act.MoveTabRelative(-1) },
		{ key = "]", action = act.MoveTabRelative(1) },
		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
}

return {
	keys = keys,
	key_tables = key_tables,
}
