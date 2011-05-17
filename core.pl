#!/usr/bin/env perl
# Core Functions 
# Copyright 2011 Jack Richardson

package core;

use API;
use Data::Dumper;

our %modules;
our %rm_mod;
our %commands;
our %config;

# Parse & Validate Config
%config = &configParse("bot.conf");
&validate(\%config);



sub configParse {
	my($config, $readarg, @args) = ($_[0], "<", @_);
	open(CONFIG, $readarg, $config) or die "$!\n";
	while(<CONFIG>) {
		chomp;
		s/;.*//; # Parse Comments
		s/config.*//;s/}.*//; # Parse Structure
		s/"|"//;s/"|"//; # Parse Parenthesis
		s/\s+$//; # Whitespace hax
		s/^\s+//; # "            "
		next unless length;
		my($key, $config) = split (/\s*=\s*/, $_, 2);
		$tmp{$key} = $config;
	}
	close(CONFIG);
	return %tmp;
}

sub validate {
	my($err) = (0);
	if( ! $config{'server'} ){ print "&core::validate => Server Not 
defined in configuration"; $err = 1; }
	if( ! $config{'port'} ){ print "&core::validate => Port Not 
defined in configuration"; $err = 1; }
	if( ! $config{'nickname'} ){ print "&core::validate => Nickname 
Not defined in configuration"; $err = 1; }
	if( ! $config{'username'} ){ print "&core::validate => Username 
Not defined in configuration"; $err = 1; }
	if( ! $config{'realname'} ){ print "&core::validate => Realname 
Not defined in configuration"; $err = 1; }
	if( ! $config{'autojoin'} ){ print "&core::validate => Server 
Not defined in configuration"; $err = 1; }
	if($err) {
		print "\n\nexiting...\n";
		exit(0);
	}
}
