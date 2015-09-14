#!/usr/bin/perl
############################################################################### 
# perlMap.pl
#   Playing around with map to find similarities and differences 
#  
# AUTHOR
#  Vernon O' Reilly
# DATE
#  13 Sept 2015
# VERSION
#  1.0
# PURPOSE
#  Enter purpose here
# USAGE
#  perl perlMap.pl
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

my $numbers  = &prompt("Enter a list of numbers seperated by a comma: ", "4,2,5,8,9");
my $numbers1 = &prompt("Enter another list of numbers seperated by a comma: ", "1,3,6,2,9");

say "The inputs were:";
say $numbers;
say $numbers1;

#First add the string into a proper array
my @numbers = split(",", $numbers);
my @numbers1 = split(",", $numbers1);

say "The input array is:";
say @numbers;
say @numbers1;

# create a hash with array elements as keys and 1 as value
my %numbers1 = map { $_=>1 } @numbers1;

# Now do the diff
my @diff = grep { !$numbers1{$_} } @numbers;
my @reps = grep { $numbers1{$_} } @numbers;

say "The differences are:";
say @diff;
say "The repeats are:";
say @reps;


######################################################################################
# subroutine: gcd
# Purpose: take arguments if given from command line, else will use the default 345
###################################################################################### 
sub compute {
  my ($n) = @_;
  say "n: $n";
  my @out;
  for (my $x = $n; $x > 0 ; $x--) {
	say "x: $x";
	say "out: @out";
      if ($x == $n) {
	$out[0] = $n;
      } else {
	push @out, $x;
	unshift @out, $x;
      } 
  }
  return @out;
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

