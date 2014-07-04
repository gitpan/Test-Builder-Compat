#!/usr/bin/perl
use strict;
use warnings;

eval { require Test::Builder::Provider };

use Test::More;

{
    package My::Tool;
    use Test::Builder::Compat;
}

can_ok( 'My::Tool', qw/HAS_PROVIDER provides provide_nests/ );

if($INC{'Test/Builder/Provider.pm'}) {
    ok(My::Tool::HAS_PROVIDER(), "HAS_PROVIDER tells the truth ($INC{'Test/Builder/Provider.pm'})")
}
else {
    ok(!My::Tool::HAS_PROVIDER(), "HAS_PROVIDER tells the truth (We do not have it)")
}

done_testing;
