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

#print "hello\n";
my $file = '/home/logsaver/tailfiles_localhost.sh';
my $user = 'logsaver';

# check number of processes currently running
my $current_running_procs = 0;
$current_running_procs = `ps -ef|grep $user |grep tail|grep -v grep|grep -v check_tail_process|grep -c tail`;
chomp($current_running_procs);
print "Number of tail processes currently running: $current_running_procs\n";

# check number of processes that should be running from the startup script
my $should_be_running_procs = 0;
#my @tailstartfile = `grep logs tailfiles_localhost.sh |grep -v '#'|grep -c tailprog`;

$should_be_running_procs = `grep logs $file |grep -v '#'|grep -c tail`;
chomp($should_be_running_procs);
print "Number of tail processes that should be running: $should_be_running_procs\n";

# Lets see if some processes are not running
if ($current_running_procs < $should_be_running_procs)
{
	my %currenthash;
	# Now we need to determine which tail process or processes are not running

	# First grab all the current running processes
	#my @pscommand = `ps -ef|grep logsaver|grep tail|grep -v grep|grep -v check_tail_process`;
	my @pscommand = `ps -o cmd -C tail --no-headers`;

	foreach my $process (@pscommand){
       		chomp $process;
	       	print "Found process: $process\n";
		my @processplit = split('-F', $process);
		# Add hash entry
		$currenthash{$processplit[1]}=$processplit[0];
		#print "@processplit\n";
		#print "$currenthash{}\n";

	}

	print Dumper(\%currenthash);

	my %hastohash;
	my @validentries;
	my %hashtostart;
	# Next grab the processes that should be running
	open(my $data, '<', $file) or die "Could not open '$file' $!\n";

	while (my $line = <$data>) {
		chomp $line;
		#print "FILE: $line\n" if (($line !~ /#/) && ($line !~ /^$/) && ($line !~ /tailprog=/));
		if (($line !~ /#/) && ($line !~ /^$/) && ($line !~ /tailprog=/)) {
			push(@validentries, $line);
			my @processplit = split('-F', $line);
			# Before we modify the keys to be the same in the 2 hashes, copy the old value to use for later when we need to start a tail process
			my $tempvar = $processplit[1];
			# Modify key
			$processplit[1] =~ s/ >> (.*)//;
			$hashtostart{$processplit[1]}=$tempvar;
			#print "key: $key\n";
			# Add hash entry
			$hastohash{$processplit[1]}=$processplit[0];
		}

	}
	
	print "%hastohash\n";
	print Dumper(\%hastohash);
	print "%hashtostart\n";
	print Dumper(\%hashtostart);

	# Now determine which tail processes needs to be started
	for ( keys %hastohash) {
    		unless ( exists $currenthash{$_} ) {
        	print "$_: not found in currenthash\n";
		# start the tail process
		print "START: /usr/bin/tail -F $hashtostart{$_}\n";
		my @start = `su - $user -c "/usr/bin/tail -F $hashtostart{$_}"`;
        	next;
    		}
	}

}


