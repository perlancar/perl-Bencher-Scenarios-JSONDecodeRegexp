package Bencher::Scenario::JSONDecodeRegexp;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our $scenario = {
    summary => 'Benchmark from_json()',
    participants => [
        {
            #name => 'from_json',
            fcall_template => 'JSON::Decode::Regexp::from_json(<data>)',
        },
    ],
    datasets => [
        {name => 'array0'  , args=>{data=>'[]'}},
        {name => 'array1'  , args=>{data=>'[1]'}},
        {name => 'array10' , args=>{data=>'[1,2,3,4,5,6,7,8,9,10]'}},
        {name => 'array100', args=>{data=>'[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]'}},
        {name => 'hash0'   , args=>{data=>'{}'}},
        {name => 'hash1'   , args=>{data=>'{"1":1}'}},
        {name => 'hash10'  , args=>{data=>'{"01":1,"02":1,"03":1,"04":1,"05":1,"06":1,"07":1,"08":1,"09":1,"10":1}'}},
        {name => 'hash100' , args=>{data=>'{"001":1,"002":1,"003":1,"004":1,"005":1,"006":1,"007":1,"008":1,"009":1,"010":1,"011":1,"012":1,"013":1,"014":1,"015":1,"016":1,"017":1,"018":1,"019":1,"020":1,"021":1,"022":1,"023":1,"024":1,"025":1,"026":1,"027":1,"028":1,"029":1,"030":1,"031":1,"032":1,"033":1,"034":1,"035":1,"036":1,"037":1,"038":1,"039":1,"040":1,"041":1,"042":1,"043":1,"044":1,"045":1,"046":1,"047":1,"048":1,"049":1,"050":1,"051":1,"052":1,"053":1,"054":1,"055":1,"056":1,"057":1,"058":1,"059":1,"060":1,"061":1,"062":1,"063":1,"064":1,"065":1,"066":1,"067":1,"068":1,"069":1,"070":1,"071":1,"072":1,"073":1,"074":1,"075":1,"076":1,"077":1,"078":1,"079":1,"080":1,"081":1,"082":1,"083":1,"084":1,"085":1,"086":1,"087":1,"088":1,"089":1,"090":1,"091":1,"092":1,"093":1,"094":1,"095":1,"096":1,"097":1,"098":1,"099":1,"100":1}'}},
    ],
};

1;
# ABSTRACT: