NAME
====

Net::LibIDN - Perl 6 bindings for GNU LibIDN

SYNOPSIS
========

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

DESCRIPTION
===========

Net::LibIDN is a wrapper for the GNU LibIDN library.

METHODS
=======

  * **Net::LibIDN::TLD.strerror**(Int *$code* --> Str)

Returns the error represented by *$code* in human readable form. This is only available in LibIDN v0.4.0 and later.

  * **Net::LibIDN::TLD.get_z**(Str *$domain* --> Str)

  * **Net::LibIDN::TLD.get_z**(Str *$domain*, Int *$code* is rw --> Str)

Returns the top level domain of *$domain* as an ASCII encoded string. Assigns *$code* to the corresponding error code returned by the native function if provided. This is only available in LibIDN v0.4.0 and later.

  * **Net::LibIDN::TLD.get_table**(Str *$tld*, *@tables* --> Pointer[Net::LibIDN::TLD::Table])

Returns a pointer to the TLD table for *$tld* in the given array of pointers to *Net::LibIDN::TLD::Table*, *@tables*. This is only available in LibIDN v0.4.0 and later.

  * **Net::LibIDN::TLD.default_table**(Str *$tld* --> Pointer[Net:LibIDN::TLD::Table])

  * **Net::LibIDN::TLD.default_table**(Str *$tld*, *@tables* --> Pointer[Net::LibIDN::TLD::Table])

Returns a pointer to the default TLD table for *$tld*. *@tables*, if provided, contains an array of pointers to *Net::LibIDN::TLD::Table*, which overrides the array of natively cached TLD tables. This is only available in LibIDN v0.4.0 and later.

  * **Net::LibIDN::TLD.check_8z**(Str *$input* --> Int)

  * **Net::LibIDN::TLD.check_8z**(Str *$input*, Int *$code* is rw --> Int)

  * **Net::LibIDN::TLD.check_8z**(Str *$input*, @tables --> Int)

  * **Net::LibIDN::TLD.check_8z**(Str *$input*, @tables, Int *$code* is rw --> Bool)

Checks for any invalid characters in *$input*, and returns the position of any offending character found, or 0 otherwise. Assigns *$code* to the corresponding error code returned by the native function, if provided. *@tables* contains an array of pointers to *Net::LibIDN::TLD::Table*, if provided, which overrides the array of natively cached TLD tables. This is only available in LibiDN v0.4.0 and later.

CONSTANTS
=========

ERRORS
------

  * Int **TLD_SUCCESS**

Success.

  * Int **TLD_INVALID**

Invalid character found.

  * Int **TLD_NODATA**

No input data was provided.

  * Int **TLD_MALLOC_ERROR**

Error during memory allocation.

  * Int **TLD_ICONV_ERROR**

Error during iconv string conversion.

  * Int **TLD_NO_TLD**

No top-level domain found in the input string.

AUTHOR
======

Ben Davies <kaiepi@outlook.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2018 Ben Davies

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

