import os

def wCreateDir(path):
	path = path.replace(".\\", "")
	path = path.replace("\\", "/")
	print("Creating dir: " + path)
	file.write("print(\"Creating dir: " + path + "\")")
	file.write("fs.makeDir(\"" + path + "\")\n")



file = open("updatetc.lua", "w+")

for dirname, dirnames, filenames in os.walk('.'):
	filenames = [f for f in filenames if not f[0] == '.']
	dirnames[:] = [d for d in dirnames if not d[0] == '.']
	
    # create dirs
	for subdirname in dirnames:
		wCreateDir(os.path.join(dirname, subdirname))

    # print path to all filenames.
	for filename in filenames:
		if filename == "updatetc.lua":
			continue
		if ".lua" not in filename:
			continue
		path = os.path.join(dirname, filename)
		
		f = open(path)
		text = "[[" + f.read() + "]]\n"
		path = path.replace(".\\", "")
		path = path.replace(".lua", "")
		path = path.replace("\\", "/")
		
		print("Adding file: " + path)
		file.write("print(\"Creating file: " + path + "\")")
		file.write("file = fs.open(\"" + path + "\", \"w\")\n")
		file.write("text = " + text)
		file.write("file.write(text)\n")
		file.write("file.close()\n")
		
file.close()
print("Done. Enter to exit.")
input()