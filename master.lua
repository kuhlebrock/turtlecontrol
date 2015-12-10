rednet.open("right")

protocol = "TurtleControl0.9d"
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
end