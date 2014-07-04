#!/usr/bin/perl
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    module_name => 'Test::Builder::Compat',
    license     => 'perl',
    dist_author => 'Chad Granum <exodist7@gmail.com>',
    create_readme => 1,
    requires => {
        'Test::Simple' => '0.88',
    },
    meta_merge => {
        resources => {
            repository  => 'http://github.com/Test-More/Test-Builder-Compat',
            bugtracker  => 'http://github.com/Test-More/Test-Builder-Compat/issues',
        },
    },
);

$build->create_build_script;
