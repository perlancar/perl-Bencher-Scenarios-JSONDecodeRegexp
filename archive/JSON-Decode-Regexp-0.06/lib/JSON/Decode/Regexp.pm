package JSON::Decode::Regexp;

our $DATE = '2016-03-18'; # DATE
our $VERSION = '0.06'; # VERSION

use 5.010001;
use strict;
use warnings;

#use Data::Dumper;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(from_json);

sub _fail { die __PACKAGE__.": $_[0] at offset ".pos()."\n" }

our $FROM_JSON = qr{

(?:
    (?&VALUE) (?{ $_ = $^R->[1] })
|
    \z (?{ _fail "Unexpected end of input" })
|
      (?{ _fail "Invalid literal" })
)

(?(DEFINE)

(?<OBJECT>
  \{\s*
    (?{ [$^R, {}] })
    (?:
        (?&KV) # [[$^R, {}], $k, $v]
        (?{ [$^R->[0][0], {$^R->[1] => $^R->[2]}] })
        \s*
        (?:
            (?:
                ,\s* (?&KV) # [[$^R, {...}], $k, $v]
                (?{ $^R->[0][1]{ $^R->[1] } = $^R->[2]; $^R->[0] })
            )*
        |
            (?:[^,\}]|\z) (?{ _fail "Expected ',' or '\x7d'" })
        )*
    )?
    \s*
    (?:
        \}
    |
        (?:.|\z) (?{ _fail "Expected closing of hash" })
    )
)

(?<KV>
  (?&STRING) # [$^R, "string"]
  \s*
  (?:
      :\s* (?&VALUE) # [[$^R, "string"], $value]
      (?{ [$^R->[0][0], $^R->[0][1], $^R->[1]] })
  |
      (?:[^:]|\z) (?{ _fail "Expected ':'" })
  )
)

(?<ARRAY>
  \[\s*
  (?{ [$^R, []] })
  (?:
      (?&VALUE) # [[$^R, []], $val]
      (?{ [$^R->[0][0], [$^R->[1]]] })
      \s*
      (?:
          (?:
              ,\s* (?&VALUE)
              (?{ push @{$^R->[0][1]}, $^R->[1]; $^R->[0] })
          )*
      |
          (?: [^,\]]|\z ) (?{ _fail "Expected ',' or '\x5d'" })
      )
  )?
  \s*
  (?:
      \]
  |
      (?:.|\z) (?{ _fail "Expected closing of array" })
  )
)

(?<VALUE>
  \s*
  (
      (?&STRING)
  |
      (?&NUMBER)
  |
      (?&OBJECT)
  |
      (?&ARRAY)
  |
      true (?{ [$^R, 1] })
  |
      false (?{ [$^R, 0] })
  |
      null (?{ [$^R, undef] })
  )
  \s*
)

(?<STRING>
  (
    "
    (?:
        [^\\"]+
    |
        \\ ["\\/bfnrt]
#    |
#      \\ u [0-9a-fA-f]{4}
    |
        \\ . (?{ _fail "Invalid string escape character" })
    )*
    (?:
        "
    |
        (?:\\|\z) (?{ _fail "Expected closing of string" })
    )
  )

  (?{ [$^R, eval $^N] })
)

(?<NUMBER>
  (
    -?
    (?: 0 | [1-9]\d* )
    (?: \. \d+ )?
    (?: [eE] [-+]? \d+ )?
  )

  (?{ [$^R, 0+$^N] })
)

) }xms;

sub from_json {
    local $_ = shift;
    local $^R;
    eval { m{\A$FROM_JSON\z}; } and return $_;
    die $@ if $@;
    die 'no match';
}

1;
# ABSTRACT: JSON parser as a single Perl Regex

__END__

=pod

=encoding UTF-8

=head1 NAME

JSON::Decode::Regexp - JSON parser as a single Perl Regex

=head1 VERSION

This document describes version 0.06 of JSON::Decode::Regexp (from Perl distribution JSON-Decode-Regexp), released on 2016-03-18.

=head1 SYNOPSIS

 use JSON::Decode::Regexp qw(from_json);
 my $data = from_json(q([1, true, "a", {"b":null}]));

=head1 DESCRIPTION

This module is a packaging of Randal L. Schwartz' code (with some modification)
originally posted at:

 http://perlmonks.org/?node_id=995856

The code is licensed "just like Perl".

=head1 FUNCTIONS

=head2 from_json($str) => DATA

Decode JSON in C<$str>. Dies on error.

=head1 FAQ

=head2 How does this module compare to other JSON modules on CPAN?

As of version 0.04, performance-wise this module quite on par with L<JSON::PP>
(faster on strings and longer arrays/objects, slower on simpler JSON) and a bit
slower than L<JSON::Tiny>. And of course all three are much slower than XS-based
modules like L<JSON::XS>.

JSON::Decode::Regexp does not yet support Unicode, and does not pinpoint exact
location on parse error.

In general, I don't see a point in using it in production (I recommend instead
L<JSON::XS> or L<Cpanel::JSON::XS> if you can use XS modules, or L<JSON::Tiny>
if you must use pure Perl modules). But it is a cool hack that demonstrates the
power of Perl regular expressions and beautiful code.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/JSON-Decode-Regexp>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-JSON-Decode-Regexp>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=JSON-Decode-Regexp>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 SEE ALSO

Pure-perl modules: L<JSON::Tiny>, L<JSON::PP>, L<Pegex::JSON>,
L<JSON::Decode::Marpa>.

XS modules: L<JSON::XS>, L<Cpanel::JSON::XS>.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
