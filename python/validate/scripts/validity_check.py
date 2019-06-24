import requests, os, re, time, pickle
import urllib.request

posts_path = "content/post"
# save ".md -> [av1, av2, av3]"
mapping = dict()
# all avs
full_set = set()
# invalid av#s
invalid = []

def queryOne(avnum):
	# used bilibili api... somewhat ugly but seems to work
	# url = "http://api.bilibili.com/x/reply?type=1&oid=" + str(avnum) + "&pn=1&nohot=1&sort=0"
	url = "http://api.bilibili.com/x/reply?type=1&oid=" + str(avnum)
	# url = "http://api.bilibili.cn/spview?aid="+str(avnum)
	r = requests.get(url)
	r.encoding = r.apparent_encoding
	if(r.text.count("禁止评论") > 0):
		invalid.append(avnum)
		print("invalid", avnum)
	# i saved the console output to a txt file, alternatively can run 
		# invalid.append("invalid " + str(avnum))
	

def queryAll(file):
	avs = open(file, encoding="utf-8").read().splitlines()
	for av in avs:
		avnum = int(av)
		queryOne(avnum)
		time.sleep(.300)
	f = open("invalid.txt", "w", encoding = "utf-8")
	f.write("\n".join(invalid))

if __name__ == '__main__':

	files = os.listdir(posts_path)
	for file in files:
		if (file.endswith("swp")):
			continue
		file_path = os.path.join(posts_path, file)
		content = open(file_path, encoding = "utf-8").read()
		avs = re.findall(r'www\.bilibili\.com/video/av(\d*)', content)
		if (len(avs) == 0):
			continue
		mapping[file] = list(set(avs))	
		full_set.update(avs)

	all_videos = open("all_videos", "w", encoding = "utf-8")
	all_videos.write("\n".join(list(full_set)))
	mapping_out = open("mapping.pickle","wb")
	pickle.dump(mapping, mapping_out)
	queryAll("all_videos")

def read(pik):
	tmp = open(pik+".pickle","rb")
	return pickle.load(tmp)
