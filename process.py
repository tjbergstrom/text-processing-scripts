

from nltk.tokenize import word_tokenize
import os

os.system("mkdir -p tables")

os.chdir("signs")
ls = []
ls = os.popen('ls').read()
print(ls,"\n\n\n")
print(len(ls))
files = []
new_file = ""
for ch in ls:
    if ch == "\n":
        files.append(new_file)
        new_file = ""
    else:
        new_file += ch
print(files)
print(len(files))
for f in files:
    print(f)


os.chdir(".")
for f in files:
    print(f,"\n\n\n")
    f =  os.path.splitext(f)[0]
    print(f,"\n\n\n")
    cmd = " awk -F\",\" '{print $1,$2,$3,$4,$5,$8}' signs/%s > tables/%s2.csv " % (f,f)
    os.system(cmd)
    cmd = " awk \'{print $1 \",\" $2 \",\" $3 \",\" $4 \",\" $5 \",\" $8}\' tables/%s2.csv > tables/%s.csv " % (f,f)
    os.system(cmd)
    cmd = " rm tables/%s2.csv " % (f)
    os.system(cmd)



