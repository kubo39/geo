module geo.algorithm.kernels;

import std.traits : isFloatingPoint, isIntegral;
import geo.types;

@nogc:
nothrow:
pure:
@safe:

enum Orientation
{
    CounterClockwise,
    Clockwise,
    Colinear,
}

/// Robust kernel that uses fast robust predicates for double.
Orientation orient2d(T)(Coordinate!T p, Coordinate!T q, Coordinate!T r)
    if (isFloatingPoint!T)
{
    import robust;
    const orientation = robust.orient2d(
        Coord(p.x, p.y),
        Coord(q.x, q.y),
        Coord(r.x, r.y));
    if (orientation < 0.0)
        return Orientation.Clockwise;
    else if (orientation > 0.0)
        return Orientation.CounterClockwise;
    return Orientation.Colinear;
}

/// Given the orientation of 3 2-dimensional points.
/// Note that this is naive implementation.
Orientation orient2d(T)(Coordinate!T p, Coordinate!T q, Coordinate!T r)
    if (isIntegral!T)
{
    const res = (q.x - p.x) * (r.y - q.y) - (q.y - p.y) * (r.x - q.x);
    if (res > cast(T) 0)
        return Orientation.CounterClockwise;
    else if (res < cast(T) 0)
        return Orientation.Clockwise;
    return Orientation.Colinear;
}

