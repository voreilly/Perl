#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
use Data::Dumper;

# Open the word dictionary
my $file = '/usr/share/dict/american-english'; #could be different for a different linux distro
open (my $fh, '<:encoding(UTF8)', $file) or die "Can't open word file '$file' $!";
# Remove newline characters
# read file line by line and add each word in the dictionary as a hash key for fast find 
# although this uses alot of memory the dictionary file is only 1Mb so not too big to fit into mem
my %allwords;
while (<$fh>) {
    chomp($_);
    $allwords{$_} = 1;
}

my $word = &prompt("Enter a single word: ", "mates");

if (exists $allwords{$word}) {
 say "Valid word was entered";
} else {
 say "Invalid word";
}

# Lets look at this another way
# first find only the words that are the same length as your input
my @word = split (//, $word);
say "Entered:";
say @word;
#say "len: ".length $word;

my %samelenwords;
foreach my $key (keys %allwords) {
  $samelenwords{$key}=1 if (length $key == length $word);
}

# Check for duplicate characters in the word
my $cntr = 1;
my %duplicates;
my $last;
for my $entry (@word) {
  $last = grep { $entry eq $_ } @word;
  $duplicates{$entry}++ if $last > 1;
}
#say Dumper(%duplicates);

my @duplicate;
foreach my $key (keys %duplicates) {
 push @duplicate, $key;
} 
#say "duplicate characters";
#say Dumper(@duplicate);

my $posstr;
my $amountofdups=$#duplicate+1;

my %possiblewords;
if (scalar keys %duplicates > 0) {
  foreach my $key (keys %samelenwords) {
    my @try = split (//, $key);
    my $lst=0;
    foreach my $dup (@duplicate) {
	my $numberofdups = grep { $dup eq $_ } @try;      
 	$lst++ if $numberofdups == $duplicates{$dup};
    } 
    $possiblewords{$key}=1 if $lst == $#duplicate+1;
  }
} else {
 %possiblewords = %samelenwords;
}
#say "Possible words:";
#say Dumper(%possiblewords);

my $ifstr;
foreach my $i (0..$#word) {
 $ifstr .= '($key =~ m/$word['.$i.']/) && ';
}
chop($ifstr);
chop($ifstr);
chop($ifstr);
my @results;
foreach my $key (keys %possiblewords) {
  if ( eval($ifstr) ) {
	unshift  @results, $key;
  }
}
#say "ifstr: ".$ifstr;
say "result: @results";
say "end";

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

