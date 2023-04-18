-- Author:     Russel Costales
-- Module:     Rotated Box (y-axis)
-- Date:       4/18/2023

-- This code checks whether a point is within a box rotated only rotated around the y-axis.
-- It can check for 2d rectangles if the y value checks are discarded.

local point = script.Parent.Point
local rectangle = script.Parent.Part

while task.wait() do
	local pointPos = point.Position
	
	local r_sx = rectangle.Size.X
	local r_sz = rectangle.Size.Z
	local r_sy = rectangle.Size.Y / 2
	
	-- Find the two corners of the rectangle in 2d space containing x, -x, z, -z max values of
	-- the rect
	local recCFrame = rectangle.CFrame
	
	local d_vz = recCFrame.LookVector * (r_sz / 2)
	local d_vx = recCFrame.RightVector * (r_sx / 2)
	
	local corners = {
		recCFrame + d_vz + d_vx, -- Top right
		recCFrame + -d_vz + -d_vx, -- Bottom left
	}
	
	-- Get rotation of the rectangle
	local _, yaw, _ = recCFrame:ToEulerAnglesYXZ()
	
	-- Undo the rotation of the corners, but rotate around the point being checked
	for i = 1, 2 do
		local x = corners[i].Position.X - pointPos.X
		local z = corners[i].Position.Z - pointPos.Z
		
		local d_x = (x * math.cos(yaw) - z * math.sin(yaw)) + pointPos.X
		local d_z = (z * math.cos(yaw) + x * math.sin(yaw)) + pointPos.Z
		
		corners[i] = {x = d_x, z = d_z}
	end
	
	local r_y = recCFrame.Position.Y
	local max_x, min_x = corners[1].x > pointPos.x, corners[2].x < pointPos.x
	local max_z, min_z = corners[2].z > pointPos.z, corners[1].z < pointPos.z
	local max_y, min_y = r_y + r_sy > pointPos.Y, r_y - r_sy < pointPos.Y
	
	if max_x and min_x and max_z and min_z and max_y and min_y then
		print("in box")
	end
end
