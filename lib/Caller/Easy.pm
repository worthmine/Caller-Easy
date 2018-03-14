package Caller::Easy;
use 5.008001;
use strict;
use warnings;
use Carp;
use Exporter 'import';
our @EXPORT = qw/ecaller/;

our $VERSION = "0.01";

use Moose;

has 'depth'         => ( is => 'rw', isa => 'Maybe[Num]' );
has 'package'       => ( is => 'rw', isa => 'Str' );
has 'filename'      => ( is => 'rw', isa => 'Str' );
has 'line'          => ( is => 'rw', isa => 'Num' );
has 'subroutine'    => ( is => 'rw', isa => 'Str' );
has 'hasargs'       => ( is => 'rw', isa => 'Bool' );
has 'wantarray'     => ( is => 'rw', isa => 'Bool' );
has 'evaltext'      => ( is => 'rw', isa => 'Str' );
has 'is_require'    => ( is => 'rw', isa => 'Bool' );
has 'hints'         => ( is => 'rw', isa => 'Num' );
has 'bitmask'       => ( is => 'rw', isa => 'Str' );
has 'hinthash'      => ( is => 'rw', isa => 'Maybe[HashRef]' );

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    if ( @_ == 1 ) {
        return $class->$orig( depth => $_[0] ) if $_[0] =~ /^\d+$/;
        croak 'Unvalid depth was assigned';
    }elsif( @_ > 2 ) {
        croak 'too many arguments!';
    } else {
        return $class->$orig(@_);
    }
};

sub BUILD {
    my $self = shift;
    croak 'you must use ecaller in some subroutine' unless (CORE::caller(1))[3];
    my $depth = $self->depth();

    my (
        $package, $filename, $line,
        $subroutine, $hasargs, $wantarray, $evaltext,
        $is_require, $hints, $bitmask, $hinthash
    );

    if ( defined $depth and $depth =~ /^\d+$/ ) {
        do {
            ( $package, $filename, $line ) = CORE::caller(++$depth);
        } while( $package =~ /^Test::/ or $package =~ /^Caller::Easy/ );

        do {
            (
                undef, undef, undef,
                $subroutine, $hasargs, $wantarray, $evaltext,
                $is_require, $hints, $bitmask, $hinthash
            ) = CORE::caller(++$depth);
        } while( $package =~ /^Test::/ or $subroutine =~ /^Caller::Easy/ );
    } else {
        my $i = 1;
        do {
            ( $package, $filename, $line ) = CORE::caller($i++);
        } while( $package =~ /^Test::/ or $package =~ /^Caller::Easy/ );
    }


    $self->package($package)        if $package;
    $self->filename($filename)      if $filename;
    $self->line($line)              if $line;
    $self->subroutine($subroutine)  if $subroutine;
    $self->hasargs($hasargs)        if $hasargs;
    $self->wantarray($wantarray)    if $wantarray;
    $self->evaltext($evaltext)      if $evaltext;
    $self->is_require($is_require)  if $is_require;
    $self->hints($hints)            if $hints;
    $self->bitmask($bitmask)        if $bitmask;
    $self->hinthash($hinthash)      if $hinthash;
    return $self;
}

__PACKAGE__->meta->make_immutable;
no Moose;

sub ecaller {
    __PACKAGE__->new(@_);
}

1;
__END__

=encoding utf-8

=head1 NAME

Caller::Easy - It's new $module

=head1 SYNOPSIS

    use Caller::Easy;

=head1 DESCRIPTION

Caller::Easy is ...

=head1 LICENSE

Copyright (C) Yuki Yoshida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yuki Yoshida E<lt>worthmine@gmail.comE<gt>

=cut

