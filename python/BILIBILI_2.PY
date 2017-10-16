# coding:utf-8
import requests
import json
from bs4 import BeautifulSoup

def get_favlist(user_id):
    url='http://space.bilibili.com/ajax/fav/getBoxList?mid='+str(user_id)
    page_boxlist=requests.get(url)
    soup=str(BeautifulSoup(page_boxlist.text,'lxml'))
    fav_str=soup[15:-18]
    fav_str=fav_str.replace("true",'1')
    fav_dict=eval(fav_str)
    return fav_dict


print json.dumps(get_favlist(5448180),sort_keys=True, indent=4,separators=(',', ': '))
