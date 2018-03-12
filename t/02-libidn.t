use v6.c;
use Net::LibIDN;
use Test;

plan 3;

my $idn := Net::LibIDN.new;
is $idn.check_version, STRINGPREP_VERSION;
is $idn.check_version('0.0.1'), STRINGPREP_VERSION;
is $idn.check_version('255.255.65525'), '';

done-testing;
