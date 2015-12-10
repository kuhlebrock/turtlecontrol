print("Loading TurtleControl APIs...")
os.loadAPI("tc/movement")
os.loadAPI("tc/builder")
os.loadAPI("tc/miner")
os.loadAPI("tc/inventory")
os.loadAPI("tc/utils")
os.loadAPI("tc/location")
print("All APIs loaded.")

-- ### Overwriting functions ###
print("Overwriting native functions...")
nativeForward = turtle.forward
turtle.forward = function()
	if nativeForward() then
		location.movedForward()
		return true
	else
		return false
	end
end

nativeBack = turtle.back
turtle.back = function()
	if nativeBack() then
		location.movedBack()
		return true
	else
		return false
	end
end

nativeUp = turtle.up
turtle.up = function()
	if nativeUp() then
		location.movedUp()
		return true
	else
		return false
	end
end

nativeDown = turtle.down
turtle.down = function()
	if nativeDown() then
		location.movedDown()
		return true
	else
		return false
	end
end

nativeTurnLeft = turtle.turnLeft
turtle.turnLeft = function()
	nativeTurnLeft()
	location.turnedLeft()
end

nativeTurnRight = turtle.turnRight
turtle.turnRight = function()
	nativeTurnRight()
	location.turnedRight()
end

print("Done")