#!/usr/bin/env perl
# API Module Loader
# Copyright 2011 Jack Richardson

package modAPI;

use Data::Dumper;
use Class::Unload;

sub register {
	my $mod = caller(0);
	$core::modules{$mod} = $_[0] if $_[0];
	$core::modules{$mod}() if $core::modules{$mod};
}
sub reg_delete {
	my $mod = caller(0);
	$core::rm_mod{$mod} = $_[0] if $_[0];
}

sub unload {
	my $mod = caller(0);
	delete $core::commands{$mod} if exists $core::commands{$mod};
	delete $core::modules{$mod} if exists $core::modules{$mod};
	delete $core::rm_mod{$mod} if exists $core::rm_mod{$mod};
	Class::Unload->unload($mod);
}

1
