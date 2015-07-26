#!/usr/bin/perl
############################################################################### 
# magic.pl
#  Does some math magic.
#  
# AUTHOR
#  Vernon O' Reilly
# DATE
#  27 July 2015
# VERSION
#  1.0
# PURPOSE
#  Enter purpose here
# USAGE
#  perl magic.pl - If unique numbers were chosen the answer should usually be 1089 95% of the time,
#  but to be safe keep the number 1099 also handy and an answer about 5% of the time :-)
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

my $randomnumber = &prompt("Enter any random unique 3 digit number ", 345);

say  "You entered: $randomnumber";

say "Now to make things random lets reverse your chosen number so that $randomnumber becomes:";

my $revminus = reverse $randomnumber;

say $revminus;

my $subtr = 0;
if ($revminus > $randomnumber) {
   say "Lets subtract the two numbers: $revminus - $randomnumber";
   $subtr = $revminus - $randomnumber;
} else {
   say "Lets subtract the two numbers: $revminus - $randomnumber";
   $subtr = $randomnumber - $revminus;
}

say "The new number is: $subtr";

my $revplus = reverse $subtr;

say "Finally lets add this subtraction to its reverse: $subtr + $revplus";

my $answer = $subtr + $revplus;

say "Is this the number I have? $answer";

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
