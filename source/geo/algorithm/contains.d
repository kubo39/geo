module geo.algorithm.contains;

import std.traits : isFloatingPoint, isIntegral;
import geo.types;
private import geo.algorithm;


bool contains(T, U)(Point!T lhs, Coordinate!U coord)
    if (is(T TT : real) && is(U UU: real))
{
    return lhs.coord == coord;
}

bool contains(T, U)(Point!T lhs, Point!U rhs)
    if (is(T TT : real) && isFloatingPoint!U)
{
    import std.conv : to;
    import std.math.operations : isClose;
    const distance = Line!T(lhs, rhs).euclideanLength.to!float;
    return isClose(distance, 0.0f);
}

bool contains(T, U)(Point!T lhs, Point!U rhs)
    if (is(T TT : real) && isIntegral!U)
{
    return contains(lhs, rhs.coord);
}


unittest
{
    const p = Point!float(1.0, 2.0);
    assert(p.contains(p));
    assert(!p.contains(-p));
}
