use strict;
use warnings;
use Test::More tests => 3;

use Catalyst::Test 'CPANHQ';

use CPANHQ::Storage;

{
    my $schema1 = CPANHQ->model("DB");

    # TEST
    ok ($schema1, "Schema was initialized");

    my $releases_rs = $schema1->resultset('Release');

    # TEST
    ok ($releases_rs, "Releases result set is OK.");

    my $rec1 = $releases_rs->find({
            distribution_id => 
                $schema1->resultset('Distribution')->find(
                    {
                        name => "Games-Solitaire-Verify",
                    }
                )->id(),
            version => "0.07",
        }
    );

    # TEST
    ok ($rec1, "Record1 is OK.");
}

