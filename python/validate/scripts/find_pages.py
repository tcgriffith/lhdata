import pickle 

results = dict()
# console output saved from validity check
file = open("invalid.txt",'r').read()
invalid = file.splitlines()
invalid = [inv.split()[1] for inv in invalid]

mapping = open("mapping"+".pickle","rb")
mapping = pickle.load(mapping)

for post in mapping:
	for postav in mapping[post]:
		if postav in invalid:
			if post not in results:
				results[post] = [postav]
			else:
				results[post].append(postav)

for post in results:
	print(post, end = "")
	for av in results[post]:
		print(" av"+str(av), end = "")
	print("\n")