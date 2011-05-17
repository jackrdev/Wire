#!/usr/bin/env perl
# Core Functions 
# Copyright 2011 Jack Richardson

package core;

use API;
use Data::Dumper;
use IO::Socket;
use feature 'switch';

our %modules;
our %rm_mod;
our %commands = (
	"!load" => \&load_mod
);
our %config;

# Parse & Validate Config
%config = &configParse("bot.conf");
&validate(\%config);

our $socket = IO::Socket::INET->new(
	PeerAddr => $config{'server'},
	PeerPort => $config{'port'},
	Proto 	 => 'tcp'
) or die "$!\n";

&raw("NICK ".$config{'nickname'});
&raw("USER ".$config{'username'}." * * :".$config{'realname'});

while(<$socket>) {
	my(@data) = split (/ /,$_);
	given($data[0]) {
		when("PING") {
			&raw("PONG ".$data[1]);
		}
	}
	given($data[1]) {
		when("396") {
			&raw("JOIN ".$config{'autojoin'});
		}
		when("PRIVMSG") {
			my($channel) = $data[2];
			my $cmd = $data[3];
			$cmd =~ s/://;
			$cmd =~ s/^\s+//;s/\s+$//;
			print "\n$cmd\n";
			$commands{$cmd}($channel, @data[4..$#data]) if exists $commands{$cmd};
		}
	}
	print $_;
}
sub load_mod {
	my($channel, @args) = (shift, @_);
	$f = $_[0];
	$f =~ s/^\s+//;
	$f =~ s/\s+$//;
	$f = $f . ".pm";
	&chanMsg($channel, "Loading $f");
	my $do = do $f;
	if ($do) {
		&chanMsg($channel, "YEY. IT LOADED!");
	}else
	{
		&chanMsg($channel, "$!");
	}
}
sub chanMsg {
	my($chan, @args) = (shift, @_);
	$_msg = join (' ', @args);
	if($socket) {
		&raw("PRIVMSG $chan :$_msg");
	}
}
sub raw {
	my ($cmd) = shift;
	print $socket "$cmd\n" if $socket;
}
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
	if( ! $config{'server'} ){ print "&core::validate => Server Not defined in configuration"; $err = 1; }
	if( ! $config{'port'} ){ print "&core::validate => Port Not defined in configuration"; $err = 1; }
	if( ! $config{'nickname'} ){ print "&core::validate => Nickname Not defined in configuration"; $err = 1; }
	if( ! $config{'username'} ){ print "&core::validate => Username Not defined in configuration"; $err = 1; }
	if( ! $config{'realname'} ){ print "&core::validate => Realname Not defined in configuration"; $err = 1; }
	if( ! $config{'autojoin'} ){ print "&core::validate => AutoJoin Not defined in configuration"; $err = 1; }
	if($err) {
		print "\n\nexiting...\n";
		exit(0);
	}
}
