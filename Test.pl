#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use Text::CSV;

my $driver= "mysql"; 
my $database= "mydb";
my $host= "localhost"
my $dbport= "3306";
my $userid= "user";
my $password= "password";
my $dsn= "DBI:$driver:database=$database;host=$host;port=$dbport";
my $csv = "test.csv";

my $dbh = DBI->connect($dsn, $userid, $password) or die "Could not connect to database! $DBI::errstr"; // connecting with DB

my $sth1 = $dbh->prepare(qq{INSERT INTO employee(firstname,lastname,age,created_on,comments) VALUES (?, ?, ?, ?, ?)}); // preparing insert commands for reuse
my $sth2 = $dbh->prepare(qq{INSERT INTO phone(person_id,phone_number) VALUES (?, ?)})

open (my INPUT, '<', $csv) or die "Couldn't open csvfile: $!"; // opening csv file
<INPUT>; //ignoring 1st line
while (my $line = <INPUT>) 
{
  chomp $line; // remove newline
  my @newArr = split(',',$line); //splitting the file
  my $comment= substr($newArr[0],1,2); // taking one substring from name to add as comment
  push(@newArr, $comment);  // pushing the comment into the array
  $sth1->execute($newArr[0],$newArr[1],$newArr[2],curdate(),$newArr[4]); //executing 1st insert command
  $sth2->execute(last_insert_id(),$newArr[3]); //executing 2nd insert command
}

$sth1->finish();
$sth2->finish();
$dbh->commit();
$dbh->disconnect();
