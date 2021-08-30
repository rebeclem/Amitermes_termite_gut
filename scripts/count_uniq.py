import sys
reads = set()
for l in sys.stdin:
    reads.add(l.strip('\n'))

print >>sys.stdout, '%d' % len(reads)
