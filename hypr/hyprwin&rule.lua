---@diagnostic disable: undefined-global
-- Windows:

hl.window_rule({
	name = "Suppress-Maximize",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "Fix-Ghosting",
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
	name = "PolKit-Agent-Floating",
	match = {
		class = "^(lxqt-policykit-agent)$",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "Clipse-floating",
	match = {
		class = "^(clipse)$",
	},
	float = true,
	center = true,
	size = "{622, 652}",
})

-- Layers:
hl.layer_rule({
	name = "swaync-blur",
	match = {
		namespace = "^(swaync-control-center)$",
	},
	blur = true,
})
