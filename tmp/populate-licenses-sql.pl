#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use Path::Class::Dir;
use Path::Class::File;
use Software::License;
use DateTime;
use File::Next;
use LWP::Simple;

require CPANHQ;

$|++;
my @licenses = 
(qw(
    Software::License::AGPL_3
    Software::License::Apache_1_1
    Software::License::Apache_2_0
    Software::License::Artistic_1_0
    Software::License::Artistic_2_0
    Software::License::BSD
    Software::License::FreeBSD
    Software::License::GFDL_1_2
    Software::License::GPL_1
    Software::License::GPL_2
    Software::License::GPL_3
    Software::License::LGPL_2_1
    Software::License::LGPL_3_0
    Software::License::MIT
    Software::License::Mozilla_1_0
    Software::License::Mozilla_1_1
    Software::License::OpenSSL
    Software::License::Perl_5
    Software::License::QPL_1_0
    Software::License::SSLeay
    Software::License::Sun
    Software::License::Zlib
));

my $license_rs = CPANHQ->model('DB::License');

LICENSES_LOOP:
foreach my $l (@licenses)
{
    eval "require $l";

    print "Inserting $l\n";

    if (!defined($l->meta_name()))
    {
        print "Skipping $l\n";
        next LICENSES_LOOP;
    }

    $license_rs->find_or_create({
        string_id => $l->meta_name(),
        name => $l->name(),
        url => $l->url(),
    });
}
