module geo.algorithm.euclideanlength;

import std.traits : isFloatingPoint;

import geo.types;

nothrow:
pure:
@safe:

/// Calculation of its length.
auto euclideanLength(T)(Line!T line) @nogc
    if (isFloatingPoint!T)
{
    import std.math.algebraic : hypot;
    return line.dx().hypot(line.dy());
}

/// Ditto.
auto euclideanLength(T)(LineString!T linestring) @nogc
    if (isFloatingPoint!T)
{
    import std.algorithm : map, sum;
    return linestring
        .lines()
        .map!(line => line.euclideanLength)
        .sum;
}

unittest
{
    import std.math.operations : isClose;
    auto linestring = LineString!double(
        [Point!double(1.0, 1.0),
         Point!double(7.0, 1.0),
         Point!double(8.0, 1.0),
         Point!double(9.0, 1.0),
         Point!double(10.0, 1.0),
         Point!double(11.0, 1.0)]
        );
    assert(isClose(linestring.euclideanLength, 10.0));
}
