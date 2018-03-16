package Caller::Easy;
use 5.008001;
use strict;
use warnings;
use Carp;

our $VERSION = "0.01";

use overload '""' => sub{ $_[0]->package() }, fallback => 1;

use Moose;

has 'depth'         => ( is => 'ro',                                isa => 'Maybe[Num]' );
has 'package'       => ( is => 'ro', writer => '_set_package',      isa => 'Str' );
has 'filename'      => ( is => 'ro', writer => '_set_filename',     isa => 'Str' );
has 'line'          => ( is => 'ro', writer => '_set_line',         isa => 'Num' );
has 'subroutine'    => ( is => 'ro', writer => '_set_subroutine',   isa => 'Str' );
has 'hasargs'       => ( is => 'ro', writer => '_set_hasargs',      isa => 'Bool' );
has 'wantarray'     => ( is => 'ro', writer => '_set_wantarray',    isa => 'Bool' );
has 'evaltext'      => ( is => 'ro', writer => '_set_evaltext',     isa => 'Str' );
has 'is_require'    => ( is => 'ro', writer => '_set_is_require',   isa => 'Bool' );
has 'hints'         => ( is => 'ro', writer => '_set_hints',        isa => 'Num' );
has 'bitmask'       => ( is => 'ro', writer => '_set_bitmask',      isa => 'Str' );
has 'hinthash'      => ( is => 'ro', writer => '_set_hinthash',     isa => 'Maybe[HashRef]' );
has 'args'          => ( is => 'ro', writer => '_set_args',         isa => 'Maybe[ArrayRef]' );

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    if( @_ == 1 ) {
        return $class->$orig( depth => $_[0] ) if $_[0] =~ /^\d+$/;
        croak 'Unvalid depth was assigned';
    }elsif( @_ > 2 ) {
        croak 'Too many arguments for caller';
    }elsif( @_ == 2 and not exists $_{depth} ) {
        croak 'Unvalid arguments for caller';
    }else{
        return $class->$orig(@_);
    }
};

sub BUILD {
    my $self = shift;
    my $depth = $self->depth();

    my (
        $package, $filename, $line,
        $subroutine, $hasargs, $wantarray, $evaltext,
        $is_require, $hints, $bitmask, $hinthash
    );


    if( defined $depth and $depth =~ /^\d+$/ ) {
        package DB {
            our @args;
            my $i = 1;
            do {
                ( $package, $filename, $line ) = CORE::caller($i++);
            } while( $package =~ /^Test::/ or $package =~ /^Caller::Easy/ );

            (
                undef, undef, undef,
                $subroutine, $hasargs, $wantarray, $evaltext,
                $is_require, $hints, $bitmask, $hinthash
            ) = CORE::caller( $depth + $i++ );
        }
    }else{
        my $i = 1;
        do {
            ( $package, $filename, $line ) = CORE::caller($i++);
        } while( $package =~ /^Test::/ or $package =~ /^Caller::Easy/ );

        $self->_set_package($package)   if $package;
        $self->_set_filename($filename) if $filename;
        $self->_set_line($line)         if $line;

        return $self unless wantarray;
        return ( $package, $filename, $line );
    }

    $self->_set_package($package)           if $package;
    $self->_set_filename($filename)         if $filename;
    $self->_set_line($line)                 if $line;
    $self->_set_subroutine($subroutine)     if $subroutine;
    $self->_set_hasargs($hasargs)           if defined $hasargs;
    $self->_set_wantarray($wantarray)       if defined $wantarray;
    $self->_set_evaltext($evaltext)         if $evaltext;
    $self->_set_is_require($is_require)     if defined $is_require;
    $self->_set_hints($hints)               if $hints;
    $self->_set_bitmask($bitmask)           if $bitmask;
    $self->_set_hinthash($hinthash)         if $hinthash;
    $self->_set_args(\@DB::args);

    return $self unless wantarray;
    return (
        $package, $filename, $line,
        $subroutine, $hasargs, $wantarray, $evaltext,
        $is_require, $hints, $bitmask, $hinthash
    );
}

__PACKAGE__->meta->make_immutable;
no Moose;

sub caller {
    __PACKAGE__->new(@_);
}

sub import {
    my $packagename = CORE::caller;
    no strict 'refs';
    *{"$packagename\::caller"} = \&caller;
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

