use v6.c;
use NativeCall;
unit class Net::LibIDN::TLD;

constant LIB = 'idn';

constant TLD_SUCCESS      is export = 0;
constant TLD_INVALID      is export = 1;
constant TLD_NODATA       is export = 2;
constant TLD_MALLOC_ERROR is export = 3;
constant TLD_ICONV_ERROR  is export = 4;
constant TLD_NO_TLD       is export = 5;

class Table::Element is repr('CStruct') {
    has uint32 $.start;
    has uint32 $.end;

    submethod TWEAK() {
        $!start = 0;
        $!end   = 0;
    }
}

class Table is repr('CStruct') {
    has Str $.name;
    has Str $.version;
    has size_t $.nvalid;
    has Pointer[Table::Element] $.valid;

    submethod TWEAK() {
        $!name    = Str.new;
        $!version = Str.new;
        $!nvalid  = 0;
        $!valid   = Pointer[Table::Element].new;
    }
}

sub idn_free(Pointer) is native(LIB) { * }

sub tld_strerror(int32 --> Str) is native(LIB) { * }
method strerror(Int $code --> Str) { tld_strerror($code) }

sub tld_get_z(
    Str,
    Pointer[Str] is encoded('ascii') is rw
    --> int32
) is native(LIB) { * }
proto method get_z(Str, Int $? --> Str) { * }
multi method get_z(Str $domain --> Str) {
    my $tldptr := Pointer[Str].new;
    my $code := tld_get_z($domain, $tldptr);
    return '' if $code !== TLD_SUCCESS;

    my $tld := $tldptr.deref;
    idn_free($tldptr);
    $tld;
}
multi method get_z(Str $domain, Int $code is rw --> Str) {
    my $tldptr := Pointer[Str].new;
    $code = tld_get_z($domain, $tldptr);
    return '' if $code !== TLD_SUCCESS;

    my $tld := $tldptr.deref;
    idn_free($tldptr);
    $tld;
}

sub tld_get_table(
    Str is encoded('ascii'),
    CArray[Pointer[Table]]
    --> Pointer[Table]
) is native(LIB) { * }
method get_table(Str $tld, @tables --> Pointer[Table]) {
    my @tableptrs := CArray[Pointer[Table]].new: @tables;
    tld_get_table($tld, @tableptrs);
}

sub tld_default_table(
    Str is encoded('ascii'),
    CArray[Pointer[Table]]
    --> Pointer[Table]
) is native(LIB) { * }
proto method default_table(Str, @? --> Pointer[Table]) { * }
multi method default_table(Str $tld --> Pointer[Table]) {
    my @overrides := CArray[Pointer[Table]].new;
    tld_default_table($tld, @overrides);
}
multi method default_table(Str $tld, @tables --> Pointer[Table]) {
    my @overrides := CArray[Pointer[Table]].new: @tables;
    tld_default_table($tld, @overrides);
}

sub tld_check_8z(
    Str,
    Pointer[size_t] is rw,
    CArray[Pointer[Table]]
    --> int32
) is native(LIB) { * }
proto method check_8z(Str, | --> Int) { * }
multi method check_8z(Str $input --> Int) {
    my $errposptr = Pointer[size_t].new;
    my @overrides := CArray[Pointer[Table]].new;
    my $code := tld_check_8z($input, $errposptr, @overrides);
    return 0 unless $errposptr;

    my $errpos := $errposptr.deref;
    idn_free($errposptr);
    $errpos;
}
multi method check_8z(Str $input, Int $code is rw --> Int) {
    my $errposptr = Pointer[size_t].new;
    my @overrides := CArray[Pointer[Table]].new;
    $code = tld_check_8z($input, $errposptr, @overrides);
    return 0 unless $errposptr;

    my $errpos := $errposptr.deref;
    idn_free($errposptr);
    $errpos;
}
multi method check_8z(Str $input, @tables --> Int) {
    my $errposptr = Pointer[size_t].new;
    my @overrides := CArray[Pointer[Table]].new: @tables;
    my $code := tld_check_8z($input, $errposptr, @overrides);
    return 0 unless $errposptr;

    my $errpos := $errposptr.deref;
    idn_free($errposptr);
    $errpos;
}
multi method check_8z(Str $input, @tables, Int $code is rw --> Int) {
    my $errposptr = Pointer[size_t].new;
    my @overrides := CArray[Pointer[Table]].new: @tables;
    $code = tld_check_8z($input, $errposptr, @overrides);
    return 0 unless $errposptr;

    my $errpos := $errposptr.deref;
    idn_free($errposptr);
    $errpos;
}
