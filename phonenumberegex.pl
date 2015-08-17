#!/usr/bin/perl
############################################################################### 
# phonenumberegex.pl
#  Write a regular expression for a phone number. (XXX-XXX-XXXX format) 
#  
# AUTHOR
#  Vernon O' Reilly
# DATE
#  17 Aug 2015
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

my $number = '1234567890';
my @dashes = ($number =~ /-/g);
say "dashes: @dashes";
my $amount = $#dashes + 1;
say "amount: $amount";
die ("No dashes found") if $amount < 1;

# Lets first check the amount dashes (-) in the number

if (grep /(\d{3})-(\d{3})-(\d{4})/, $number) {
	say "Found ddd-ddd-dddd";
} else {
	say "Pattern not in ddd-ddd-dddd format";
}

$number =~ /(\d+)-(\d+)-(\d+)/;
say "Numbers are $1 ", "$2 ", "$3";
