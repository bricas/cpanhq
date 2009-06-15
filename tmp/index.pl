#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use Path::Class::Dir;
use Path::Class::File;
use Parse::CPAN::Whois;
use Parse::CPAN::Packages;
use DateTime;
use File::Next;
use LWP::Simple;

require CPANHQ;

$|++;
my $cpan_base = shift;

die "USAGE: $0 /path/to/cpan/" unless $cpan_base;

$cpan_base = Path::Class::Dir->new( $cpan_base );

my $authors_xml_fn = $cpan_base->file( qw( authors 00whois.xml ) )->stringify;

print "Fetching Authors...\n";

if (! -e $authors_xml_fn)
{
    getstore("http://www.cpan.org/authors/00whois.xml", $authors_xml_fn);
}

print "Loading Authors...\n";

my $authors = Parse::CPAN::Whois->new( $authors_xml_fn );
my $author_rs = CPANHQ->model('DB::Author');

print "Loading Packages...\n";
my $packages = Parse::CPAN::Packages->new( $cpan_base->file( qw( modules 02packages.details.txt.gz ) )->stringify );
my $dist_rs = CPANHQ->model('DB::Distribution');
my $release_rs = CPANHQ->model('DB::Release');

my $file_it = File::Next::files( $cpan_base->subdir( qw( authors id ) ) );

print "Scanning Files...\n";
my $count = 0;
while ( defined ( my $file = $file_it->() ) ) {
    next if $file =~ m{/CHECKSUMS$};
    ( my $prefix = $file ) =~ s{^$cpan_base/}{};
    my $dist = $packages->distribution_from_prefix( $prefix );
    next unless $dist && defined $dist->version;

    $count++;
    printf "\r%-75s", join( ' ', $dist->dist, $dist->version ) . ' by ' . $dist->cpanid;

    # handle dist author
    my $author = $authors->author( $dist->cpanid );
    my $db_author = $author_rs->update_or_create( { cpanid => $author->pauseid, email => ($author->email || ""), name => $author->name, homepage => $author->homepage, }, { key => 'author_cpanid' } );

    # handle dist
    my $db_dist = $dist_rs->find_or_create( { name => $dist->dist }, { key => 'distribution_name' } );

    # handle release
    my $stat = Path::Class::File->new( $file )->stat;
    my $db_release = $release_rs->update_or_create( {
        distribution_id => $db_dist->id,
        version => $dist->version,
        author_id => $db_author->id,
        path => $dist->prefix,
        developer_release => ( $dist->maturity eq 'developer' ? 1 : 0 ),
        size => $stat->size,
        release_date => DateTime->from_epoch( epoch => $stat->mtime ),
    }, { key => 'release_distribution_id_version' } );
}

print "\n$count Releases Indexed\n";
