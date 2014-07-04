package Test::Builder::Compat;
use strict;
use warnings;

our $VERSION = '0.001001';

my $HAS_PROVIDER = eval { require Test::Builder::Provider; 1 };

sub import {
    my $class = shift;
    my $caller = caller;
    my @import = @_ ? @_ : qw/provides provide_nests builder/;

    {
        no strict 'refs';
        *{"$caller\::HAS_PROVIDER"} = sub { $HAS_PROVIDER };
    }

    return Test::Builder::Provider->export_into($caller, @import)
        if $HAS_PROVIDER;

    require Test::Builder;
    for my $sub (@import) {
        my $code = $sub eq 'builder' ? sub { Test::Builder->new } : sub { 0 };
        no strict 'refs';
        *{"$caller\::$sub"} = $code;
    }
}

1;

__END__

=head1 NAME

Test::Builder::Compat - Write test tools that use new Test::Builder deatures
when available, but still work with old Test::Builders.

=head1 DESCRIPTION

The new L<Test::Builder> introduces a lot of new features and capabilities.
These are nice! But using them means requiring consumers of your module to
depend on a newer version of L<Test::Builder> to install.

With this module you can write testing tools that work on new and old versions
of Test::Builder. Write for the new builder, and test your testing tools with
the new builder, then add a few token tests to insure sane-base behavior on
older test builders.

=head1 SYNOPSYS

    package My::TestLib;
    use strict;
    use warnings;

    # Will either use Test::Builder::Provider for you, if available
    use Test::Builder::Compat qw/builder provides/;

    # Note, unlike using Test::Builder:Provider directly, provides will not
    # cause things to be exported, if you want to export things you need to use
    # an export tool yourself. Exporter.pm and most other exporters *should*
    # preserve the marking magic 'provides' endows.
    provides qw/ok is/;

    # builder() will do the right thing in either situation.
    sub ok($;$) { builder->ok(@_) }

    sub is($$;$) {
        my ($got, $want, $name) = @_;
        # use HAS_PROVIDER() to make $Level bumps conditional
        local $Test::Builder::Level = $Test::Builder::Level + 1 unless HAS_PROVIDER;
        ok($got eq $want, $name);
    }

    1;

=head1 EXPORTS

=over 4

=item $bool = HAS_PROVIDER()

True if the newer Test::Builder is present and loaded.

This is useful for conditioning localization of C<$Test::Builder::Level>:

    local $Test::Builder::Level = $Test::Builder::Level + 1 unless HAS_PROVIDER;

You do not want to localize $Level on a newer Test::Builder.

=item $tb = builder()

Get the proper instance of L<Test::Builder>

=item provides(...)

Mark testing tools as such (See L<Test::Builder::Provider>). When used with an
old Test::Builder this is a no-op.

=item provide_nests(...)

Mark testing tools as such (See L<Test::Builder::Provider>). When used with an
old Test::Builder this is a no-op.

=back

=head1 SEE ALSO

L<Test::Builder::Provider>

=head1 AUTHORS

=over 4

=item Chad Granum E<lt>exodist@cpan.orgE<gt>

=back

=head1 SOURCE

The source code repository for Test::Builder::Compat can be found at
F<http://github.com/xxx/>.

=head1 COPYRIGHT

Copyright 2014 Chad Granum E<lt>exodist7@gmail.comE<gt>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See F<http://www.perl.com/perl/misc/Artistic.html>

=cut
