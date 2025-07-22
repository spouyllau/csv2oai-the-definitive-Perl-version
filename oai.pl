#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use POSIX qw(strftime);

###########################################
## Author : Stéphane Pouyllau            ##
## Date : 2025, July 18th                ##
## Contact : stephane.pouyllau@gmail.com ##
###########################################

print header(-type => 'text/xml', -charset => 'utf-8');

my $csv_file = 'data.csv';
my $batch_size = 10;
my @records = load_records($csv_file);

my $q = CGI->new;
my $verb = $q->param('verb') || '';
my $identifier = $q->param('identifier');
my $metadataPrefix = $q->param('metadataPrefix');
my $resumptionToken = $q->param('resumptionToken');
my $set = $q->param('set');

#my $baseURL = $q->url(-absolute => 1);
my $baseURL = 'https://www.stephanepouyllau.org/oai-perl/oai.pl';
my $date = strftime("%Y-%m-%dT%H:%M:%SZ", gmtime);

# Partie commune aux réponses XML du serveur OAI
print "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
print "<OAI-PMH xmlns=\"http://www.openarchives.org/OAI/2.0/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.openarchives.org/OAI/2.0/
         http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd\">\n";
print "  <responseDate>$date</responseDate>\n";
if ($verb eq 'Identify' || $verb eq 'ListMetadataFormats' || $verb eq 'ListSets') {
    print "  <request verb=\"$verb\">$baseURL</request>\n";
} else {
    print "  <request verb=\"$verb\" metadataPrefix=\"$metadataPrefix\">$baseURL</request>\n";
}

# À adapter
if ($verb eq 'Identify') {
    print <<"IDENTIFY";
  <Identify>
    <repositoryName>Perl OAI Repository for CSV file</repositoryName>
    <baseURL>$baseURL</baseURL>
    <protocolVersion>2.0</protocolVersion>
    <adminEmail>admin\@example.com</adminEmail>
    <earliestDatestamp>1700-01-01</earliestDatestamp>
    <deletedRecord>no</deletedRecord>
    <granularity>YYYY-MM-DD</granularity>
  </Identify>
IDENTIFY

} elsif ($verb eq 'ListMetadataFormats') {
    print <<"FORMATS";
  <ListMetadataFormats>
    <metadataFormat>
      <metadataPrefix>oai_dc</metadataPrefix>
      <schema>http://www.openarchives.org/OAI/2.0/oai_dc.xsd</schema>
      <metadataNamespace>http://www.openarchives.org/OAI/2.0/oai_dc/</metadataNamespace>
    </metadataFormat>
  </ListMetadataFormats>
FORMATS

# ListIdentifiers
} elsif ($verb eq 'ListIdentifiers') {
    my $offset = $resumptionToken || 0;
    my @filtered = defined($set) ? grep { $_->{set} eq $set } @records : @records;
    my @chunk = splice(@filtered, $offset, $batch_size);
    
    print "  <$verb>\n";
    foreach my $r (@chunk) {
        print_identifiers($r, $verb eq 'ListIdentifiers');
    }
    if ($offset + $batch_size < @filtered) {
        print "    <resumptionToken>" . ($offset + $batch_size) . "</resumptionToken>\n";
    }
    print "  </$verb>\n";

# ListRecords
} elsif ($verb eq 'ListRecords') {
    my $offset = $resumptionToken || 0;
    my @filtered = defined($set) ? grep { $_->{set} eq $set } @records : @records;
    my @chunk = splice(@filtered, $offset, $batch_size);
    
    print "  <$verb>\n";
    foreach my $r (@chunk) {
        print_record($r, $verb eq 'ListRecords');
    }
    if ($offset + $batch_size < @filtered) {
        print "    <resumptionToken>" . ($offset + $batch_size) . "</resumptionToken>\n";
    }
    print "  </$verb>\n";

#GetRecord
} elsif ($verb eq 'GetRecord') {
    if ($identifier) {
        my ($record) = grep { $_->{identifier_oai} eq $identifier } @records;
        if ($record) {
            print "  <GetRecord>\n";
            print_record($record, 1);
            print "  </GetRecord>\n";
        }
    }

#ListSets
} elsif ($verb eq 'ListSets') {
    my %sets;
    $sets{$_->{set}}++ for grep { $_->{set} } @records;
    print "  <ListSets>\n";
    for my $s (sort keys %sets) {
        print "    <set><setSpec>$s</setSpec>\n<setName>$s</setName></set>\n";
    }
    print "  </ListSets>\n";

} else {
    print "  <error code=\"badVerb\">Verbe non reconnu</error>\n";
}

print "</OAI-PMH>\n";

# Load records from CSV file (first row is header, delimiter is ;)
sub load_records {
    my ($file) = @_;
    open my $fh, '<', $file or return ();
    my $header = <$fh>;
    chomp $header;
    my @fields = split /;/, $header;
    my @records;
    while (<$fh>) {
        chomp;
        my @values = split /;/;
        my %r;
        @r{@fields} = @values;
        push @records, \%r;
    }
    close $fh;
    return @records;
}

# For ListIdentifiers
# Print header and metadata (if $full = true)
sub print_identifiers {
    my ($r, $full) = @_;
    #print "    <record>\n";
    print "      <header>\n";
    print "        <identifier>$r->{identifier_oai}</identifier>\n";
    print "        <datestamp>$r->{date}</datestamp>\n";
    print "        <setSpec>$r->{set}</setSpec>\n" if $r->{set};
    print "      </header>\n";
    #print "    </record>\n";
}

#For ListRecords
# Print header and metadata (if $full = true)
sub print_record {
    my ($r, $full) = @_;
    print "    <record>\n";
    print "      <header>\n";
    print "        <identifier>$r->{identifier_oai}</identifier>\n";
    print "        <datestamp>$r->{date}</datestamp>\n";
    print "        <setSpec>$r->{set}</setSpec>\n" if $r->{set};
    print "      </header>\n";
    if ($full) {
        print <<"XML";
      <metadata>
        <oai_dc:dc xmlns:oai_dc=\"http://www.openarchives.org/OAI/2.0/oai_dc/\"
                   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"
                   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
                   xsi:schemaLocation=\"http://www.openarchives.org/OAI/2.0/oai_dc/
                   http://www.openarchives.org/OAI/2.0/oai_dc.xsd\">
XML
        for my $field (qw/title identifier creator subject description publisher contributor date type format source language relation coverage rights/) {
            print "          <dc:$field>$r->{$field}</dc:$field>\n" if $r->{$field};
        }
        print "        </oai_dc:dc>\n      </metadata>\n";
    }
    print "    </record>\n";
}