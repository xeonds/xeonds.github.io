import os

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    with open(file_path, 'w', encoding='utf-8') as f:
        for line in lines:
            if line.startswith('![['):
                img_name = line.split('![[', 1)[1].split(']]', 1)[0]
                img_name = img_name.split('/')[-1]
                new_line = f'![{img_name}](/img/{img_name})\n'
                f.write(new_line)
            else:
                f.write(line)

def process_dir(dir_path):
    for file_name in os.listdir(dir_path):
        file_path = os.path.join(dir_path, file_name)
        if os.path.isdir(file_path) and file_name.startswith('_'):
            process_dir(file_path)
        elif os.path.isfile(file_path) and file_name.endswith('.md'):
            process_file(file_path)

if __name__ == '__main__':
    process_dir('.')
