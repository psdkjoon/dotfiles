---@diagnostic disable: undefined-global
-- Bind:

-- Variable:
local terminal = "kitty"
local fileManager = "yazi"
local menu = "hyprlauncher"
local browser = "firefox"
local xray = "throne"
local agent = "zcode"
local lock = "hyprlock --grace 10"
local colorPicker = "hyprpicker -a"
local messanger = "Telegram"
local notificationCenter = "swaync-client -t"
local mainMod = "SUPER"

-- ScrennShot:
hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area -n -f"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast copy active -n -f"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("grimblast copy screen -n -f"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grimblast copysave area -n -f"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("grimblast copysave active -n -f"))
hl.bind(mainMod .. " + ALT + Print", hl.dsp.exec_cmd("grimblast copysave screen -n -f"))

-- Apps:
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(xray))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(agent))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(terminal .. " -e " .. fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(colorPicker))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(terminal .. " --class clipse -e clipse"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(messanger))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notificationCenter))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("pkexec systemctl restart tor"))

-- Manage:
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + X", hl.dsp.window.close())
-- bind = $mainMod, escape, exit
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Move:
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

-- Audio:
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
	"SHIFT + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"SHIFT + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),
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

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Music:
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
