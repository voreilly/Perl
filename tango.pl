#!/usr/bin/perl

# +----------------------------------------------------------------+
# | FILE         : tango.pl                                	   |
# | AUTHOR       : Vernon O' Reilly				   |
# | PURPOSE      : This script is to demonstrate perl skills	   |
# | OUTPUT FILES : NONE                                            |
# +----------------------------------------------------------------+

# I have put together a task for you.
#
# DATABASE
#
# 1. Create a table with 1 column called phone_numbers which will be used to store 9 digit unique phone numbers.
#
# Example data 99626210
#
# 2. What additional steps would you perform to allow scripts to perform insert, select and delete operations on the table? Are there ay other good practices you would follow?
# ->grant select, insert, delete on test_dbi to username;
# It is usually good practice to use transactions and to rollback upon an error and also create indexes to speed up queries. 
#
# PERL
#
# 1. Users tend to enter phone numbers with leading 0’s, leading and trailing spaces. How would you correct such user input in perl?
#
# $ph_num = “ 09 962 6210 ”
#
# 2. Please create a perl script that will read numbers present in the above created table and print out a range.
#
# For example, if the table had the following data:
#
# 38416210, 99626210, 99626211, 99626212, 99620010
#
# The desired output will be:
#
# 38416210
# 99626210, 99626211, 99626212
# 99620010
#
# Please reply back with all code you created to do the above tasks.

use strict;
use warnings;

require "ctime.pl";
require "flush.pl";

use DBI;

# Insert your credentials below manually
my $ORACLE_SID = "";
my $ORACLE_USERID = "";
my $ORACLE_PASSWORD = ""; 

my %combine_hash;
&declareVariables;

&printHeader;

my $dbh = &getOracleLogin("$ORACLE_SID", "$ORACLE_USERID", "$ORACLE_PASSWORD");
$dbh->{LongReadLen} = 64000;

&performTest;

&logoffOracle($dbh);

&printFooter;

exit;

# +--------------+
# | SUB ROUTINES |
# +--------------+
sub declareVariables {

  $ORACLE_SID              = "ORACLESID";
  $ORACLE_USERID           = "userid";
  $ORACLE_PASSWORD         = "passwd";

  $ENV{'ORACLE_SID'}       = "$ORACLE_SID";
  $ENV{'ORACLE_HOME'}      = "/u01/app/oracle/product/10.2.0/db_1";

}

sub printHeader {

  print "\n";
  print "Running tango.pl...\n";
  print "\n";

}

sub printFooter {

  print "Ending tango.pl...\n";
  print "\n";

}

sub getOracleLogin {

  my ($oracle_sid, $username, $password) = @_;
  my $temp_dbh;

  print "  (*) Attempting Oracle Login ...\n";


  unless ( $temp_dbh = DBI->connect(  "DBI:Oracle:$oracle_sid"
                                    , "$username"
                                    , $password
                                    , {AutoCommit => 0}) ) {
    &programError(   "Oracle Login Failed as $username"
                   , ""
                   , "$DBI::errstr"
                   , "dba-mail"
                   , "dba-pager");
    exit;
  }

  print "      OK\n\n";

  return $temp_dbh;

}

sub logoffOracle {

  ($dbh) = @_;

  print "  (*) Attempting Oracle Logoff ...\n";

  unless ($dbh->disconnect) {

    1;
  }

  print "      OK\n\n";

}

