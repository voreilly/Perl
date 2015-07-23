#!/usr/bin/perl
#################################################################################################################
#                                                                                                               #
# Date: 2013-02-15                                                                                              #
# Author: Vernon O' Reilly                                                                                      #
# This script checks if all the tail processes are running that should run and if not, start them               #
#                                                                                                               #
##################################################################################################################

use strict;
use warnings;
use Data::Dumper;

my $file = '/home/logsaver/logmounts.sh';

# check number of current mount
my $current_mounts = 0;
$current_mounts = `mount|grep logsaver|grep -v '#'|grep -c fuse`;
chomp($current_mounts);
print "Number of current mounts: $current_mounts\n";

# check number of processes that should be running from the startup script
my $should_be_mounted = 0;

$should_be_mounted = `grep logsaver $file |grep -v '#'|grep -c logsaver`;
chomp($should_be_mounted);
print "Number of mounts that should be mounted: $should_be_mounted\n";

# Lets see if some processes are not running
if ($current_mounts < $should_be_mounted)
{
	my %currenthash;
	# Now we need to determine which servers are not mounted

	# First grab all the current mounts
	my @mntcommand = `mount|grep logsaver|grep -v '#'`;

	foreach my $mount (@mntcommand){
       		chomp $mount;
	       	print "Found mount: $mount\n";
		my @mountsplit = split(' on ', $mount);
		# Add hash entry
		$currenthash{$mountsplit[0]}=$mountsplit[1];

	}

	print Dumper(\%currenthash);

	my %hastohash;
	my @validentries;
	my %hashtostart;
	# Next grab the mounts that should be mounted
	open(my $data, '<', $file) or die "Could not open '$file' $!\n";

	while (my $line = <$data>) {
		chomp $line;
		#print "FILE: $line\n" if (($line !~ /#/) && ($line !~ /^$/) && ($line !~ /tailprog=/));
		if (($line !~ /#/) && ($line !~ /^$/)) {
			push(@validentries, $line);
			my @mountsplit = split(' ', $line);
			# Add hash entry
			$hastohash{$mountsplit[2]}=$mountsplit[3].' '.$mountsplit[4].' '.$mountsplit[5].' '.$mountsplit[6];
		}

	}
	
	print "%hastohash\n";
	print Dumper(\%hastohash);

	# Now determine which tail processes needs to be started
	for ( keys %hastohash) {
    		unless ( exists $currenthash{$_} ) {
        	print "$_: not found in currenthash\n";
		# start the mounts
		print "START: sshfs -C $_ $hastohash{$_} \n";
		my @mnt = `su - logsaver -c "sshfs -C $_ $hastohash{$_}"`;
        	next;
    		}
	}

}


