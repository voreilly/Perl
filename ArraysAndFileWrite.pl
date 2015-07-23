#!/usr/bin/perl

############################################################################## 
# ArraysAndFileWrite.pl
#  Play with arrays, hashes and filewrites in perl.
#  
# AUTHOR
#  Vernon O' Reilly
# DATE
#  23 July 2015
# VERSION
#  1.0
# PURPOSE
#  Enter purpose here
# USAGE
#  perl ArraysAndFileWrite.pl
# LICENSE
#  You may copy and redistribute this program as you see fit, with no
#  restrictions.
# WARRANTY
#  This program comes with NO warranty, real or implied.
############################################################################### 

use strict;
use warnings;
use v5.10;
use Data::Dumper;


my @arr = (1,2,3,8,6,9);
print "arr 0: $arr[0]\n";
print "arr 1: $arr[1]\n";
print "arr 2: $arr[2]\n";

my %haash;
$haash{0} = 1;
$haash{1} = 2;
$haash{2} = 3;


print "hash 0: $haash{0}\n";
print "hash 1: $haash{1}\n";
print "hash 2: $haash{2}\n";

my @onlybiggerthan5arr;
foreach my $i (@arr) {
push @onlybiggerthan5arr, $i if $i > 5;
}

say "Printing out results";
say Dumper @onlybiggerthan5arr;

open FILE, ">out.txt" or die $!;
print FILE "Start:\n";
print FILE @onlybiggerthan5arr;
print FILE "\n";
print FILE "End.\n";
print FILE "\n";
close FILE;