sub performTest {

  my $rows1;
  my @tempdata;
  my $combine_level = 5;

  # +-----------------------+
  # | CREATE TABLE test_dbi |
  # +-----------------------+

  print "  (*) Creating table TEST_DBI ...\n";

  my $sql_statement = "
    CREATE TABLE test_dbi (
      phone_numbers       VARCHAR2(9) not null,
      CONSTRAINT phonenumbers_unique UNIQUE (phone_numbers)
    )
  ";
  unless ($rows1 = $dbh->do("$sql_statement")) {
    &programError(   "Could not create table TEST_DBI"
                   , "$sql_statement"
                   , "$DBI::errstr"
                   , "dba-mail"
                   , "dba-pager");
    $dbh->rollback;
    &logoffOracle($dbh);
    exit;
  }

  print "      OK\n\n";

  # +----------------------------+
  # | INSERT INTO TABLE test_dbi |
  # +----------------------------+

  print "  (*) Insert into TEST_DBI ...\n";

  my @data = ("38416210", "09 962 6210", "99626211", "99626212", "99620010");

  foreach my $numberdata (@data) {

	# Check and correct leading zeros and spaces
	$numberdata =~ s/^0//;
	$numberdata =~ s/\s//g;

      my $sql_statement = "
        INSERT INTO test_dbi (
            phone_numbers
        ) VALUES (
          '$numberdata'
        ) 
      ";
      print "SQL used: $sql_statement\n";
    
      unless ($rows1 = $dbh->do("$sql_statement")) {
        &programError(   "Could not do INSERT_TEST_DBI"
                       , "$sql_statement"
                       , "$DBI::errstr"
                       , "dba-mail"
                       , "dba-pager");
        $dbh->rollback;
        &logoffOracle($dbh);
        exit;
      }
    
      print "      $rows1 rows inserted.\n";
  }

  print "      OK\n\n";

  # +----------------------------+
  # | SELECT FROM TABLE test_dbi |
  # +----------------------------+

  print "  (*) Select from TEST_DBI ...\n";

  $sql_statement = "
    SELECT
        phone_numbers
    FROM
        test_dbi
  ";

  unless ($rows1 = $dbh->prepare("$sql_statement")) {
    &programError(   "Could not prepare SELECT_TEST_DBI"
                   , "$sql_statement"
                   , "$DBI::errstr"
                   , "dba-mail"
                   , "dba-pager");
    $dbh->rollback;
    &logoffOracle($dbh);
    exit;
  }

  unless ($rows1->execute) {
   &programError(   "Could not execute SELECT_TEST_DBI"
                  , "$sql_statement"
                  , "$DBI::errstr"
                  , "dba-mail"
                  , "dba-pager");
   $dbh->rollback;
   &logoffOracle($dbh);
   exit;
  }


  while ( my ($test_dbi_phonenumber) = $rows1->fetchrow_array) {

    print "\n";
    print "TEST_DBI_PHONE_NUMBER :  $test_dbi_phonenumber\n";
    print "\n";

    # Add the numbers to a temporary hash for sorting later
    push(@tempdata, $test_dbi_phonenumber);

  }

  unless ($rows1->finish) {
   &programError(   "Could not finish SELECT_TEST_DBI"
                  , "$sql_statement"
                  , "$DBI::errstr"
                  , "dba-mail"
                  , "dba-pager");
   $dbh->rollback;
   &logoffOracle($dbh);
   exit;
  }

  ########################################################################
  # Sort and print the data as requested				 #
  ########################################################################
  foreach my $number (@tempdata) {
          my $num = substr($number,0,$combine_level);
          $combine_hash{$num} .= "$number," if $number =~ /$num/;
  }
  
  foreach my $key (%combine_hash) {
	  # take of trailing ,
          chop($combine_hash{$key}) if exists $combine_hash{$key};
          print "$combine_hash{$key}\n" if exists $combine_hash{$key};
  }
  
  print "\nNUMBERS IN ASCENDING NUMERIC ORDER:\n";
  foreach my $key (sort hashValueAscendingNum (keys(%combine_hash))) {
     print "$combine_hash{$key}\n" if exists $combine_hash{$key};
  }

  print "OK\n\n";

}


sub programError {

  my ($message, $sql_statement, $ora_errstr, $email_who, $page_who) = @_;

  print "+--------------------------+\n";
  print "| SUB: programError        |\n";
  print "+--------------------------+\n";
  print "\n";

  unless($message) {$message = "No message provided from calling module.";}

  print "+-------------------------------------------------------+\n";
  print "| ******************* PROGRAM ERROR ******************* |\n";
  print "+-------------------------------------------------------+\n";
  print "\n";
  print "\n";
  print "Message:\n";
  print "--------------------------------------------------------\n";
  print "$message\n";
  print "\n";
  if ($sql_statement) {
    print "SQL:\n";
    print "--------------------------------------------------------\n";
    print "$sql_statement\n";
    print "\n";
  }

  if ($ora_errstr) {
    print "Oracle Error:\n";
    print "--------------------------------------------------------\n";
    print "$ora_errstr\n";
  }


}

sub hashValueDescendingNum {
   int($combine_hash{$b}) <=> int($combine_hash{$a});
}
sub hashValueAscendingNum {
   int($combine_hash{$a}) <=> int($combine_hash{$b});
}

