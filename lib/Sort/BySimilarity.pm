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
        if ($is_ci) {
            @distances = map { Text::Levenshtein::XS::distance($args->{string}, $_) } @items;
        } else {
            @distances = map { Text::Levenshtein::XS::distance(lc($args->{string}), (lc $_)) } @items;
        }

        map { $items[$_] } sort {
            ($is_reverse ? $distances[$a] <=> $distances[$b] : $distances[$b] <=> $distances[$a]) ||
                ($is_reverse ? $a <=> $b : $b <=> $a)
            } 0 .. $#items;
    };
}

1;
# ABSTRACT: Sort by most similar to a reference string

=head1 SYNOPSIS

 use Sort::BySimilarity qw(
     gen_sorter_by_similarity
     gen_cmp_by_similarity
 );

 #                               reverse?  case insensitive?  args
 my $sorter = gen_sorter_by_similarity(0,        0,                 {string=>"foo"});
 my @sorted = $sorter->("food", "foolish", "foo", "bar"); #


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 sort_by_similarity

Usage:

 my $sorter = gen_sorter_by_similarity($is_reverse, $is_ci, \%args);

Will generate a sorter subroutine C<$sorter> which accepts list and will sort
them and return the sorted items. C<$is_reverse> is a bool, can be set to true
to generate a reverse sorter (least similar items will be put first). C<$is_ci>
is a bool, can be set to true to sort case-insensitively.

Arguments:

=over

=item * string

Str. Required. Reference string to be compared against each item.

=back

=cut
