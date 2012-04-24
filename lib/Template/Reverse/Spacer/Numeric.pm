package Template::Reverse::Spacer::Numeric;
use Any::Moose;
use namespace::autoclean;

our $VERSION = '0.003';
sub Space{
    my $self = shift;
    my $str = shift;
    return _space($str);
}

sub _space{
    my $str = shift;
    $str =~ s/(\d[\d,]*(\.\d+)?)(\D)/$1 $3/gm;
    $str =~ s/([^,.\d])(\d[\d,]*(\.\d+)?)/$1 $2/gm;
    $str =~ s/\s+/ /g;
    $str =~ s/^\s//g;
    $str =~ s/\s$//g;
    return $str;
}
=pod

=head1 NAME

Template::Reverse::Spacer::Numeric - Insert spaces around Numeric word.

=head1 SYNOPSIS
    
    package Template::Reverse::Spacer::Numeric;
    my $num = Template::Reverse::Spacer::Numeric->new;
    $num->Space('1,000dollers'); # '1,000 dollers'

=cut

__PACKAGE__->meta->make_immutable;
1;
