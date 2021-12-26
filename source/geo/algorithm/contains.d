module geo.algorithm.contains;

import std.traits : isFloatingPoint, isIntegral, isNumeric;
import geo.types;
private import geo.algorithm;

@nogc:
nothrow:
pure:
@safe:

bool contains(T)(Point!T lhs, Coordinate!T coord)
    if (isNumeric!T)
{
    return lhs.coord == coord;
}

bool contains(T)(Point!T lhs, Point!T rhs)
    if (isFloatingPoint!T)
{
    import std.conv : to;
    import std.math.operations : isClose;
    const distance = Line!T(lhs, rhs).euclideanLength.to!float;
    return isClose(distance, 0.0f);
}

bool contains(T)(Point!T lhs, Point!T rhs)
    if (isIntegral!T)
{
    return contains(lhs, rhs.coord);
}


unittest
{
    const p = Point!float(1.0, 2.0);
    assert(p.contains(p));
    assert(!p.contains(-p));
}
