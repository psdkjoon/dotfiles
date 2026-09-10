hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("mpd-mpris")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")
	hl.exec_cmd("fcitx5 -d")
	hl.exec_cmd("lxqt-policykit-agent")
end)

hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = "0.83",
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "0x0",
	scale = "0.83",
	transform = 0,
})

hl.monitor({
	output = "DP-1",
	mode = "preferred",
	position = "2313x-970",
	scale = "0.83",
	transform = 1,
})

local terminal = "kitty"
local vpn = "throne"
local browser = "firefox"
local lock = "hyprlock"
local colorpicker = "hyprpicker -a"
local nc = "swaync-client -t"
local menu = "hyprlauncher"

local mainMod = "SUPER"

local home = os.getenv("HOME")

local rosewater = "rgba(f5e0dcee)"
local flamingo = "rgba(f2cdcdee)"
local pink = "rgba(f5c2e7ee)"
local mauve = "rgba(cba6f7ee)"
local red = "rgba(f38ba8ee)"
local maroon = "rgba(eba0acee)"
local peach = "rgba(fab387ee)"
local yellow = "rgba(f9e2afee)"
local green = "rgba(a6e3a1ee)"
local teal = "rgba(94e2d5ee)"
local sky = "rgba(89dcebee)"
local sapphire = "rgba(74c7ecee)"
local blue = "rgba(89b4faee)"
local lavender = "rgba(b4befeee)"
local text = "rgba(cdd6f4ee)"
local subtext1 = "rgba(bac2deee)"
local subtext0 = "rgba(a6adc8ee)"
local overlay2 = "rgba(9399b2ee)"
local overlay1 = "rgba(7f849cee)"
local overlay0 = "rgba(6c7086ee)"
local surface2 = "rgba(585b70ee)"
local surface1 = "rgba(45475aee)"
local surface0 = "rgba(313244ee)"
local base = "rgba(1e1e2eee)"
local mantle = "rgba(181825ee)"
local crust = "rgba(11111bee)"

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("EDITOR", "nvim")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("XDG_SCREENSHOTS_DIR", "" .. home .. "/Pictures/")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("PUB_HOSTED_URL", "https://pub.myket.ir")
hl.env("FLUTTER_STORAGE_BASE_URL", "https://pub.myket.ir")
hl.env("ANDROID_HOME", "" .. home .. "/dev/Android/Sdk")
hl.env("CHROME_EXECUTABLE", "/opt/chrome-linux/chrome")
hl.env("SKIKO_RENDER_API", "SOFTWARE")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("YAZI_CWD_FILE", "" .. home .. "/.yazi-cwd")
hl.env("FZF_DEFAULT_COMMAND", "rg --files --hidden")
hl.env(
	"PATH",
	os.getenv("PATH")
		.. ":"
		.. home
		.. "/dev/flutter/bin:"
		.. home
		.. "/dev/Android/Sdk/platform-tools:"
		.. home
		.. "/dev/Android/Sdk/cmdline-tools/20.0/bin:"
		.. home
		.. "/.local/bin"
)

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 5,
		border_size = 5,
		col = {
			active_border = mauve,
			inactive_border = mantle,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = yellow,
		},
		blur = {
			enabled = true,
			size = 4,
			passes = 2,
			new_optimizations = true,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},
})

hl.config({
	input = {
		kb_options = "compose:ralt",
		numlock_by_default = true,
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area -n -f"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast copy area -n -f"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("grimblast copy screen -n -f"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grimblast copysave area -n -f"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("grimblast copysave area -n -f"))
hl.bind(mainMod .. " + ALT + Print", hl.dsp.exec_cmd("grimblast copysave screen -n -f"))

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(vpn))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(colorpicker))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(nc))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("Telegram"))

hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "Fix Ghosting",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "PolKit Agent Floating",
	match = {
		class = "^(lxqt-policykit-agent)$",
	},
	float = true,
	center = true,
})
