use strict;
use Test::More 0.98 tests => 8;

use lib 'lib';

use_ok 'Caller::Easy';                                                  # 1

note 'Object Oriented';
my $caller = new_ok('Caller::Easy');                                    # 2
is $caller->package(), __PACKAGE__, 'succeed to get package name';      # 3
is $caller->filename(), $0, 'succeed to get filename';                  # 4
is $caller->line(), __LINE__ - 3, 'succeed to get line number';         # 5

note 'like a function';
my $caller = ecaller();
is $caller->package(), __PACKAGE__, 'succeed to get package name';      # 6
is $caller->filename(), $0, 'succeed to get filename';                  # 7
is $caller->line(), __LINE__ - 3, 'succeed to get line number';         # 8

done_testing();
