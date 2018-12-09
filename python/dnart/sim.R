args = commandArgs(TRUE)
N = as.numeric(args[1])
filen = 'dnatree.tsv'
if(length(args)>1){
  filen = args[2]
}
df = data.frame(chr=1, geno=sample.int(3, N, TRUE)-1, freq=round(runif(N, 0, .5), 3))
write.table(df, file=filen, sep='\t', row.names=FALSE, col.names=FALSE)
