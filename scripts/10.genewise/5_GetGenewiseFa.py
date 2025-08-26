import os
root_addr = "/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise/Orthogroups"
out_file = "allout.fa"
fa = []

def GetAllOGOutput():
    names = []
    for file_name in os.listdir(root_addr):
        names.append(root_addr + "/" + file_name + "/" + file_name + "_genewise1_b3_out")
        names.append(root_addr + "/" + file_name + "/" + file_name + "_genewise2_b3_out")
    return names

files = GetAllOGOutput()

for file in files:
    for out in os.listdir(file):
        if "out" in out:
            with open(file + "/" + out) as f:
                flag = 0
                for i in f:
                    if "//" in i:
                        flag += 1
                    if flag % 2 == 1:
                        fa.append(i)

with open(out_file,"w") as o:
    for i in fa:
        if "//" in i:
            pass
        else:
            o.write(i)
