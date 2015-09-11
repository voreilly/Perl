#!/usr/bin/perl
############################################################################### 
# perlBubbleSort.pl
#  A simple perl bubble sort
#  
# AUTHOR
#  Vernon O' Reilly
# DATE
#  11 Sept 2015
# VERSION
#  1.0
# PURPOSE
#  Enter purpose here
# USAGE
#  perl perlBubbleSort.pl
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

my @sorted = bubblesort(@numbers);

say "The bubble sorted list is now:";
say @sorted;

say "Output in list string format is:";
my $sortedstr;
foreach my $i (@sorted) {
    $sortedstr = $sortedstr."$i,";
}
chop($sortedstr);
say $sortedstr;

######################################################################################
# subroutine: bubblesort
# Purpose: take arguments if given from command line, else will use the default 345
###################################################################################### 
sub bubblesort {
  my @nums = @_;
#  say "In bubblesort: @nums";
  my $tmp = 0;
#  say $#nums;
  for (my $pass = $#nums-1; $pass>0; $pass--) {
#    say "pass is now $pass";
#    say "nums is atm: @nums";
    foreach my $i (0..$pass) {
#	say "i is now $i";
        if ($nums[$i]>$nums[$i+1]) {
          $tmp = $nums[$i];
	  $nums[$i] = $nums[$i+1];
	  $nums[$i+1] = $tmp;
        }
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

