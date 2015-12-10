function up()
	return turtle.up()
end

function safeUp()
	while not turtle.up() do
		print("Can not go up. Trying again...")
		sleep(1)
	end
end

function forceUp()
	while not turtle.up() do
		turtle.digUp()
	end
end

function down()
	return turtle.down()
end

function safeDown()
	while not turtle.down() do
		print("Can not go down. Trying again...")
		sleep(1)
	end
end

function forceDown()
	while not turtle.down() do
		turtle.digDown()
	end
end

function forward()
	return turtle.forward()
end

function safeForward()
	while not turtle.forward() do
		print("Can not go forward. Trying again...")
		sleep(1)
	end
end

function forceForward()
	while not turtle.forward() do
		turtle.dig()
	end
end

function back()
	return turtle.back()
end

function safeBack()
	while not turtle.back() do
		print("Can not go back. Trying again...")
		sleep(1)
	end
end

function turnLeft(n)
	if n == nil then
		n = 1
	end
	for i=1,n do
		turtle.turnLeft()
	end
end

function turnRight(n)
	if n == nil then
		n = 1
	end
	for i=1,n do
		turtle.turnRight()
	end
end

function face(dir)
	while location.getDirection() ~= dir do
		movement.turnLeft()
	end
end


-- ############## coordinate based walking ##############
function gotoCoords(x,y,z)
	local vDest = vector.new(x,y,z)
	local vMove = vDest - location.getPos()
	print("Moving to " .. vDest:tostring())
	
	
end