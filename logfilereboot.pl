#!/usr/bin/perl
############################################################################### 
# logfilereboot.pl
#  If there is this one line xxx in the log file, then you have to reboot the server.
#  How would you write a script for that? What if you have 100 servers?
#  What if you only need to reboot if the host had not been rebooted in the last 24 hrs?
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

my $file = "/var/log/dracut.log";
my $string1 = "checksum";

open my $fh, '<', $file or die "Could not open $file: $!";

my @lines = sort grep /\Q$string1/, <$fh>;

# instead of reboot here we just print that we found the string, we could use `reboot`
say $#lines;
say "Found $string1" if $#lines > 0;
#`reboot` if $#lines > 0;

my $uptimestr = `uptime`;
chomp($uptimestr);

f ($#lines > 0) {
	say "$string1 found";
	if (grep /day/, $uptimestr) {
		say "$uptimestr for more than a day"
	} else {
		say "$uptimestr for less than a day"
	}
} else {
	say "$string1 not found";
	if (grep /day/, $uptimestr) {
		say "$uptimestr for more than a day"
	} else {
		say "$uptimestr for less than a day"
	}
}
