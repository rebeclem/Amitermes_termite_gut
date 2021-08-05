import re

pairs = []
flag = False
with open("flexcleaned.log") as lf:
    for line in lf:
        if not flag:
            m = re.search(r"(Processed\s+reads\s+)(\d+)", line)
            if m:
                fn = m.group(2)
                #print fn
                flag = True
        else:
            m = re.search(r"(Remaining\s+reads\s+)(\d+)", line)
            if m:
                diff = m.group(2)
                #print diff
                flag = False
                pairs.append((fn,diff))
                fn=diff=None
                
              
with open("flexbar_reads.txt","w") as outh:
    for pair in pairs:
        print >>outh, "%s\t%s" % (pair[0], pair[1])
