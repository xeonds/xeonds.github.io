import shutil
import os

for i in os.listdir('hexo/'):
    with open('hexo/'+i,'rb') as f:
        t=f.read().decode(errors='replace')
    title=t.split('---')[0].split('class')[0].replace('title:','')
    os.system('mv hexo/'+i+' hexo/'+str.strip(title)+'.md')
