import os
# delete_lines(源文件夹，目标文件夹，删除的起始行，删除的终止行)
def delete_lines(source,target,begin,end):
    for root,dirs,files in os.walk(source):
        for file in files:
            f1=open(os.path.join(root,file),"rb")      # 打开源文件
            f2=open(os.path.join(target,file),"wb")    # 打开目标文件
            count=0
            while count < (begin-1):
                current_line=f1.readline().decode(errors='replace')
                f2.write(current_line)        # 将被删除部分之前的每一行写入新文件
                count+=1                      # while循环结束后，光标位于被删除部分首行
            for i in range(end-begin+2):      # 移动光标 跳至被删除部分的下一行
                next_line=f1.readline().decode(errors='replace')
            while next_line:
                f2.write(next_line)
                next_line=f1.readline()       # 将被删除部分之后的每一行写入新文件
                f1.close()
                f2.close()

if __name__ == '__main__':
    source_path = r'_posts/'
    target_path = r'new/'
    delete_lines(source_path,target_path,5,5)   # 删除26-37行
    print('finish!')
