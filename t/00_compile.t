use strict;
use Test::More 0.98 tests => 12;

use lib 'lib';

use_ok 'Caller::Easy';                                                  # 1

note 'Object Oriented';
my $caller = new_ok('Caller::Easy');                                    # 2
is $caller->package(), __PACKAGE__, 'succeed to get package name';      # 3
is $caller->filename(), $0, 'succeed to get filename';                  # 4
is $caller->line(), __LINE__ - 3, 'succeed to get line number';         # 5

note 'like a function';
$caller = ecaller();
is $caller->package(), __PACKAGE__, 'succeed to get package name';      # 6
is $caller->filename(), $0, 'succeed to get filename';                  # 7
is $caller->line(), __LINE__ - 3, 'succeed to get line number';         # 8

note 'Errors';
eval{ $caller = ecaller("string") };
 like $@, qr/^Unvalid depth was assigned/i,                             # 9
"fail to assign the string to arg";

eval { $caller = ecaller(-1) };
 like $@, qr/^Unvalid depth was assigned/i,                             #10
"fail to assign unvalid depth";

eval { $caller = ecaller( 0, 1, 2 ) };
 like $@, qr/^Too many arguments for caller/i,                          #11
"fail to assign too many arguments";
eval { $caller = ecaller( 0, 1 ) };
 like $@, qr/^Unvalid arguments for caller/i,                           #12
"fail to assign unvalid arguments";

done_testing();
