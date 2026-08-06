---@diagnostic disable: undefined-global
-- AutoStart:

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("Telegram -autostart")
	hl.exec_cmd("clipse -listen")
	hl.exec_cmd("fcitx5 -d")
	hl.exec_cmd("mpd-mpris")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("hyprctl setcursor cmd 30")
	hl.exec_cmd("lxqt-policykit-agent")
end)
