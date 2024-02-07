local wezterm = require("wezterm")

local Tab = {}

function Tab.get_process(tab)
	local process_icons = {
		["docker"] = {
			{ Foreground = { Color = "blue" } },
			{ Text = "󰡨" },
		},
		["docker-compose"] = {
			{ Foreground = { Color = "blue" } },
			{ Text = "󰡨" },
		},
		["nvim"] = {
			{ Foreground = { Color = "green" } },
			{ Text = "" },
		},
		["bob"] = {
			{ Foreground = { Color = "blue" } },
			{ Text = "" },
		},
		["vim"] = {
			{ Foreground = { Color = "green" } },
			{ Text = "" },
		},
		["ssh"] = {
			{ Foreground = { Color = "gray" } },
      { Text = "" },
		},
    ["tmux"] = {
      { Foreground = {Color = "gray" } },
      { Text = "" },
    },
		["node"] = {
			{ Foreground = { Color = "green" } },
			{ Text = "󰋘" },
		},
		["zsh"] = {
			{ Foreground = { Color = "gray" } },
			{ Text = "" },
		},
		["bash"] = {
			{ Foreground = { Color = "gray" } },
			{ Text = "" },
		},
		["htop"] = {
			{ Foreground = { Color = "yellow" } },
			{ Text = "" },
		},
		["btop"] = {
			{ Foreground = { Color = "rosewater" } },
			{ Text = "" },
		},
		["cargo"] = {
			{ Foreground = { Color = "peach" } },
			{ Text = wezterm.nerdfonts.dev_rust },
		},
		["go"] = {
			{ Foreground = { Color = "sapphire" } },
			{ Text = "" },
		},
		["git"] = {
			{ Foreground = { Color = "peach" } },
			{ Text = "󰊢" },
		},
		["lazygit"] = {
			{ Foreground = { Color = "mauve" } },
			{ Text = "󰊢" },
		},
		["lua"] = {
			{ Foreground = { Color = "blue" } },
			{ Text = "" },
		},
		["wget"] = {
			{ Foreground = { Color = "yellow" } },
			{ Text = "󰄠" },
		},
		["curl"] = {
			{ Foreground = { Color = "yellow" } },
			{ Text = "" },
		},
		["gh"] = {
			{ Foreground = { Color = "mauve" } },
			{ Text = "" },
		},
		["flatpak"] = {
			{ Foreground = { Color = "blue" } },
			{ Text = "󰏖" },
		},
	}

	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

	if not process_name then
		process_name = "zsh"
	end

	return process_icons[process_name]
		or { { Foreground = { Color = "sky " } }, { Text = string.format("[%s]", process_name) } }
end

function Tab.get_current_working_folder_name(tab)
	local cwd_uri = tab.active_pane.current_working_dir
	local cwd = ""

	if type(cwd_uri) == "userdata" then
		-- Running on a newer version of wezterm and we have
		-- a URL object here, making this simple!
		cwd = cwd_uri.file_path
	else
		-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
		-- which doesn't have the Url object
		cwd_uri = cwd_uri:sub(8)
		local slash = cwd_uri:find("/")
		if slash then
			-- and extract the cwd from the uri, decoding %-encoding
			cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
				return string.char(tonumber(hex, 16))
			end)
		end
	end

	local HOME_DIR = os.getenv("HOME")
	if cwd == HOME_DIR then
		return " ~"
	end

	return string.format(" %s", string.match(cwd, "[^/]+$"))
end

return Tab
