#!/usr/bin/env perl
# API Module Loader
# Copyright 2011 Jack Richardson
package modAPI;

use Data::Dumper;
use Class::Unload;

sub register {
	my $mod = caller(0);
	$core::modules{$mod} = $_[0];
	$core::modules{$mod}(); # Execute the function
	
}
sub reg_delete {
	my $mod = caller(0);
	$core::rm_mod{$mod} = $_[0];
}

1
