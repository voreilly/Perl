#!/usr/bin/perl
############################################################################### 
# findclosestorigins.pl
# Given a stream of data containing N points that is too large to fit into memory,
# find the closest K points to the origin in a 2D plane. Assume K is much smaller
# than N and N is very large.  You need to use only standard math operations
# (addition,subtraction,multiplication and division). Explain why you chose the
# language that you wrote it in and write the code as if it were to be used by
# other developers
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
#  On a linux server, create a text file called data.txt in the same directory
#  with one pint x,y example 3,5 per line to simulate input stream points
#  perl findclosesttorigins.pl or ./findclosestorigins.pl and then answer
#  the question of how many K points to keep
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

say "Given a stream of data containing N points that is too large to fit into memory,";
say "find the closest K points to the origin in a 2D plane. Assume K is much smaller";
say "than N and N is very large.  You need to use only standard math operations";
say "(addition,subtraction,multiplication and division).";
say "";

my $knumber = &prompt("Enter an amount for K to find the closest points: ", "3");

say "You requested the to find the following amount of points closest to the origin (0,0):";
if (&isint($knumber)) {
	say "$knumber";
} else { die ("ERROR: Please rerun and enter only an integer") };
say "";

# use a file that will be read line by line to simulate a stream
my $inputstreamfile = './data.txt';
open(my $fh, '<encoding(UTF-8)', $inputstreamfile)
 or die "Could not open file '$inputstreamfile' $!";

# hash containing closest points
my %points;
my $pointsize = 0;

# now loop through the file line by line
while (my $row = <$fh>) {
	chomp $row;
	my $distance = &finddistance($row);
	say "new point came in from file stream: $row";
	keys %points;
	my $pointsize = keys %points;
	my ($maxpoint,$maxpointval) = each %points if defined %points;
	# find the current maximum point and its key value
	while (my ($key, $val) = each %points) {
		if ($val > $maxpointval) {
			$maxpointval = $val;
			$maxpoint = $key;
		}
	}
	# in the beginning of the stream populate the hash until we have knumber
	# as those would be the closest
	if ($pointsize < $knumber) {
		$points{$row} = $distance;
	}
	else {
	# now we have more points than knumber and we need to sort the closest
		if ($distance < $maxpointval) {
			# we found a closer point
			# first delete the most distant one of the closest points
			delete $points{$maxpoint};
			# then add the new closer point so as to keep within kpoints
			$points{$row} = $distance;
		}
	}
	# For the stream always print the closest points that was found
	say "Current closest points to origin: ";
	print "point: $_, distance: $points{$_}\n" for (keys %points);
}

######################################################################################
# subroutine: isint
# Purpose: Test if a given input is an integer
###################################################################################### 
sub isint {
 	my $val = shift;
	return ($val =~ m/^\d+$/);
}

######################################################################################
# subroutine: finddistance
# Purpose: Finds distance from origin using Pythagoras
###################################################################################### 
sub finddistance {
	my ($z) = @_;
	# split the x and y coordinates
	my @coordinates = split(/,/, $z);
	# use Pythagoras theorem without the doing the square root to determine
	# the distance
	return $coordinates[0]*$coordinates[0]+$coordinates[1]*$coordinates[1];

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

