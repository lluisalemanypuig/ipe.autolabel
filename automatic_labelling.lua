----------------------------------------------------------------------
-- Automatic labelling ipelet
----------------------------------------------------------------------
--[[
This file is an extension of the drawing editor Ipe (ipe7.sourceforge.net)

Copyright (c) 2020 Lluís Alemany-Puig

This file can be distributed and modified under the terms of the GNU General
Public License as published by the Free Software Foundation; either version
3, or (at your option) any later version.

This file is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

You can find a copy of the GNU General Public License at
"http://www.gnu.org/copyleft/gpl.html", or write to the Free
Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
--]]

--[[
You'll find the instruction manual at:

https://github.com/lluisalemanypuig/autolabipe.git
--]]

label = "Automatic labelling"

about = [[
Automatic craetion of labels with customizable text.
]]

local label_count = 0					-- value of label
local offset_x = 5
local offset_y = 0
local label_string_format = "%%^L%%"	-- default text for label

-- label index function
function show_label(model)
	local str = label_string_format
	local x1, y1 = str:find('%%', nil, true)
	while x1 ~= nil do
		local x2, y2 = str:find('%%', y1, true)
		if x2 == nil then
			-- ERROR -- no matching '%%'
			model:warning("Cannot create label", "Missing matching '%%'")
			return false
		end
		
		local expr = string.sub(str, y1+1, x2-1)
		local expr_repl = expr:gsub("%^L", label_count)
		local expr_val = _G.load("return " .. expr_repl, expr_repl, "t", math)()
		str = string.sub(str, 0, x1-1) .. expr_val .. string.sub(str, y2+1)
		
		x1, y1 = str:find('%%', nil, true)
	end
	return str
end

-- make index function
function set_label(model)

	local d = ipeui.Dialog(model.ui:win(), "Expression")
	d:add("label", "label", {label="Current: " .. label_string_format}, 1, 1)
	d:add("expression", "input", {}, 2, 1, 1, 3)
	d:addButton("ok", "&Ok", "accept")
	d:addButton("cancel", "&Cancel", "reject")
	if not d:execute() then return end
	
	label_string_format = d:get("expression")
end

-- set counter to 0
function reset_label(model)
	label_count = 0
end

-- prompt the user asking where to put the label next to selected objects
function geometry_label(model)
	local d = ipeui.Dialog(model.ui:win(), "Specify label offset")
	
	d:add("label1", "label", {label="x offset"}, 1, 1)
	d:add("offset_x", "input", {}, 1, 2, 1, 3)
	d:add("label2", "label", {label="y offset"}, 2, 1)
	d:add("offset_y", "input", {}, 2, 2, 1, 3)
	d:addButton("ok", "&Ok", "accept")
	d:addButton("cancel", "&Cancel", "reject")
	if not d:execute() then return end
	
	offset_x = d:get("offset_x")
	offset_y = d:get("offset_y")
end

-- create the label
function make_label(model)
	local p = model:page()
	if p:hasSelection() then
		-- selection detected: put label in every selected object
		
		local selection = {}
		for i, obj, sel, layer in p:objects() do
			if sel then
				selection[#selection + 1] = i
			end
		end
		
		p:deselectAll()
		
		for key,value in ipairs(selection) do
			-- if object 'obj' is selected then...
			label_count = label_count + 1
			
			-- text to be put in the label
			local text_str = show_label(model)
			if text_str == false then
				return
			end
			
			-- position of the object
			local pos = p:bbox(value):topRight()
			--    translate a bit the label
			pos = pos + ipe.Vector(offset_x, offset_y)
			-- create the text label
			local text = ipe.Text(model.attributes, text_str, pos)
			
			-- add the text label to the document
			model:creation("create label", text)
		end
	else
		-- 
		-- no selection detected: put label in mouse
		--
		label_count = label_count + 1
		
		-- text to be put in the label
		local text_str = show_label(model)
		if text_str == false then
			return
		end
		
		-- position of the mouse
		local pos = model.ui:pos()
		-- create the text label
		local text = ipe.Text(model.attributes, text_str, pos)
		
		-- add the text label to the document
		local id = model:creation("create label", text)
		
		p:deselectAll()
	end
end

methods = {
	{ label = "Make label", run = make_label},
	{ label = "Set labelling expression", run = set_label},
	{ label = "Reset label counter", run = reset_label},
	{ label = "Set label geometry", run = geometry_label},
}
