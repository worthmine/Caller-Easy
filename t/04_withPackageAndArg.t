package Bazz;

use strict;
use Test::More 0.98 tests => 11;

use lib 'lib';

use Caller::Easy;

sub Foo {
    my $caller = ecaller(0);
    is $caller->package(), __PACKAGE__, 'succeed to get package name';  # 1
    is $caller->filename(), $0, 'succeed to get filename';              # 2
    is $caller->line(), __LINE__ - 3, 'succeed to get line number';     # 3

     is $caller->subroutine(), (CORE::caller(0))[3],                    # 4
    'succeed to get name of subroutine';
     is $caller->hasargs(), (CORE::caller(0))[4],                       # 5
    'succeed to get hasargs';
     is $caller->wantarray(), (CORE::caller(0))[5],                     # 6
    'succeed to get wantarray';
     is $caller->evaltext(), (CORE::caller(0))[6],                      # 7
    'succeed to get evaltext';
     is $caller->is_require(), (CORE::caller(0))[7],                    # 8
    'succeed to get is_require';
    is $caller->hints(), (CORE::caller(0))[8], 'succeed to get hints';  # 9
     is $caller->bitmask(), (CORE::caller(0))[9],                       #10
    'succeed to get bitmask';
     is $caller->hinthash(), (CORE::caller(0))[10],                     #11
    'succeed to get hinthash';
}

sub Bar {
    Foo();
}

Bar();

done_testing();
