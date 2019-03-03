#!/usr/bin/perl
use Finance::Quote;
my $q = Finance::Quote->new();
my %data = $q->fetch('nyse', 'IBM');
print "The current price of IBM on the JSE is " . $data{'IBM', 'price'};
