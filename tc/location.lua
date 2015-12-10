pos = nil
calPos = false -- if gps coordinates are calibrated, or nil
calDir = false -- if direction is calibrated

-- 0 North (-Z), 1 West (-X), 2 South (+Z), 3 East (+X) # TODO: confirm
direction = nil

NORTH = 0
WEST = 1
SOUTH = 2
EAST = 3

-- ARGS: 
-- direction:boolean (calibrate direction?)
-- forceDir:boolean (dig if cant move?)

function calibrate(calcDirection, forceDir)
	if forceDir == nil then forceDir = false end

	calPos = false
	calDir = false

	print("Calibrating location...")
	pos = vector.new(gps.locate(3, true))
	if pos ~= nil then
		calPos = true
		print("I'm at " .. pos:tostring())
	else
		print("Could not get location.")
	end

	if calcDirection then
		old = pos

		moved = false
		turned = 0
		for i=0, 3 do
			if not turtle.detect() then
				turned = i
				moved = movement.forward()
				break
			else
				movement.turnLeft()
			end
		end

		if not moved then
			if forceDir then
				miner.forceDig()
				movement.forward()
			else
				return
			end
		end

		new = vector.new(gps.locate(3, true))

		if new ~= nil then
			dif = new - old
			if dif.z < 0 then
				direction = NORTH
			elseif dif.z > 0 then
				direction = SOUTH
			elseif dif.x < 0 then
				direction = WEST
			elseif dif.x > 0 then
				direction = EAST
			else
				print("Something went wrong.")
				print("Moving vector: " .. dif:tostring())
			end
			print("My direction is: " .. direction)
			calDir = true
		end
		
		movement.safeBack()
		movement.turnRight(turned)

	end
end

function setPosition(nx, ny, nz)
	pos.x = nx
	pos.y = ny
	pos.z = nz
end

function setDirection(dir)
	direction = dir
end

function movedForward()
	if calPos and calDir then
		if direction == NORTH then
			pos.z = pos.z - 1
		elseif direction == WEST then
			pos.x = pos.x - 1
		elseif direction == SOUTH then
			pos.z = pos.z + 1
		elseif direction == EAST then
			pos.x = pos.x + 1	
		end
	end
end

function movedBack()
	if calPos and calDir then
		if direction == NORTH then
			pos.z = pos.z + 1
		elseif direction == WEST then
			pos.x = pos.x + 1
		elseif direction == SOUTH then
			pos.z = pos.z - 1
		elseif direction == EAST then
			pos.x = pos.x - 1	
		end
	end
end

function movedUp()
	if calPos then
		pos.y = pos.y + 1
	end
end

function movedDown()
	if calPos then
		pos.y = pos.y - 1
	end
end

function turnedLeft()
	if calDir then
		direction = (direction + 1) % 4
	end
end

function turnedRight()
	if calDir then
		direction = (direction - 1) % 4
	end
end

function getPos()
	return pos
end

function getDirection()
	return direction
end