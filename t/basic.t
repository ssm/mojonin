use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Mojonin');
$t->get_ok('/')->status_is(200)->content_like(qr/coffee/i);

done_testing();
