#!/bin/parl

$w=4;
$h=4;

for ($y=0; $y<$h; $y++)
{
	for ($x=0; $x<$w-1; $x++)
	{
		$r1 = getrouterid($x,$y);
		$r2 = getrouterid($x+1,$y);
		#print "router $r1 east -> router $r2 west\n";
		print "# horizontal channels between routers $r1 and $r2\n";
		print "rr,$r1,$r2,2,3\n";
		print "rr,$r2,$r1,3,2\n";
		#print "router $r1 east <- router $r2 west\n";
	}
}

for ($y=0; $y<$h-1; $y++)
{
	for ($x=0; $x<$w; $x++)
	{
		$r1 = getrouterid($x,$y);
		$r2 = getrouterid($x,$y+1);
		print "# vertical channels between routers $r1 and $r2\n";
		print "rr,$r1,$r2,1,0\n";
		print "rr,$r2,$r1,0,1\n";
		#print "router $r1 south -> router $r2 north\n";
		#print "router $r1 south <- router $r2 north\n";
	}
}

for ($x=0; $x<$w; $x++)
{
	$r1 = getrouterid($x,0);
	#print "router $r1 north -> terminator\n";
	print "# north terminator\n";
	print "tx,$r1,0\n";
	print "rx,$r1,0\n";
	$r1 = getrouterid($x,$h-1);
	#print "router $r1 south -> terminator\n";
	print "# south terminator\n";
	print "tx,$r1,1\n";
	print "rx,$r1,1\n";
}

for ($y=0; $y<$h; $y++)
{
	$r1 = getrouterid(0,$y);
	#print "router $r1 west -> terminator\n";
	print "# west terminator\n";
	print "tx,$r1,3\n";
	print "rx,$r1,3\n";
	$r1 = getrouterid($w-1,$y);
	#print "router $r1 east -> terminator\n";
	print "# east terminator\n";
	print "tx,$r1,2\n";
	print "rx,$r1,2\n";
}

for ($i=0; $i<$h * $w; $i++)
{
	#print "router $i local -> sink\n";
	#print "router $i local <- source\n";

	print "#source\n";
	print "sr,$i,$i,4\n";

	print "#sink\n";
	print "rs,$i,4,$i\n";

}

sub getrouterid
{
	4 * $_[1] + $_[0];
}
