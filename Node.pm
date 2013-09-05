package Node;

use warnings;
use strict;

#BEGIN {}

sub new
{
	my $type = shift;

	my $self = {};
	$self->{out_1} = undef;
	$self->{out_2} = undef;
	$self->{in_1} = undef;
	$self->{in_2} = undef;
	$self->{dead} = 0;
	$self->{transform} = sub {};
	$self->{id} = 0;

	bless $self, $type;
	return $self;
}

sub tick
{
	my $self = shift;

	my ($o1, $o2) = $self->transform->($self->in_1(), $self->in_2() );

	$self->send(1, $o1);
	$self->send(2, $o2);	

	$self->in_1(undef);
	$self->in_2(undef);
}

sub recv
{
	my ($self, $input, $str) = @_;
	my $in;
	if ($input == 2) {
		$in = \$self->{in_2};
	} else {
		$in = \$self->{in_1};
	}

	if (defined $$in) {
		$self->{dead} = 1;		
		return 0;
	} else {
		$$in = $str;
	}
	return 1;
}
sub send
{
	my ($self, $output, $str) = @_;
	my $out;
	if ($output == 2) {
		$out = $self->{out_2};
	} else {
		$out = $self->{out_1};
	}

	$out->recv($str);
}

# getter/setters
sub out_1
{
	my ($self, $val) = @_;
	$self->{out_1} = $val if defined $val;
	return $self->{out_1}
}
sub out_2
{
	my ($self, $val) = @_;
	$self->{out_2} = $val if defined $val;
	return $self->{out_2};
}
sub in_1
{
	my ($self, $val) = @_;
	$self->{in_1} = $val if defined $val;
	return $self->{in_1};
}
sub in_2
{
	my ($self, $val) = @_;
	$self->{in_2} = $val if defined $val;
	return $self->{in_2};	
}
sub dead
{
	my ($self, $val) = @_;
	$self->{in_2} = $val if defined $val;
	return $self->{in_2};
}
sub id
{
	my ($self, $val) = @_;
	$self->{id} = $val if defined $val;
	return $self->{id};
}

return 1;
