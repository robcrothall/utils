#!/usr/bin/perl
use Finance::Quote;
my $q = Finance::Quote->new();
my @mysources = $q->sources();
print "Available sources are: \n";
foreach $s(@mysources)
{
    print "$s \n";
}
