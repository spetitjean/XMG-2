class A
declare ?B ?C
{
	<syn>{ node ?B; node ?C; ?B -> ?C };
	(Maybe[])
}

class Maybe
declare ?D
{
	<syn>{ node ?D }
}

value A