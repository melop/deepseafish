infile = "comb.fa"
outfile = "comb_dedup.fa"
fa = []

with open(infile) as f:
    for i in f:
        i = i.strip()
        fa.append(i)

with open(outfile,"w") as o:
    for i in range(len(fa)):
        if ">" in fa[i]:
            #fa[i] = fa[i].split(".")[0]
            o.write(">meta" + "_" + str(i) + "\n")
        else:
            o.write(fa[i] + "\n")