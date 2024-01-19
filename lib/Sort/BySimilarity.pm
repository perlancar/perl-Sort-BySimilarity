package Sort::BySimilarity;

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);
use Text::Levenshtein::XS;

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(
                       sort_by_similarity
               );
#cmp_by_similarity

sub sort_by_similarity {
    my ($is_reverse, $is_ci, $args) = @_;

    sub {
        my @items = @_;
        my @distances;
        if ($is_ci= map { Text::Levenshtein::XS::distance($args->{string}, $_) } @items;
        map { $items[$_] } sort { $distances[$a] <=> $distances[$b] || $a <=> $b } 0 .. $#items;
    };
}

1;
# ABSTRACT: Sort by most similar to a reference string

=head1 SYNOPSIS

 use Sort::BySimilarity qw(sort_by_similarity);

 #                               reverse?  case insensitive?  args
 my $sorter = sort_by_similarity(0,        0,                 {string=>"foo"});
 my @sorted = $sorter->("food", "foolish", "foo", "bar"); #

=head1 DESCRIPTION

=cut
