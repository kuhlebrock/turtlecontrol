fs.makeDir("tc")
file = fs.open("master", "w")
text = [[rednet.open("right")

protocol = "TurtleControl0.9"
running = true
function broadcast(msg)
	rednet.broadcast(protocol .. " " .. msg)
end

function sendToSelf(msg)
	shell.run("startup", msg)
end

function optionTunnel()
	print("Laenge des Tunnels:")
	length = read()
	broadcast("tunnel " .. length)
	--start own turtle
	sendToSelf("tunnel " .. length)
end

function optionTunnelEmpty()
	print("Laenge des Tunnels:")
	length = read()
	broadcast("tunnelempty " .. length)
	--start own turtle
	sendToSelf("tunnelempty " .. length)
end

function optionRefuel()
	broadcast("refuel")
	sendToSelf("refuel")
end

function optionRemoteControl()
	print("Befehle auch selbst ausfuehren? (Y/n)")
	self = true
	input = read()
	if input == "n" then
		self = false
	end
	
	controlling = true
	while controlling do
		print("Befehl eingeben ('stop' um zu beenden):")
		cmd = read()
		if cmd == "stop" then
			controlling = false
		else
			broadcast("remotecontrol " .. cmd)
			if self then
				sendToSelf("remotecontrol " .. cmd)
			end
		end 
	end
end

function optionCuboid()
	print("Breite des Quaders:")
	width = read()
	print("Hoehe des Quaders:")
	height = read()
	print("Laenge des Quaders:")
	length = read()
	print("Soll das Inventar, wenn es voll ist in einer Truhe geleert werden? (Y/n)")
	print("Die Truhe muss sich im ersten Slot der Turtle befinden.")
	chest = read()
	
	useChest = "1"
	if chest == "n" then
		useChest = "0"
	end
	
	broadcast("cuboid " .. width .. " " .. height .. " " .. length .. " " .. useChest)
	sendToSelf("cuboid " .. width .. " " .. height .. " " .. length .. " " .. useChest)
end

function optionBuildUp()
	print("Wie hoch soll gebaut werden?")
	height = read()
	broadcast("buildup " .. height)
end

function optionCallFunc()
	while true do
		print("Befehl eingeben (exit to stop):")
		cmd = read()
		if cmd == "exit" then
			break
		end
		broadcast("call " .. cmd)
	end
end

function optionTurnOnTurtles()
	broadcast("turnOnAll")
	sendToSelf("turnOnAll")
end



-- ### MAIN ###

while running do
	print("Aktionen:")
	print("1	Tunnel graben.")
	print("2	Turtles betanken.")
	print("3	Tunnel graben und Inventar leeren.")
	print("4	Remote control.")
	print("5	Quader graben. (Optional mit Truhe)")
	print("6	Nach oben bauen.")
	print("7	Programmfunktionen aufrufen.")
	print("8	Alle Turtles anschalten.")
	print("9	Exit")
	print("Aktion waehlen:")

	input = read()

	if input == "1" then
		optionTunnel()
	elseif input == "2" then
		optionRefuel()
	elseif input == "3" then
		optionTunnelEmpty()
	elseif input == "4" then
		optionRemoteControl()
	elseif input == "5" then
		optionCuboid()
	elseif input == "6" then
		optionBuildUp()
	elseif input == "7" then
		optionCallFunc()
	elseif input == "8" then
		optionTurnOnTurtles()
	elseif input == "9" then
		running = false
	else
		print("Unknown input.")
	end
end]]
file.write(text)
file.close()
file = fs.open("startup", "w")
text = [[rednet.open("right")
 
protocol = "TurtleControl0.9"
search = true
print("Starting " .. protocol .. " (by Prinzer)")
os.loadAPI("tc/turtlecontrol")

sides = {"left", "right", "top", "bottom", "front", "back"}

function split(str, pattern)
  list = {}
  for x in string.gmatch(str, pattern) do
    table.insert(list, x)
  end
  return list
end

function tableToString(tbl)
	str = ""
	for k,v in ipairs(tbl) do
		if str == "" then
			str = v
		else
			str = str .. " " .. v
		end
	end
	return str
end

function turnOnAll()
	for _,side in ipairs(sides) do
		if peripheral.getType(side) == "turtle" then
			peripheral.call(side, "turnOn")
		end
	end
end
 
function handleCommand(cmd, args)
  if(cmd == "tunnel") then
    print("Starting to build a tunnel.")
    if args[1] ~= nil then
      shell.run("tunnel", args[1])
    end
  elseif cmd == "refuel" then
	print("Refueling...")
	shell.run("refuel","all")
  elseif cmd == "remotecontrol" then
	toExecute = tableToString(args)
	print("Executing command: " .. toExecute)
	shell.run(toExecute)
  elseif cmd == "cuboid" then
	if #args == 4 then
		miner.mineCuboid(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), (tonumber(args[4]) == 1))
	else
		print("USAGE: cuboid <width> <height> <length> <chest>")
		print("chest: 0 (no), 1 (yes)")
	end
  elseif cmd == "plane" then
	-- width, height, length
	if #args == 2 then
		width = tonumber(args[1])
		length = tonumber(args[2])
		
		builder.buildPlane(width, length)
	else
		print("USAGE: plane <width> <length>")
	end
  elseif cmd == "buildup" then
	if  #args == 1 then
		builder.buildUp(tonumber(args[1]))
	end
  elseif cmd == "call" then
	func = table.remove(args,1)
	handleCommand(func, args)
  elseif cmd == "stairs" then
	if #args == 4 then
		steps = tonumber(args[1])
		width = tonumber(args[2])
		gap = tonumber(args[3])
		stairs = tonumber(args[4])
		builder.buildStairs(steps,width,gap,stairs)
	else
		print("USAGE: stairs <steps> <width> <gap> <stairs>")
	end
  elseif cmd == "turnOnAll" then
	turnOnAll()
  elseif cmd == "inventoryToChest" then
	inventory.inventoryToChest()
  elseif cmd == "placeTurtles" then
	if #args == 2 then
		numberTurtles = tonumber(args[1])
		distanceTurtles = tonumber(args[2])
		utils.placeTurtles(numberTurtles, distanceTurtles)
	else
		print("USAGE: placeTurtles <number of turtles> <distance between turtles>")
	end
  end
end
 
function parseCommand(msg)
  splitted = split(msg, "%S+")
 
  prot = table.remove(splitted,1)
  if prot ~= protocol then return end
  
  cmd = table.remove(splitted,1)
  if cmd ~= nil then
    newThread(handleCommand, cmd, splitted)
  end
end

function rednetReceive()
	while (search) do
	  print("Waiting for command...")
	  id, msg, dist = rednet.receive()
	 
	  parseCommand(msg)
	end
end

function newThread(f,...)
	if #threads > 1 then -- remove working thread
		print("Stopping active thread.")
		table.remove(threads, 2)
	end
	c = coroutine.create(f)
	table.insert(threads, c)
	coroutine.resume(c, unpack(arg))
	return c
end

args = {...}
-- Turn all turles on
turnOnAll()
threads = {}
if #args == 0 then
	newThread(rednetReceive)
	while true do
		tEvents = {os.pullEvent()}
		for i=1, #threads do
			coroutine.resume(threads[i], unpack(tEvents))
		end
	end
else
	cmd = table.remove(args,1)
	handleCommand(cmd, args)
end]]
file.write(text)
file.close()
file = fs.open("tc/builder", "w")
text = [[-- width, height, length

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
end]]
file.write(text)
file.close()
file = fs.open("tc/inventory", "w")
text = [[selectedSlot = 1
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
end]]
file.write(text)
file.close()
file = fs.open("tc/location", "w")
text = [[pos = nil
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
	else
		print("Could not get location.")
	end

	if calcDirection then
		old = vector.new(x,y,z)

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

		if (not moved) and forceDir then
			miner.forceDig()
			movement.forward()
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
				print("Moving vector: " .. dif.toString())
			end
		end

		movement.safeBack()
		movement.turnRight(turned)

		calDir = true
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
end]]
file.write(text)
file.close()
file = fs.open("tc/miner", "w")
text = [[-- make a cuboid 
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
end]]
file.write(text)
file.close()
file = fs.open("tc/movement", "w")
text = [[function up()
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
end]]
file.write(text)
file.close()
file = fs.open("tc/turtlecontrol", "w")
text = [[print("Loading TurtleControl APIs...")
os.loadAPI("tc/movement")
os.loadAPI("tc/builder")
os.loadAPI("tc/miner")
os.loadAPI("tc/inventory")
os.loadAPI("tc/utils")
os.loadAPI("tc/location")
print("All APIs loaded.")]]
file.write(text)
file.close()
file = fs.open("tc/utils", "w")
text = [[-- Chests in Slot 1
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
end]]
file.write(text)
file.close()
