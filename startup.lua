rednet.open("right")
 
protocol = "TurtleControl0.9d"
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
  elseif cmd == "calibrate" then
	location.calibrate(true)
  elseif cmd == "calibratePos" then
	location.calibrate()
  elseif cmd == "forceCalibrate" then
	location.calibrate(true,true)
  elseif cmd == "face" then
	if #args == 1 then
		faceNr = tonumber(args[1])
		if (not location.isPosCalibrated()) or (not location.isDirCalibrated()) then
			location.calibrate(true,true)
		end
		location.face(faceNr)
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
end