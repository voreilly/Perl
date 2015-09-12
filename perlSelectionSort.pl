#!/usr/bin/perl
############################################################################### 
# perlSelectionSort.pl
#  A simple perl Selection sort
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
#  perl perlSelectionSort.pl
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

my $numbers = &prompt("Enter a list of unsorted numbers seperated by a comma: ", "3,6,1,2,6,9,8");

say "The inputs were:";
say $numbers;

#First add the string into a proper array
my @numbers = split(",", $numbers);

say "The input array is:";
say @numbers;

my @sorted = selectionsort(@numbers);

say "The selection sorted list is now:";
say @sorted;

say "Output in list string format is:";
my $sortedstr;
foreach my $i (@sorted) {
    $sortedstr = $sortedstr."$i,";
}
chop($sortedstr);
say $sortedstr;

######################################################################################
# subroutine: selectionsort
# Purpose: take arguments if given from command line, else will use the default 345
###################################################################################### 
sub selectionsort {
  my @nums = @_;
#  say "In selectionsort: @nums";
  my $i = 0; # Starting index of a minimum-finding scan 
  my $j = 0; # Current index of a minimum finding scan

  my $min=0;
  for (my $i = 0; $i <= $#nums; $i++) {
    $min = $nums[$i];
#    say "min: $min";
#    say "i: $i";   
#    say "numsi: @nums";
    for (my $j = $i; $j <= $#nums; $j++) { #loop search for smallest number, loop gets smaller each turn outer loop is run
#	say "j: $j";
	if ($nums[$j] < $nums[$i]) {
		# swap
		my $tmp = $nums[$i];
	 	$nums[$i] = $nums[$j];
		$nums[$j] = $tmp;
	} 
#        say "numsj: @nums";
    } 
  }
#  say "Before returning: @nums";
  return @nums;
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

