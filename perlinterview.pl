#!/usr/bin/perl
############################################################################### 
# perlinterview.pl
#  write a simple script in a scripting language of your choice that prints the numbers from 1 to 100 on a new line. 
#  But for multiples of three print "AMultipleOfThree" instead of the number and for the multiples of five print "AMultipleOfFive". 
#  For numbers which are multiples of both three and five print "BothThreeAndFive". You have 30 minutes to complete the task.
#  
# AUTHOR
#  Vernon O' Reilly
# DATE
#  28 July 2015
# VERSION
#  1.0
# PURPOSE
#  Enter purpose here
# USAGE
#  perl perlinterview.pl
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

my @div3;
my $x = 0;
for my $i (0 .. 121) {
	$x = $x+3;
	push @div3, $x if $x < 121;
}

my @div5;
$x=0;
for my $i (0 .. 121) {
	$x = $x+5;
	push @div5, $x if $x < 121;
}

#say @div3;
#say @div5;
#say $#div3;
#say $#div5;

my $i = 0;
my $three = 0;
my $five = 0;
$x = 0;
my $y = 0;
foreach  $i (0 .. 100) {
        #say "$i $x $y";
	$three = $div3[$x];
	$five = $div5[$y];
	#say "$i $three $five";
	if (($i == $three) && ($i != $five)) {
 		say "Three";
		$x++;
	}
	elsif (($i == $five) && ($i !=$three)) {
		say "Five";
		$y++;
	}
	elsif (($i == $three) && ($i == $five)){
		say "ThreeAndFive";
		$x++;
		$y++;
	}
	elsif (($i != $three) && ($i != $five)) {
		say $i;
	}
}
