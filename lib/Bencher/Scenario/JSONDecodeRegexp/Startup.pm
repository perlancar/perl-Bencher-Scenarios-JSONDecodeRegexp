package Bencher::Scenario::JSONDecodeRegexp::Startup;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our $scenario = {
    summary => 'Benchmark startup overhead of JSON::Decode::Regexp',
    module_startup => 1,
    participants => [
        {module=>'JSON::Decode::Regexp'},
    ],
    #datasets => [
    #],
};

1;
# ABSTRACT:
