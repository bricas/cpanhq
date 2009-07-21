use strict;
use warnings;
use Test::More tests => 6;

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
            version => "0.08",
        }
    );

    # TEST
    ok ($rec1, "Record1 is OK.");

    my $meta_yml = $rec1->_get_meta_yml();

    # TEST
    ok ($meta_yml, "META.yml of Games-Solitaire-Verify is OK.");

    # TEST
    is ($meta_yml->{'abstract'}, "verify solutions for solitaire games.",
        "Abstract of META.yml is OK."
    );

    # TEST
    is ($meta_yml->{'license'}, "mit",
        "License of META.yml is OK."
    );

    $rec1->_process_meta_yml();

}

