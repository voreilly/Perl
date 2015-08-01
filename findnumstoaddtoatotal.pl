#!/usr/bin/perl
############################################################################### 
# findnumstoaddtoatotal.pl
#  Write a function that takes an input array of integers and a desired target
#  sum. then returns combinations of any length to add up to that target_sum.
#  Include proper exception handling and test cases.
#  
# AUTHOR
#  Vernon O' Reilly
# DATE
#  1 August 2015
# VERSION
#  1.0
# PURPOSE
#  This is a script from an interview with the purpose to find my dream job 
# USAGE
#  perl findbigfiles.pl
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
use Memoize;


my $numbers = &prompt("Enter a list of numbers seperated by a comma: ", "1,2,3,4,5,6,7,8,9");
my $total = &prompt("Enter the total for which you want the numbers to add up to : ", "10");

say "The inputs were:";
say $numbers; 
say "You requested the total to be:";
say $total;

# make an array of the input numbers
my @nums = split(/,/, $numbers);
#say "Say: $#{$nums}";
my $amountofnumsentered = $#nums+1;
if ($amountofnumsentered < 1) {
 die( "there needs to be at least 2 input numbers, please run the program again");
}

say " ";

# answers will be printed to this array
my @answer;

# loop of the amount of numbers in order to find all combinations
foreach my $i (1 .. $amountofnumsentered) {
	my $add = &addup($i, $total, 0, [sort {$b <=> $a} @nums]);
}

say "Printing combination of numbers now that will give a total of $total : ";

# Make sure we only use unique numbers
my %seen = ();
my @unique = grep { ! $seen{ $_ }++ } @answer;

# Actually now print out the result
foreach my $ans (@unique) {
	say "$ans";
}

######################################################################################
# subroutine: addup
# Purpose: Recursively adds up all sums and push in into @answer array
###################################################################################### 
sub addup {
	my ($i,$val,$offset,$p,@set) = @_;
	if ($i == 1) {
		for ($offset..$#{$p}) {
		last if @$p[$_] < $val;
		push @answer, "@set $val";
		}
	}
	else {
		for ($offset..($#{$p}-$i+1)) {
			next if @$p[$_] > $val - $i + 1;
			last if @$p[$_] < int ($val / $i);
			addup($i-1, $val-@$p[$_], $_+1, $p, @set, @$p[$_]);
		}
	}
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

