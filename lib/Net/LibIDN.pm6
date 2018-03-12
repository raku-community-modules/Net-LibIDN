use v6.c;
use NativeCall;
unit class Net::LibIDN:ver<0.0.1>:auth<github:Kaiepi>;

constant LIB = 'idn';

sub stringprep_check_version(Str --> Str) is native(LIB) { * }
method check_version(Str $version = '' --> Str) { stringprep_check_version($version) || '' }

constant STRINGPREP_VERSION is export = stringprep_check_version('');

sub idn_free(Pointer) is native(LIB) { * }

=begin pod

=head1 NAME

Net::LibIDN - Perl 6 bindings for GNU LibIDN

=head1 SYNOPSIS

  use Net::LibIDN;

  # TODO

  use Net::LibIDN::TLD;

  my $idn_tld := Net::LibIDN::TLD.new;
  my $domain := 'google.com';
  my Int $code;
  my $tld := $idn_tld.get_z($domain, $code);
  say "$tld $code"; # com 0

  my $tld := 'fr';
  my $tableptr = $idn_tld.default_table($tld);
  my $table = $tableptr.deref;
  say $table.name, ' ', $table.nvalid; # fr 12

  $tableptr = $idn_tld.get_table($tld, [$tableptr]);
  $table = $tableptr2.deref;
  say $table.name, ' ', $table.nvalid; # fr 12

  my $errpos := $idn_tld.check_8z($domain, $code);
  say "$errpos $code"; # 0 0

  say $idn_tld.strerror($code); # Success

=head1 DESCRIPTION

Net::LibIDN is a wrapper for the GNU LibIDN library.

=head1 METHODS

=item B<Net::LibIDN::TLD.strerror>(Int I<$code> --> Str)

Returns the error represented by I<$code> in human readable form. This is only
available in LibIDN v0.4.0 and later.

=item B<Net::LibIDN::TLD.get_z>(Str I<$domain> --> Str)
=item B<Net::LibIDN::TLD.get_z>(Str I<$domain>, Int I<$code> is rw --> Str)

Returns the top level domain of I<$domain> as an ASCII encoded string. Assigns
I<$code> to the corresponding error code returned by the native function if
provided. This is only available in LibIDN v0.4.0 and later.

=item B<Net::LibIDN::TLD.get_table>(Str I<$tld>, I<@tables> --> Pointer[Net::LibIDN::TLD::Table])

Returns a pointer to the TLD table for I<$tld> in the given array of pointers
to I<Net::LibIDN::TLD::Table>, I<@tables>. This is only available in LibIDN
v0.4.0 and later.

=item B<Net::LibIDN::TLD.default_table>(Str I<$tld> --> Pointer[Net:LibIDN::TLD::Table])
=item B<Net::LibIDN::TLD.default_table>(Str I<$tld>, I<@tables> --> Pointer[Net::LibIDN::TLD::Table])

Returns a pointer to the default TLD table for I<$tld>. I<@tables>, if
provided, contains an array of pointers to I<Net::LibIDN::TLD::Table>, which
overrides the array of natively cached TLD tables. This is only available in
LibIDN v0.4.0 and later.

=item B<Net::LibIDN::TLD.check_8z>(Str I<$input> --> Int)
=item B<Net::LibIDN::TLD.check_8z>(Str I<$input>, Int I<$code> is rw --> Int)
=item B<Net::LibIDN::TLD.check_8z>(Str I<$input>, @tables --> Int)
=item B<Net::LibIDN::TLD.check_8z>(Str I<$input>, @tables, Int I<$code> is rw --> Bool)

Checks for any invalid characters in I<$input>, and returns the position of any
offending character found, or 0 otherwise. Assigns I<$code> to the
corresponding error code returned by the native function, if provided.
I<@tables> contains an array of pointers to I<Net::LibIDN::TLD::Table>, if
provided, which overrides the array of natively cached TLD tables. This is only
available in LibiDN v0.4.0 and later.

=head1 CONSTANTS

=head2 ERRORS

=item Int B<TLD_SUCCESS>

Success.

=item Int B<TLD_INVALID>

Invalid character found.

=item Int B<TLD_NODATA>

No input data was provided.

=item Int B<TLD_MALLOC_ERROR>

Error during memory allocation.

=item Int B<TLD_ICONV_ERROR>

Error during iconv string conversion.

=item Int B<TLD_NO_TLD>

No top-level domain found in the input string.

=head1 AUTHOR

Ben Davies <kaiepi@outlook.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Ben Davies

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
