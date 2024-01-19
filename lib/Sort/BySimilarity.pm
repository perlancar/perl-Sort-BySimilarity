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
                       gen_sorter_by_similarity
                       sort_by_similarity
               );
#gen_cmp_by_similarity

sub gen_sorter_by_similarity {
    my ($is_reverse, $is_ci, $args) = @_;
    $args //= {};

    sub {
        my @items = @_;
        my @distances;
        if ($is_ci) {
            @distances = map { Text::Levenshtein::XS::distance($args->{string}, $_) } @items;
        } else {
            @distances = map { Text::Levenshtein::XS::distance(lc($args->{string}), (lc $_)) } @items;
        }

        map { $items[$_] } sort {
            ($is_reverse ? $distances[$b] <=> $distances[$a] : $distances[$a] <=> $distances[$b]) ||
                ($is_reverse ? $b <=> $a : $a <=> $b)
            } 0 .. $#items;
    };
}

sub sort_by_similarity {
    my $is_reverse = shift;
    my $is_ci = shift;
    my $args = shift;
    gen_sorter_by_similarity($is_reverse, $is_ci, $args)->(@_);
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
