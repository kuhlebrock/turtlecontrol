-- Chests in Slot 1
-- Turtles in Slot 2
-- TURTLE MUST BE IN SLOT 2 FOR COMPARISON!!!

function placeTurtles(turtles, distance)
	for i=1, turtles do
		for i=1, distance do
			movement.forceForward()
		end
		movement.turnLeft(2)
		
		-- place Turtle
		--slot, last = inventory.selectNextSlotOfSameType(2)
		--inventory.selectSlot(slot)
		inventory.selectSlot(i+1)
		
		while not turtle.place() do
			print("Could not place Turtle. Trying again in 1 second.")
			sleep(2)
		end
		-- fill turtle
		inventory.selectSlot(1)
		if not turtle.detect() then
			print("No chest in front? Exiting...")
			break
		else
			while not (inventory.getItemCount(1) > 0) do
				print("No more chests. Insert chests and press ENTER.")
				read()
			end
		end
		turtle.drop(1)
		if peripheral.getType("front") == "turtle" then
			peripheral.call("front", "turnOn")
		end
		
		movement.turnLeft(2)
		
		if last then
			print("No more turtles. Ending...")
			break
		end
	end
end

function keepPlacing()
	while true do
		inventory.selectNextFullSlot()
		if inventory.getItemCount() == 0 then
			sleep(1)
		end
		turtle.place()
	end
end