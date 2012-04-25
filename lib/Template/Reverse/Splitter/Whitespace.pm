package Template::Reverse::Splitter::Whitespace;

# ABSTRACT: Split text by whitespace

use Any::Moose;
use namespace::autoclean;

# VERSION

sub Split{
    my $self = shift;
    my $str = shift;
    return split(/\s+/,$str);
}

=pod

=head1 SYNOPSIS
 
    package Template::Reverse::Splitter::Whitespace;
    my $num = Template::Reverse::Splitter::Whitespace->new;
    $num->Split('1,000 dollers'); # ('1,000', 'dollers')

=cut

__PACKAGE__->meta->make_immutable;
1;
