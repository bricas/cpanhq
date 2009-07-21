#!/usr/bin/perl

use strict;
use warnings;

use Config::General;
use YAML::XS qw(LoadFile);

my $config = LoadFile("cpanhq.yml");

my $conf_g = Config::General->new("cpanhq.conf");

$conf_g->save_file("cpanhq.conf", $config);

