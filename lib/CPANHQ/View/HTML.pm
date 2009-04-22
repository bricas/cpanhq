package CPANHQ::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(TEMPLATE_EXTENSION => '.tt', WRAPPER => 'wrapper.tt' );

=head1 NAME

CPANHQ::View::HTML - TT View for CPANHQ

=head1 DESCRIPTION

TT View for CPANHQ. 

=head1 SEE ALSO

L<CPANHQ>

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
