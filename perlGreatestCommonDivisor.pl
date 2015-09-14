#!/usr/bin/perl
############################################################################### 
# perlGreatestCommonDivisor.pl
#  Weiners comes in packs of 8.  Buns comes in packs of 6. How many packages of
#  both do you buy not to waste neither buns nor wieners?
#  
# AUTHOR
#  Vernon O' Reilly
# DATE
#  12 Sept 2015
# VERSION
#  1.0
# PURPOSE
#  Enter purpose here
# USAGE
#  perl perlGreatestCommonDivisor.pl
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

my $numbers = &prompt("Enter 2 numbers seperated by a comma: ", "6,8");

say "The inputs were:";
say $numbers;

#First add the string into a proper array
my @numbers = split(",", $numbers);

say "The input array is:";
say @numbers;

my @sorted = gcd($numbers[0], $numbers[1]);

say "The greatest common denominator is:";
say @sorted;

say "Output in list string format is:";
my $sortedstr;
foreach my $i (@sorted) {
    $sortedstr = $sortedstr."$i,";
}
chop($sortedstr);
say $sortedstr;

######################################################################################
# subroutine: gcd
# Purpose: take arguments if given from command line, else will use the default 345
###################################################################################### 
sub gcd {
  my ($a, $b) = @_;
  use integer;
  while ($b) {
    my $r = $a % $b;
    $r += $b if $r < 0;
    $a = $b;
    $b = $r;
  }
  return $a;
}

######################################################################################
# subroutine: prompt
# Purpose: take arguments if given from command line, else will use the default 345
###################################################################################### 
sub prompt {

my ($promptstr,$default) = @_;
if ($default) {
   say $promptstr, "[", $default, "]: ";
} else {
   print $promptstr, ": ";
      }

$| = 1; #Flush after print
$_ = <STDIN>; #Get input for STDIN
chomp; #take off new line character

if ($default) {
   return $_ ? $_ : $default; #return $_ if its got a value
} else {
   return $_;
}

}

