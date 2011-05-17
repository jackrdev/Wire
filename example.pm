#!/usr/bin/env perl
# Example Module
# Copyright 2011 Jack Richardson
package example;

# Register Functions to API
&modAPI::register(\&on_register); 
&modAPI::reg_delete(\&on_delete); 

sub on_register {
	print "Example Module Loaded!\n";
	$core::commands{"example"} = sub {
		print "Example Handle has been executed!\n";
	};
}

sub on_delete {
	# Unload - EVERYTHING
	delete $core::commands{"example"};
	delete $core::modules{"example"};
	delete $core::rm_mod{"example"};
	Class::Unload->unload("example.pm");
	print "Example Module Unloaded.";
}

1
