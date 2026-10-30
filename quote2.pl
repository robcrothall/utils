#!/usr/bin/perl -w
use strict;
use Finance::Quote;


my $exchange = shift;	# Where we fetch our stocks from.
my @symbols = @ARGV;    # Which stocks we want.

my $quoter = Finance::Quote->new;      # Create the F::Q object.

$quoter->timeout(30);	# Cancel fetch operation if it
				        # takes longer than 30 seconds.

# Grab our information and place it into %info.
my %info = $quoter->fetch($exchange, @symbols);

foreach my $stock (@symbols) {
	unless ($info{$stock, "success"}) {
		warn "Lookup of $stock failed - ".$info{$stock, "errormsg"}.
		     "\n";
		next;
	}
	print "$stock:\t",
	      "Volume: ", $info{$stock, "volume"}, "\t",
	      "Price: " , $info{$stock, "price"}, "\t",
	      "Name: ",   $info{$stock, "name"}, "\n";
}
