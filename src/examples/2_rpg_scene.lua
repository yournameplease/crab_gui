local SCREEN_W = 480
local SCREEN_H = 270


local crab = require"src/crab_gui/gui"
local crab_layout = require"src/crab_gui/layout"
local sw = require"src/crab_gui/std_widgets"
local text_rendering = require"src/crab_gui/text_rendering"
local gui = crab.new()
local font_cache = text_rendering.new_font_cache()

---@param ctx RenderRequest
local function draw_fancy_panel(ctx)
	local bounds_min = ctx.bounds.min
	local bounds_size = ctx.bounds:get_size()
	rrectfill(bounds_min.x, bounds_min.y, bounds_size.x, bounds_size.y, ctx.args.radius, ctx.args.col)
	rrect(bounds_min.x + ctx.args.border_offset, bounds_min.y + ctx.args.border_offset, bounds_size.x - 2 * ctx.args.border_offset, bounds_size.y - 2 * ctx.args.border_offset, ctx.args.radius - ctx.args.border_offset, ctx.args.border_col)
end

---@param gui Gui
---@param col integer? Defaults to 1
---@param radius number? Defaults to 1
local function fancy_panel(gui, col, radius, border_col, border_offset)
	gui:push_render(draw_fancy_panel, {
	  col = col or 1,
	  radius = radius or 1,
	  border_col = border_col or nil,
	  border_offset = border_offset or 0,
	})
end


local left_panel_rect =
	crab_layout.new_rect(vec(2, 2), vec(-1, -2), vec(0, 0), vec(0.3, 1))

local right_panel_rect =
	crab_layout.new_rect(vec(1, 2), vec(-2, -2), vec(0.3, 0), vec(1, 1))

local upper_left_panel_rect =
	crab_layout.new_rect(vec(2, 2), vec(-2, 20), vec(0, 0), vec(1, 0))

local lower_left_panel_rect = crab_layout.new_rect(vec(2, 22), vec(-2, -2))

local font_style = text_rendering.default_style{col = 7, halign = "left", valign = "top"}
local action_font_style = text_rendering.default_style{col = 7, halign = "center", valign = "center"}
local active_action_font_style = text_rendering.default_style{col = 0, halign = "center", valign = "center"}

local menu_index = 1
local menu_options = {
  "Attack",
  "Magic",
  "Item",
  "Flee",
  "Dance",
  "Sing",
}

local function do_gui()
  local UI_PAD = 5
  local PANEL_PAD = 7

  
	gui:push_rect(crab_layout.new_rect_at(
		vec(0.5, 0.5),
		vec(SCREEN_W - 2*UI_PAD, SCREEN_H - 2*UI_PAD)
	))
	gui:push_rect(crab_layout.new_rect_at(
		vec(0.5, 1),
		vec(300, 100)
	))
	fancy_panel(gui, 1, 7, 7, 2)
	gui:push_rect(crab_layout.new_rect_at(
		vec(0.5, 0.5),
		vec(300-2*PANEL_PAD, 100-2*PANEL_PAD)
	))
	
	sw.text(gui, font_cache, "A monster appeared!", font_style)

	gui:pop_rect()
	gui:pop_rect()


	local ACTION_H = 10
	local ACTION_GAP = 5
  local ACTIONS_H = ACTION_H * #menu_options + ACTION_GAP * (#menu_options - 1) +  2 * PANEL_PAD
	
	gui:push_rect(crab_layout.new_rect_at(
		vec(1, 0.25),
		vec(100, ACTIONS_H)
	))
	fancy_panel(gui, 1, 7, 7, 2)
	gui:push_rect(crab_layout.new_rect_at(
		vec(0.5, 0.5),
		vec(100-2*PANEL_PAD, ACTIONS_H-2*PANEL_PAD)
	))
	for i,o in ipairs(menu_options) do
  	gui:push_rect(crab_layout.new_rect_at(
  		vec(0.5, (i - 1) / (#menu_options - 1)),
  		vec(100-2*PANEL_PAD, ACTION_H)
  	))

  	local is_hovered = menu_index == i
    if is_hovered then
      sw.panel(gui, 7, 3)
    	sw.text(gui, font_cache, o, active_action_font_style)
    else
    	sw.text(gui, font_cache, o, is_hovered and active_action_font_style or action_font_style)
  	end

  	gui:pop_rect()
	end
	

	gui:pop_rect()
	gui:pop_rect()

	gui:pop_rect()
end

function _update()
  if btnp(2) then menu_index = menu_index - 1 end
  if btnp(3) then menu_index = menu_index + 1 end
  menu_index = mid(1, menu_index, #menu_options)
  
	gui:flush()
	do_gui()
	gui:event_step()
end

function _draw()
	cls(5)
	gui:draw()
	print(("\^o0ffCPU: %.2f%%"):format(stat(1) * 100), 1, 1, 7)
end

require"src/error_explorer"
