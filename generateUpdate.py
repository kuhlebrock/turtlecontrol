import os

def wCreateDir(path):
	path = path.replace(".\\", "")
	path = path.replace("\\", "/")
	print("Creating dir: " + path)
	file.write("fs.makeDir(\"tc\")\n")



file = open("update.lua", "w+")

for dirname, dirnames, filenames in os.walk('.'):
    # create dirs
	for subdirname in dirnames:
		wCreateDir(os.path.join(dirname, subdirname))

    # print path to all filenames.
	for filename in filenames:
		if filename == "update.lua":
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
		file.write("file = fs.open(\"" + path + "\", \"w\")\n")
		file.write("text = " + text)
		file.write("file.write(text)\n")
		file.write("file.close()\n")
		
file.close()
print("Done. Enter to exit.")
raw_input()