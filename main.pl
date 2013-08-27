#!/usr/bin/perl

use warnings;
use strict;

use Node;
use Wire;

use SDL;
use SDL::Events;
use SDLx::App;
use SDLx::Rect;
use SDLx::Sprite;
use SDLx::Text;

my $app = SDLx::App->new(
	t => 'Neuro-Coder',
	w => 640,
	h => 400,
	dt => 0.02,
	exit_on_quit => 1,
);
my @nodes = ();
my @wires = ();
my @node_colors = (
	0xffffffff,
);
my @lastclick = ();

$app->add_event_handler(\&onClick);

$app->add_move_handler(\&onRender);

$app->run();

sub onRender
{
	$app->draw_rect( [0, 0, $app->w, $app->h], 0x000000ff);

	foreach my $pair (@wires) {
		$$pair[1]->draw_xy($app);
	}
	foreach my $pair (@nodes) {
		$app->draw_rect($$pair[1], $node_colors[$$pair[0]->id] );
	}

	$app->update();
}
sub onClick
{
	my $event = shift;

	if ($event->type() == SDL_MOUSEBUTTONDOWN) {
		if ($event->button_button == SDL_BUTTON_RIGHT) {
			addNode($event->button_x, $event->button_y);
		} elsif ($event->button_button == SDL_BUTTON_LEFT) {
			@lastclick = ($event->button_x, $event->button_y);
		}
	} elsif ($event->type() == SDL_MOUSEBUTTONUP) {
		if ($event->button_button == SDL_BUTTON_LEFT) {
			addWire($lastclick[0], $lastclick[1],
				$event->button_x, $event->button_y);		
		}
	}
}

sub addNode
{
	my ($x, $y) = @_;
	
	my $new_node = Node->new();
	my $rect = SDLx::Rect->new($x - 8, $y - 8, 16, 16);
	
	#my $x2 = $rect->x(); #
	#my $y2 = $rect->y(); #
	#print "($x2, $y2)\n"; #
	push @nodes, [$new_node, $rect];
}
sub addWire
{
	my ($x1, $y1, $x2, $y2) = @_;
	return if ($x1 == $x2 && $y1 == $y2);
	print "($x1, $y1), ($x2, $y2)\n"; #

	my $p1 = searchNodeAt($x1, $y1);
	my $p2 = searchNodeAt($x2, $y2);
	return if (not (defined $p1 && defined $p2) || $p1 == $p2 );
	$x1 = $$p1[1]->x + 8;
	$x2 = $$p2[1]->x + 8;
	$y1 = $$p1[1]->y + 8;
	$y2 = $$p2[1]->y + 8;

	my $new_wire = Wire->new();

	my $line = SDLx::Sprite->new(
		width => $app->w,
		height => $app->h,
		alpha_key => [0, 0, 0],
	);
	$line->x(0);
	$line->y(0);
	$line->surface->draw_rect( [0, 0, $line->w. $line->h], 0x000000ff);
	$line->surface->draw_line( [ $x1, $y1], [$x2, $y2], 0x00ff00ff);
		
	push @wires, [$new_wire, $line];
}
# takes: point, returns reference to noderect pair, or [0]
sub searchNodeAt
{
	my ($x, $y) = @_;
	foreach my $pair (@nodes) {

	#my $x2 = $$pair[1]->x(); #
	#my $y2 = $$pair[1]->y(); #
	#print "-($x2, $y2)\n"; #

		if ( ($x >= $$pair[1]->x() && $x <= ($$pair[1]->x() + 16)) &&
		($y >= $$pair[1]->y() && $y <= ($$pair[1]->y() + 16)) ) {
			return $pair;
		}	
	}
	return undef;
}
