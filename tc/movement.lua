function up()
	if turtle.up() then
		location.movedUp()
		return true
	else
		return false
	end
end

function safeUp()
	while not turtle.up() do
		print("Can not go up. Trying again...")
		sleep(1)
	end
	location.movedUp()
end

function forceUp()
	while not turtle.up() do
		turtle.digUp()
	end
	location.movedUp()
end

function down()
	if turtle.down() then
		location.movedDown()
		return true
	else
		return false
	end
end

function safeDown()
	while not turtle.down() do
		print("Can not go down. Trying again...")
		sleep(1)
	end
	location.movedDown()
end

function forceDown()
	while not turtle.down() do
		turtle.digDown()
	end
	location.movedDown()
end

function forward()
	if turtle.forward() then
		location.movedForward()
		return true
	else
		return false
	end
end

function safeForward()
	while not turtle.forward() do
		print("Can not go forward. Trying again...")
		sleep(1)
	end
	location.movedForward()
end

function forceForward()
	while not turtle.forward() do
		turtle.dig()
	end
	location.movedForward()
end

function back()
	if turtle.back() then
		location.movedBack()
		return true
	else
		return false
	end
end

function safeBack()
	while not turtle.back() do
		print("Can not go back. Trying again...")
		sleep(1)
	end
	location.movedBack()
end

function turnLeft(n)
	if n == nil then
		n = 1
	end
	for i=1,n do
		turtle.turnLeft()
		location.turnedLeft()
	end
end

function turnRight(n)
	if n == nil then
		n = 1
	end
	for i=1,n do
		turtle.turnRight()
		location.turnedRight()
	end
end