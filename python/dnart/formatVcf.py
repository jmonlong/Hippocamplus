import argparse
import re
import gzip
from sets import Set


parser = argparse.ArgumentParser(description='Annotate VCF.')
parser.add_argument('-v', dest='vcf_file', help='the VCF to annotate',
                    required=True)
parser.add_argument('-f', dest='freq_file',
                    help='the dbSNP VCF with frequencies')
parser.add_argument('-o', dest='outf',
                    default='dnartree.tsv', help='the output file')
args = parser.parse_args()

print 'List RS ids to annotate'
ids = []
snps = gzip.open(args.vcf_file)
for line in snps:
    if(line[0] == '#'):
        continue
    line = line.split('\t')
    ids.append(line[2])
snps.close()
print '  ' + str(len(ids)) + ' RS ids listed'
ids = Set(ids)  # Faster to test if element in list

print 'Get frequencies from dbSNP VCF'
freqs = {}
if args.freq_file:
    freqre = re.compile('CAF=([^,]+),')
    dbsnp = gzip.open(args.freq_file)
    for line in dbsnp:
        if(line[0] == '#'):
            continue
        line = line.split('\t')
        rs = line[2]
        if(rs in ids):
            mres = freqre.search(line[7])
            freqs[rs] = mres.group(1)
    dbsnp.close()
    print '  ' + str(len(freqs.keys())) + ' RS ids annotated'

print 'Write output file'
snps = gzip.open(args.vcf_file)
outf = open(args.outf, 'w')
for line in snps:
    if(line[0] == '#'):
        continue
    line = line.rstrip('\n').split('\t')
    rs = line[2]
    freq = 0
    info = line[9].split(':')
    gt = 2
    if(info[0] == '0/0'):
        gt = 0
    elif (info[0] == '0/1'):
        gt = 1
    if(rs in freqs):
        freq = freqs[rs]
    outf.write(line[0] + '\t' + str(gt) + '\t' + str(freq) + '\n')
snps.close()
outf.close()
