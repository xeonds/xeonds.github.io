import os

for i in os.listdir('./'):
    print(i)
    if len(str(i))==len('ead28a3323105277949e59b3fdfabd09.md'):
        os.system('rm '+i)
