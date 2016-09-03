package JSON::Decode::Regexp;

our $DATE = '2016-02-18'; # DATE
our $VERSION = '0.04'; # VERSION

use 5.010001;
use strict;
use warnings;

#use Data::Dumper;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(from_json);

our $FROM_JSON = qr{

(?&VALUE) (?{ $_ = $^R->[1] })

(?(DEFINE)

(?<OBJECT>
  \{\s*
    (?{ [$^R, {}] })
    (?: (?&KV) # [[$^R, {}], $k, $v]
      (?{ # warn Dumper { obj1 => $^R };
	 [$^R->[0][0], {$^R->[1] => $^R->[2]}] })
      (?: \s*,\s* (?&KV) # [[$^R, {...}], $k, $v]
        (?{ # warn Dumper { obj2 => $^R };
           $^R->[0][1]{ $^R->[1] } = $^R->[2];
           $^R->[0] })
      )*
    )?
  \s*\}
)

(?<KV>
  (?&STRING) # [$^R, "string"]
  \s*:\s* (?&VALUE) # [[$^R, "string"], $value]
  (?{ # warn Dumper { kv => $^R };
     [$^R->[0][0], $^R->[0][1], $^R->[1]] })
)

(?<ARRAY>
  \[\s*
    (?{ [$^R, []] })
    (?: (?&VALUE) (?{ [$^R->[0][0], [$^R->[1]]] })
      (?: \s*,\s* (?&VALUE) (?{ # warn Dumper { atwo => $^R };
                         push @{$^R->[0][1]}, $^R->[1];
			 $^R->[0] })
      )*
    )?
  \s*\]
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
    )*
    "
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

This document describes version 0.04 of JSON::Decode::Regexp (from Perl distribution JSON-Decode-Regexp), released on 2016-02-18.

=head1 SYNOPSIS

 use JSON::Decode::Regexp qw(from_json);
 my $data = from_json(q([1, true, "a", {"b":null}]));

=head1 DESCRIPTION

This module is a packaging of Randal L. Schwartz' code (with minor modification)
originally posted at:

 http://perlmonks.org/?node_id=995856

The code is licensed "just like Perl".

=head1 FUNCTIONS

=head2 from_json($str) => DATA

Decode JSON in C<$str>. Dies on error.

=head1 FAQ

=head2 How does this module compare to other JSON modules on CPAN?

This module is rather slower than JSON::PP, does not support Unicode, and does
not pinpoint exact location on parse error. But it is a cool hack and
demonstrates the power of Perl regular expressions. It does not require any
non-core module. It requires Perl 5.10 at the minimum because it utilizes regex
features like named capture and recursive pattern.

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

L<JSON>, L<JSON::PP>, L<JSON::XS>, L<JSON::Tiny>.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
