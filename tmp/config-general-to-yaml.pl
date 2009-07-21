#!/usr/bin/perl

use strict;
use warnings;

use Config::General;
use YAML::XS qw(DumpFile);

my $conf = Config::General->new("cpanhq.conf");

my %config = $conf->getall();

DumpFile("cpanhq.yml", \%config);
