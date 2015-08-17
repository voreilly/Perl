#!/usr/bin/perl
############################################################################### 
# findasinglemissingnumber.pl
# Find the missing number in 1 to 1000 random digits.
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
#  perl hello.pl
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

my $numbersstr = &prompt("Enter a comma seperated list of numbers to find skipping a certain number ", "1,2,3,4,5,7");

say  "You entered: $numbersstr";

# Convert $numberstr into an array
my @numbers = split ',', $numbersstr;
say "numbers: @numbers";

# Formula n(n+1)/2 subtract from the sum where n list of numbers is {1,..,n}
# First get n which is the biggest value in the list (but not necessarily last if entered unsorted)
my $max = 0;
foreach my $i (@numbers) {
	$max=$i if $i >$max;
}
say "max n = $max";

# Get the sum:
my $sum = 0;
$sum += $_ for @numbers;
say "sum: $sum";

# Now do the formula:
my $total = $max*($max+1)/2;
say "total: $total";

my $missingnumber = $total - $sum;
say "missing number = $missingnumber";

#####################################################################################
# subroutine: prompt
# Purpose: take arguments if given from command line, else will use the default 345
##################################################################################### 
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

