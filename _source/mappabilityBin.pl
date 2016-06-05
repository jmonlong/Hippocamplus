#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $inputBG;
my $binS = 1000;
my $outputBed;
GetOptions('i=s'=>\$inputBG,
	   'o=s'=>\$outputBed,
	   'bin=s'=>\$binS);

print "Bin size: \t".$binS."\n";
open(IN,$inputBG) or die "Can't open input bedGraph file: $!";
open(OUT,">".$outputBed) or die "Can't create output Bed file: $!";

## Init
my $binL = 1;
my $binU = $binL + $binS;
my $map = 0;

## Read first line
my $line = <IN>;
chomp $line;
my @line = split(/\t/,$line);
my $c = $line[0];
my $l = $line[1];
my $u = $line[2];
my $m = $line[3];
my $continue = 1;
my $chr = $c;

print $chr."...\n";
while($continue){
    while($c eq $chr && $l < $binU-1 && $continue){
	if($u < $binU-1){
	    $map += $m * ($u - $l);
	    ## Read new line...
	    if(defined($line = <IN>)){
		chomp $line;
		@line = split(/\t/,$line);
		$c = $line[0];
		$l = $line[1];
		$u = $line[2];
		$m = $line[3];
	    } else {
		$continue = 0;
	    }
	} else {
	    $map += $m * ($binU-1 - $l);
	    $l = $binU-1;
	}
    }
    ## Mean mappability
    $map = $map / $binS;
    print OUT $chr."\t".$binL,"\t".($binU-1)."\t".$map."\n";

    ## Next bin or chr
    $map = 0;
    if($c ne $chr){
	$chr = $c;
	print $chr."...\n";
	$binL = 1;
	$binU = $binL + $binS;
    } else {
	$binL = $binU;
	$binU = $binL + $binS;
    }
}
close(OUT);
close(IN);
