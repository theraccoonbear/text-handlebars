#!/usr/bin/env perl
use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Handlebars;

use Test::Requires 'JSON', 'Path::Class';

for my $file (dir('t', 'mustache-spec', 'specs')->children) {
    next unless $file =~ /\.json$/;
    next if $file->basename =~ /^~/; # for now
    next if $file->basename =~ /partials/;
    my $tests = decode_json($file->slurp);
    note("running " . $file->basename . " tests");
    for my $test (@{ $tests->{tests} }) {
        local $TODO = "unimplemented"
            if $file->basename eq 'delimiters.json'
            && $test->{name} =~ /partial/i;

        render_ok(
            $test->{template},
            $test->{data},
            $test->{expected},
            "$test->{name}: $test->{desc}"
        );
    }
}

done_testing;
