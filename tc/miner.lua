-- make a cuboid 
-- start is bottom left
-- width:number, height:number, length:number, chest:bool
function mineCuboid(width,height,length, chest)
	-- started in direction to length. first turn to the right
	
	for l=1, length do
	
		-- check fuel
		if turtle.getFuelLevel() < 200 then
			inventory.refuelMin(200)
		end
		
	
		if (math.floor((height-1)/3) % 2 == 1) then
			movement.turnRight()
		else
			if l % 2 == 0 then
				movement.turnLeft()
			else
				movement.turnRight()
			end
		end
		
		tunnelOneDimension(width,height)
		-- go back to start
		for i=1,height-1 do
			movement.forceDown()
		end
		-- face in right direction
		if (math.floor((height-1)/3) % 2 == 0) then
			if l%2 == 1 then
				movement.turnLeft()
			else
				movement.turnRight()
			end
		else
			movement.turnRight()
		end
		
		--inventory full? place chest
		if chest then
			if inventory.isFull() then
				--let them refuel first
				inventory.refuelAll()
				inventory.inventoryToChest()
			end
		end
		
		if not (l==length) then
			forceDig()
			movement.forceForward()
		end
	
	end
	
end

function tunnelOneDimension(width, height)
--turtle always ends in top corner
	if height > 3 then
		tunnelOneDimension(width,3)
		forceDigUp()
		movement.forceUp()
		movement.turnLeft(2)
		tunnelOneDimension(width, height-3)
	elseif height == 3 then
		forceDigUp()
		movement.forceUp()
		forceDigUp()
		for x=1, width-1 do
			forceDig()
			movement.forceForward()
			forceDigUp()
			forceDigDown()
		end
		movement.forceUp()
	elseif height == 2 then
		forceDigUp()
		for x=1, width-1 do
			forceDig()
			movement.forceForward()
			forceDigUp()
		end
		movement.forceUp()
	elseif height == 1 then
		for x=1, width-1 do
			forceDig()
			movement.forceForward()
		end
	end
end

function digUp()
	turtle.digUp()
end

function digDown()
	turtle.digDown()
end

function dig()
	turtle.dig()
end

function forceDigUp()
	while turtle.detectUp() do
		turtle.digUp()
	end
end

function forceDigDown()
	while turtle.detectDown() do
		turtle.digDown()
	end
end

function forceDig()
	while turtle.detect() do
		turtle.dig()
	end
end