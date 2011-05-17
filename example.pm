#!/usr/bin/env perl
# Example Module
# Copyright 2011 Jack Richardson
package example;

# Register Functions to API
&modAPI::register(\&on_register); 
&modAPI::reg_delete(\&on_delete); 

sub on_register {
	print $core::socket "PRIVMSG #ICHAT :I HAVE BEEN EXECUTED....\n";
	$commands{"foo"} = sub {
		print "COCKSUCKER";
	},
}

sub on_delete {
	&modAPI::unload;
}
1
