package Template::Reverse::Splitter::Whitespace;
use Any::Moose;
our $VERSION = '0.002';
sub Split{
    my $self = shift;
    my $str = shift;
    return split(/\s+/,$str);
}

=pod
=head1 NAME
Template::Reverse::Splitter::Whitespace - Split text by whitespace

=head1 SYNOPSIS
 
    package Template::Reverse::Splitter::Whitespace;
    my $num = Template::Reverse::Splitter::Whitespace->new;
    $num->Split('1,000 dollers'); # ('1,000', 'dollers')

=cut
1;
