package CPANHQ::Model::DB;

use strict;
use warnings;

use base qw( Catalyst::Model::DBIC::Schema );

__PACKAGE__->config(
    schema_class => 'CPANHQ::Storage'
);

1;
