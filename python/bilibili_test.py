import requests
from bs4 import BeautifulSoup
import json
import os
import re
import subprocess



class BiliBili:
    Appkey = 'f3bb208b3d081dc8'
    # regex
    mid_pattern=re.compile('var _bili_space_mid = (\d+);')
    cid_pattern=re.compile('cid=(\d+)&aid=')
    
    headers = {
        'Host': 'passport.bilibili.com',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36',
        'Referer': 'https://passport.bilibili.com/ajax/miniLogin/minilogin',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Connection': 'keep-alive',
        'Origin': 'https://passport.bilibili.com'
    }
    post_url = 'https://passport.bilibili.com/ajax/miniLogin/login'
    ajax_base_url = 'http://space.bilibili.com/ajax/fav/getBoxList?mid='

    def __init__(self,username='0',password='0'):
        self.session=requests.session()
        self.post = {
            'keep': 0,
            'userid': username,
            'pwd': password,
            'captcha': ''
        }
        self.mid_url=None
        self.aid_list=[]
        self.more_p_url=[]
        self.more_p_name=[]
        self.cid_list=[]

    def cookies_login(self):
        with open("bilibili_cookies",'r') as f:
            cookies=json.load(f)
        self.session.cookies.update(cookies)


    def password_login(self):
        r=self.session.post(url=self.post_url,data=self.post,headers=self.headers)
        json_data=json.loads(r.text)
        if json_data['status']:
            print("password login success!")
            with open("bilibili_cookies",'w') as f:
                json.dump(self.session.cookies.get_dict(),f)

    def fetch_your_collection_mid(self):
        page_source=self.session.get('http://space.bilibili.com/#!/favlist').text
        mid=self.mid_pattern.findall(page_source)[0]
        self.mid_url=self.ajax_base_url+mid

    def fetch_your_collection_av_number(self):
        information=self.session.get(self.mid_url).text
        json_data=json.loads(information)
        
        for element in json_data['data']['list']:
            for aid in element['videos']:
                self.aid_list.append(aid['aid'])

    def get_the_source_information(self):
        for aid in self.aid_list:
            information=self.session.get('http://www.bilibili.com/video/av{}/'.format(aid)).text
            soup=BeautifulSoup(information,'lxml')
            if len(soup.findAll('option'))!=0:
                for element in soup.findAll('option'):
                    self.more_p_url.append('http://www.bilibili.com'+element['value'])
                    self.more_p_name.append(element.string)
            else:
                self.more_p_url.append('http://www.bilibili.com/video/av{}/'.format(aid))
                self.more_p_name.append(soup.find("div",{"class":"qr-info-head"}).string)
        print(self.more_p_url)
        print(self.more_p_name)

    def fetch_cid(self):
        for element in self.more_p_url:
            information=self.session.get(element).text
            data=self.cid_pattern.findall(information)[0]
            self.cid_list.append(data)
        print(self.cid_list)

    def dowload_by_flv_or_mp4(self,url,name):
        if ".flv" in url:
            with open(name + ".flv", "wb") as f:
                print("Begin to dowload" + name+".flv")
                f.write(self.session.get(url).content)
                print('finished!')
        elif ".mp4" in url:
            with open(name + ".mp4", 'wb') as f:
                print("Begin to dowload" + name+".mp4")
                f.write(self.session.get(url).content)
                print("finished!")

    def ffmpeg_txt(self,url,count):
        with open('hello.txt', 'a') as r:
            if '.flv' in url:
                r.write("file" + ' ' + "'{}'".format(str(count)+'.flv') + '\n')
            elif '.mp4' in url:
                r.write("file" + ' ' + "'{}'".format(str(count)+'.mp4') + '\n')


    def get_movies_information(self):
        for index in range(len(self.cid_list)):
            information=self.session.get('http://interface.bilibili.com/playurl?appkey='+self.Appkey+'&cid='+self.cid_list[index]+'&otype=json').text
            json_data=json.loads(information)
            if len(json_data['durl'])==1:
                try:
                    url=json_data['durl'][0]['url']
                    self.dowload_by_flv_or_mp4(url,self.more_p_name[index])
                except:
                    if len(json_data['durl'][0]['backup_url'])==0:
                        print("failed to dowload"+self.more_p_name[index])
                    else:
                        try:
                            for element in json_data['durl'][0]['backup_url']:
                                self.dowload_by_flv_or_mp4(element,self.more_p_name[index])
                        except:
                            print('faild to dowload'+self.more_p_name[index])
            else:
                count=1
                for element in json_data['durl']:
                    try:
                        url=element['url']
                        self.dowload_by_flv_or_mp4(url,str(count))
                        self.ffmpeg_txt(url,count)
                        count+=1
                    except:
                        try:
                            for url in element['backup_url']:
                                    self.dowload_by_flv_or_mp4(url,str(count))
                                    self.ffmpeg_txt(url,count)
                                    count+=1
                        except:
                                print("failed to dowload"+self.more_p_name[index])
                command = ['ffmpeg', '-f', 'concat', '-i', 'hello.txt', '-c', 'copy','{}.flv'.format(self.more_p_name[index])]
                subprocess.call(command)
                for i in range(1,count+1):
                    if str(i)+".flv" in os.listdir('.'):
                        command=['rm','-rf',str(i)+'.flv']
                        subprocess.call(command)
                    elif str(i)+".mp4" in os.listdir('.'):
                        command=['rm','-rf',str(i)+'.mp4']
                        subprocess.call(command)
                command=['rm','-rf','hello.txt']
                subprocess.call(command)

    def start(self):
        if "bilibili_cookies" in os.listdir('.'):
                try:
                    self.cookies_login()
                except:
                    self.password_login()
        else:
            self.password_login()

        # self.fetch_your_collection_mid()
        # self.fetch_your_collection_av_number()
        # self.get_the_source_information()
        # self.fetch_cid()
        # self.get_movies_information()


if __name__=="__main__":
    cookies=BiliBili('ztc.ustcer@gmail.com','ztc5325325')
    cookies.start()
    print "exit"
