import json, sys;
js = sys.stdin.read();
obj = json.loads(js);
flag = 0
for res in obj["logs"]:
	print("L0: " + res["message"]);
	flag = 1
for sname, section in obj["results"].iteritems():
	for line in section:
		for ins in line["affected_code"]:
			print("L" + str(ins["start"]["line"]) + ": Line " + str(ins["start"]["line"]) + ": [" + line["origin"] + "] " + line["message"])
			flag = 1
exit(flag)
