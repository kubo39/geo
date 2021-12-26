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
    const orientation = robust.orient2d!double(
        Coord!double(cast(double) p.x, cast(double) p.y),
        Coord!double(cast(double) q.x, cast(double) q.y),
        Coord!double(cast(double) r.x, cast(double) r.y));
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

