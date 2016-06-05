wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bigWigToBedGraph
chmod +x bigWigToBedGraph
wget http://hgdownload.soe.ucsc.edu/gbdb/hg19/bbi/wgEncodeCrgMapabilityAlign100mer.bw
./bigWigToBedGraph wgEncodeCrgMapabilityAlign100mer.bw wgEncodeCrgMapabilityAlign100mer.bed
rm wgEncodeCrgMapabilityAlign100mer.bw
perl mappabilityBin.pl -i wgEncodeCrgMapabilityAlign100mer.bed -o map100mer-1kbp.bed -bin 1000
gzip map100mer-1kbp.bed
