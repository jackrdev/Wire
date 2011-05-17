#!/usr/bin/env perl
# Core Functions 
# Copyright 2011 Jack Richardson

package core;

use API;
use Data::Dumper;

our %modules;
our %rm_mod;
our %commands;

my $do = do "example.pm";
if($do) {
	print Dumper(\%commands);
	print Dumper(\%rm_mod);
	print Dumper(\%modules);
}

# Execute Loaded Command

$commands{"example"}();
$rm_mod{"example"}();
