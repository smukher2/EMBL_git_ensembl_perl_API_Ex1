#!/usr/bin/perl

#ref: simple perl script https://www.geeksforgeeks.org/hello-world-program-in-perl/
#ref: making simple script executable i.e. able to run on Terminal https://cets.seas.upenn.edu/answers/chmod.html
#ref: print statements https://www.codesdope.com/perl-more-print/

##########################Step 1: Check Code Is Running###########################
#When hello statement below prints we know script has started working
print("Hello EMBL\n");

#####################Step 2: Get Modules Needed For This Script ##################
#this step gets modules we need to use for this script to run
use Bio::EnsEMBL::Registry;
use Data::Dumper;

###############Step 3: Create Registry Item i.e. Connect To Ensembl###############
#this step does setup of resistry variable so script accesses ensembl database
#ref: http://mart.ensembl.org/info/docs/api/general_instructions.html#connectin
my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org', # alternatively 'useastdb.ensembl.org'
    -user => 'anonymous'
);

###############Step 4: Prepare Genomic Region Of Interest (Input or Query)########
#now we use ensembl perl api functions to get different information for our
#input genome latest (GRCh38 default) region of interest
#get a slice adaptor for the human core database
my $slice_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Slice' );

#Obtain a slice covering the region from 1MB to 2MB (inclusively) of
#chromosome 20 25000 to 30000
$slice = $slice_adaptor->fetch_by_region('chromosome', '10', 25000, 30000);

#Print statement to output results method 1
#ref: http://mart.ensembl.org/info/docs/api/general_instructions.html#connectin
print "$slice\n"; #this outputs a hash object so we use Dumper
#Set the Dumper settings to show only one level and use indents on the hash
$Data::Dumper::Maxdepth=1;
$Data::Dumper::Indent=3;
warn Dumper($slice); # print the hash object using Dumper

############Step 5: Do Something With Genomic Region Of Interest (Output or Result)###############
#convert $slice to output genome of interest GRCh37
#obtain coordinates in GRCh37 using the old version's slice
my @output_slice = $slice->project('chromosome', 'GRCh37');

#Print statement to output results method 1
#ref: http://mart.ensembl.org/info/docs/api/general_instructions.html#connectin
print "$output_slice\n"; #this outputs a hash object so we split it to print

#Print hash object by spliting into seperate items method 2
#ref: https://www.perl.com/article/perl-foreach-loops/
foreach my $i (@{$slice->project('chromosome', 'GRCh37')}){
  $i = $i->to_Slice();
  $i = $i->name();
  print "$i\n";}

#Done
