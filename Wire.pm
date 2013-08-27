package Wire;

use warnings;
use strict;

sub new
{
	my ($type, $in, $out) = @_;

	my $self = {};	
	$self->{out} = $out;

	$self->{on} = 0;
	$self->{signal} = 0;

	bless $self, $type;
}

sub tick
{
	my $self = shift;

	$self->send(1, $self->out() );

	$self->on(0);
	$self->signal(0);
}

sub send
{
	my $self = shift;

	if ($self->on() ) {
		$self->{out}->recv($self->signal() );
	}
}
sub recv
{
	my ($self, $signal) = @_;

	$self->on(1);
	$self->signal($signal);
}
	
sub out
{
	my ($self, $arg) = shift;
	$self->{out} =  $arg if defined $arg;
	return $self->{out};
}
sub on
{
	my ($self, $arg) = shift;
	$self->{on} =  $arg if defined $arg;
	return $self->{on};
}
sub signal
{
	my ($self, $arg) = shift;
	$self->{signal} =  $arg if defined $arg;
	return $self->{signal};
}

return 1;
