-- width, height, length

function buildPlane(width, length)
	movement.safeUp()
	movement.turnRight()
	for l=1, length do
		placeDownSafe()
		for w=1, width-1 do
			movement.safeForward()
			placeDownSafe()
		end
		-- turn to next
		if l < length then
			if l % 2 == 1 then
				movement.turnLeft()
				movement.safeForward()
				movement.turnLeft()
			else
				movement.turnRight()
				movement.safeForward()
				movement.turnRight()
			end
		end
		
	end
end

function buildUp(n)
	for i=1, n do
		movement.safeUp()
		placeDownSafe()
	end
end

-- start on right side
-- stairs go counter-clockwise
function buildStairs(steps,width,gap,stairs)
	print("Building stairs with:" .. steps .. " steps, " .. width .. " width, " ..gap.." gap, " ..stairs.." stairs")
	for stair=1,stairs do
		movement.forceUp()
		movement.turnLeft()
		
		for step=1, steps do
			--one row
			placeDownSafe()
			for w=1,width-1 do
				movement.forceForward()
				placeDownSafe()
			end
			
			if not (step == steps) then
				if step%2 == 1 then
					movement.turnRight()
				else
					movement.turnLeft()
				end
				
				movement.forceForward()
				movement.forceUp()
				
				if step%2 == 1 then
					movement.turnRight()
				else
					movement.turnLeft()
				end
			end
		end
		
		if not (stair == stairs) then
			if steps%2 == 1 then
				for i=1, gap+width do
					movement.safeForward()
				end
			else
				movement.turnLeft(2)
				for i=1, gap+2*width do
					movement.safeForward()
				end
			end
			movement.turnLeft()
		end
	end
end

function placeDownSafe()
	if inventory.getItemCount() == 0 then
		while not inventory.selectNextFullSlot() do
			print("No more items. Fill Inventory.")
			print("Press Enter to proceed.")
			read()
		end
	end
	turtle.placeDown()
end