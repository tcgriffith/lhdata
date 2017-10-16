import sys
import urllib
import hashlib
def GetSign(params, appkey, AppSecret=None):  
    params['appkey'] = appkey
    data = ""
    paras = params.keys()
    paras.sort()
    data = urllib.urlencode(params)
    print(data)
    if AppSecret == None:
        return data
    m = hashlib.md5()
    m.update(data + AppSecret)
    return data + '&sign=' + m.hexdigest()

def main():
    params={'id':15318829}
    appkey="f3bb208b3d081dc8"
    testsign = GetSign(params,appkey)
    print "sign:{0}".format(testsign)
    


if __name__ == '__main__':
    sys.exit(main())
