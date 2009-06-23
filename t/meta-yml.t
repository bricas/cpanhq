use strict;
use warnings;
use Test::More tests => 2;

use Catalyst::Test;
use CPANHQ;

use CPANHQ::Storage;

{
    my $schema1 = CPANHQ::Storage->connect(); # resultset('release');

    # TEST
    ok ($schema1, "Schema was initialized");

    my $releases_rs = $schema1->resultset('Release');

    # TEST
    ok ($releases_rs, "Releases result set is OK.");
}

