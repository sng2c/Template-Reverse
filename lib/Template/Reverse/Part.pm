package Template::Reverse::Part;
use Moo;

# VERSION
# ABSTRACT: Part class.

has pre=>(is=>'rw', default=>sub{[]});
has post=>(is=>'rw' , default=>sub{[]});
has type=>(is=>'rw');

sub as_arrayref{
  my ($self) = @_;
  return [$self->pre, $self->post];
}
1;
