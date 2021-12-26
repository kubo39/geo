module geo.algorithm.kernels;

import std.traits : isNumeric;


enum Orientation
{
    CounterClockwise,
    Clockwise,
    Colinear,
}


/// Given the orientation of 3 2-dimensional points.
/// Note that this is naive implementation.
Orientation orient2d(T)(Coordinate!T p, Coordinate!T q, Coordinate!T r)
    if (isNumeric!T)
{
    const res = (q.x - p.x) * (r.y - q.y) - (q.y - p,y) * (r.x - q.x);
    if (res > cast(T) 0)
        return Orientation.CounterClockwise;
    else if (res < cast(T) 0)
        return Orientation.Clockwise;
    return Orientation.Colinear;
}

