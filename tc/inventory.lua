selectedSlot = 1
turtle.select(selectedSlot)

function selectSlot(i)
	if turtle.select(i) then
		selectedSlot = i
	else
		print("Could not select slot " .. i)
	end
end

function refuelAll()
	print("Refueling...")
	for i=1,16 do
		selectSlot(i)
		turtle.refuel()
	end
	selectSlot(1)
end

function refuelMin(minimum)
	refuelAll()
	while turtle.getFuelLevel() < minimum do
		print("Need more fuel. Insert coal and press ENTER.")
		read()
		refuelAll()
	end
end

function getItemCount(i)
	if i == nil then
		i = selectedSlot
	end
	return turtle.getItemCount(i)
end

function getSelectedSlot()
	return selectedSlot
end

function selectNextFullSlot()
	for i=1,16 do
		if turtle.getItemCount(i) > 0 then
			selectSlot(i)
			return true
		end
	end
	return false
end

function selectNextFullSlotFromTo(from,to)
	for i=from, to do
		if turtle.getItemCount(i) > 0 then
			selectSlot(i)
			return true
		end
	end
	return false
end

-- selects the next slot of current block in inventory
-- if none available then the given slot is selected
-- returns true of slot ~= i
-- flase if same slot is used
function selectNextSlotOfSameType(slot)
	selectSlot(slot)
	for i=1,16 do
		if i ~= slot then
			if turtle.compareTo(i) then
				return i, true
			end
		end
	end
	return slot, false
end

function isFull()
	for i=1,16 do
		if turtle.getItemCount(i) == 0 then
			return false
		end
	end
	return true
end

function isEmpty()
	for i=1,16 do
		if turtle.getItemCount(i) > 0 then
			return false
		end
	end
	return true
end

function inventoryToChest()
	movement.turnLeft(2)
	-- select chest
	selectSlot(1)
	
	if not turtle.place() then
		-- TODO: TRY AGAIN. MAYBE DIG?
		placed = false
		for z=1,3 do
			miner.forceDig()
			if turtle.place() then
				placed = true
				break
			end
			print("Could not place. Trying again in 3 seconds...")
			os.sleep(3)
		end
		if not placed then
			print("Could not place chest. Exiting...")
			return	
		end
		
	end
	while not isEmpty() do
		for n=2,16 do
			selectSlot(n)
			if not (getItemCount() == 0) then
				while not turtle.drop() do
					--nothing ... just try mkay?
					print("Could not drop. Trying again...")
					os.sleep(2)
				end
			end
		end
	end
	selectSlot(1)
	if not turtle.dig() then
		print("Could not destroy chest.")
	end
	movement.turnLeft(2)
end