use strict;
use Test::More 0.98;

use lib 'lib';

use_ok 'Caller::Easy';  #1

my $caller = new_ok('Caller::Easy');
is $caller->package(), 'main', 'package is OK';
is $caller->filename(), $0, 'filename is OK';
is $caller->line(), __LINE__ - 3, 'line is OK';

my $caller = ecaller();
is $caller->package(), 'main', 'package is OK';
is $caller->filename(), $0, 'filename is OK';
is $caller->line(), __LINE__ - 3, 'line is OK';

sub test {
    my $caller = ecaller();
    is $caller->package(), (CORE::caller)[0], 'package is OK';
    is $caller->filename(), (CORE::caller)[1], 'filename is OK';
    is $caller->line(), __LINE__ - 3, 'line is OK';
}
test();

my @subs = qw( a b c d e f g h i j k l m n o p q r s t u v w x y z );

my $caller_n;
for ( my $i = 0; $i <= 26; $i++ ) {
#    $caller_n = new_ok( 'Caller::Easy', [ depth => $i ] );  #3
#    is $caller_n->line(), __LINE__, 'line is OK';
}


done_testing();

