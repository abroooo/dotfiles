import re

def create_cheatsheet(file_name):
    cheatsheet = []
    with open(file_name, 'r') as file:
        for line in file:
            match = re.search(r'Key\((.+?), lazy.+?, desc="(.+)"\)', line)
            if match:
                print(match)
                keys = match.group(1)
                description = match.group(2)
                cheatsheet.append((keys, description))
    return cheatsheet

def print_cheatsheet(cheatsheet):
    for keys, description in cheatsheet:
        keys = keys.replace('[', '').replace(']', '').replace('"', '').replace(',', ' +')
        print(f'{keys} --- {description}')

# Use the function
cheatsheet = create_cheatsheet('/home/alex/.config/qtile/config.py')
print_cheatsheet(cheatsheet)

