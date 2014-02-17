#!/usr/bin/perl
 
use strict;
use warnings;
use DBI;
 
##The above is the necessary "boiler plate": the shebang line + invocation of necessary modules
 
# create a variable and set its value to the number of arguments specified by the user
my $numargs = ($#ARGV + 1);
# make sure that value is exactly 1. If it is not, print an error message.
if ($numargs != 1) {
	print "\n\nSorry, you must specify one and only one filepath on the command line. \n\n";
	exit;
	}
 
my $db = $ARGV[0]; 
my $dsn = "DBI:mysql:$db"; #this establishes the data source name
my $user = "student";
my $password = "student99";
 
# the above four lines contain the credentials necessary to establish a database handle and connect to the database
 
#These next two lines establish the database handle and connect to the database
my $dbh = DBI -> connect($dsn, $user, $password)
	or die "Unable to connect to database.\n";
 
#This next statement saves the SQL query I will use to extract the data from the database
#I'm not sure why the instructions given for this part of the assignment suggest that we may need
#to use multiple queries to extract the required data. I believe this following single query is
#sufficient...perhaps I'm missing something, but I don't think so.
my $query = "select  distinct g.ID, GenomeID, ECNumber,fmax, fmin 
		from Genes as g 
		join Genomes as go on g.ID = go.GeneID 
		join GeneFunctions as gf on go.GeneID = gf.GeneID";
 
 
#This next statement will issue the query saved in the variable above
my $a_ref = $dbh -> selectall_arrayref($query)
	or die "Unable to extract data from the database\n"; #always check for success!
 
 
#Next line opens filehandle for the file to print results to
open (OUTPUTFILE, ">" , "/home/student02/finalproject/step3.tsv")
	or die "Can't open file for writing\n"; #Check for success!
 
print OUTPUTFILE "gene\tgenome\tec.num\tgene.length\n";  #This prints the header line
 
#This next foreach loop will derefrence the array reference returned by the previous statement 
#(actually the one before last) in such a way that I can access the individual elements easily
#This loop also serves to manipulate the data where necessary (subtract fmin from fmax to get 
#gene length, and it also truncates the ECnumber to two positions as required by the instructions.
 
 
 
foreach my $value (@$a_ref){
	my $Genelength = ($value->[3] - $value->[4]);
	my $ECNumber = $value->[2];
	my $truncatedEC = substr($ECNumber,0,4);
	print OUTPUTFILE "$value->[0] \t $value->[1] \t $truncatedEC \t $Genelength \n";
}
	
close OUTPUTFILE #Always remember to close the filehandle!
	or die "Can't close output file\n";
