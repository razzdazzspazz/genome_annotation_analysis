#!/usr/bin/perl
 
use strict;
use warnings;
use DBI;
 
##The above is the necessary "boiler plate": the shebang line + invocation of necessary modules
 
 
my $db = "gpls718project"; 
my $dsn = "DBI:mysql:$db"; #this establishes the data source name
my $user = "student";
my $password = "student99";
 
# the above four lines contain the credentials necessary to establish a database handle and connect to the databse
 
#These next two lines establish the database handle and connect to the database
my $dbh = DBI -> connect($dsn, $user, $password)
	or die "Unable to connect to database.\n";
 
 
##These next three lines are the "meat" of the script. As long as the required subroutines are already 
##written and invoked either explicitly in the script or as part of a module these are the only
## lines of code needed to make the script work properly
check_args($#ARGV+1);
parseandload($ARGV[0]);
parseandload($ARGV[1]);
 
##End of the script "meat"
 
#The next two lines disconnect from the database
$dbh -> disconnect()
	or die "Could not disconnect from database \n";
 
 
###These are the subroutines used in the meat of the script######
 
 
#This subroutine is used to check the number of arguments passed by the user
#The number of arguments must be passed to the subroutine as an argument in the "meat" hear we use $#ARGV+1
#which is equivalent to the number of arguments the user specified
sub check_args {
	my $numargs = shift; #access the passed argument
	if ($numargs != 2) { #check the value of the variable
	print "\n\nSorry, you must specify exactly 2 filepaths on the command line. \n\n"; #print error
	exit;
	}
}
###End of first subroutine
 
 
##This next subroutine can be used to parse a tab delimited annotation file and load it into a database 
## with three tables. Of course the tables need to be created according to a specific schema in order for 
## this subroutine to work, but it works just fine with the schema I have designed. It takes a filepath specified
## by the user on the command line ($ARGV[]). The subroutine is invoked twice in the "meat". Once for each filepath
 
sub parseandload {
 
my $filepath = shift; 		#access the specified filepath
open (FILE, "<", $filepath)		#open a filehandle
	or die "Opening one of the filehandles was not successful. Check filepaths. \n"; #check for success
 
#we must also check that the file actually contains data. If it does not, print an error message to the user.
my $filesize = -s $filepath;
	if ($filesize == 0){
		die "\n\nOne of your files does not contain data! \n\n"; 
	}
 
#This while loop will iterate over each line of the file specified
	while (<FILE>) {				
		chomp;  		#remove whitespace from end of line
		(my $GeneID, my $CommonName, my $GeneSymbol, 
		my $ECnumber, my $fmin, my $fmax, my $strand, my $TIGRroles) = split(/\t/); #split the line on each tab
		$CommonName =~ s/'//g;		#get rid of "'" marks in the common name (need to do this to load the data properly)
		if ($GeneID =~/internal locus/){    #this if statement is used to skip over the header lines
		}
		else{
			my @TIGRroles = split(',' , $TIGRroles); #Split the tiger roles which are separated by commas
					foreach my $value (@TIGRroles){
						$dbh -> do ("INSERT INTO GeneFunctions (GeneID, ECNumber, TIGRrole) 
								VALUES ('$GeneID', '$ECnumber', '$value')")
							or die "Could not load data into database.\n";
					} #the above foreach loop creates a row for every TIGRrole in the GeneFunctions table
					  #eah row also includes the GeneID and ECNumber fields
	
				#The rows in the Genes and Genomes table are created according to which
				#genome the data came from if it is e.coli each row will get a 1 in the
				#genomeID field, if it is from C. Trachomatis it will get a 2				
				if ($GeneID =~ /coli/){			
					$dbh -> do ("INSERT INTO Genes (ID, GenomeID, CommonName, GeneSymbol, fmin, fmax, strand) 
						VALUES ('$GeneID', 1, '$CommonName', '$GeneSymbol', $fmin, $fmax, $strand)" )
						or die "Could not load data into database.\n";
					$dbh -> do ("INSERT INTO Genomes (ID, GeneID, OrganismName) 
						VALUES (1, '$GeneID', 'E.coli')")
						or die "Could not load data into database.\n";
				}
				elsif ($GeneID =~ /trach/){
					$dbh -> do ("INSERT INTO Genes (ID, GenomeID, CommonName, GeneSymbol, fmin, fmax, strand) 
						VALUES ('$GeneID', 2, '$CommonName', '$GeneSymbol', $fmin, $fmax, $strand)" )
						or die "Could not load data into database.\n";
					$dbh -> do ("INSERT INTO Genomes (ID, GeneID, OrganismName) 
						VALUES (2, '$GeneID', 'C. trachomatis')")
						or die "Could not load data into database.\n";
				}
			}
	}
 
close FILE		#these lines close the file handle
	or die "Closing file handle failed!\n"; 
}
##End of second subroutine
__END__
 
Note that I have checked for success at every appropriate step in the script
