 args = {...}
 
 branch = "master"
 if #args == 1 then
	branch = args[1]
 end
 
 filename = "update" .. branch
 
 shell.run("github", "get", "tbsk/turtlecontrol/" .. branch .. "/updatetc.lua", filename)
 shell.run(filename)
 fs.delete(filename)
 os.reboot()