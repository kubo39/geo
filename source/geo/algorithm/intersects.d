module geo.algorithm.intersects;

import std.traits : isNumeric;

import geo.types;
import geo.algorithm.kernels;


@nogc:
nothrow:
pure:
@safe:

bool intersects(T)(Coordinate!T lhs, Coordinate!T rhs)
    if (isNumeric!T)
{
    return lhs == rhs;
}

unittest
{
    auto coord1 = Coordinate!float(1.0, 2.0);
    auto coord2 = Coordinate!float(4.0, 3.0);
    assert(intersects(coord1, coord1));
    assert(!intersects(coord1, coord2));
}

bool intersects(T)(Coordinate!T lhs, Point!T rhs)
    if (isNumeric!T)
{
    return lhs == rhs.coord;
}

bool intersects(T)(Point!T lhs, Coordinate!T coord)
    if (isNumeric!T)
{
    return lhs.coord.intersects(coord);
}

unittest
{
    auto point = Point!float(1.0, 2.0);
    auto coord = Coordinate!float(1.0, 2.0);
    assert(intersects(point, coord));
    assert(!intersects(point, -coord));
}


bool intersects(T)(Line!T line, Coordinate!T coord)
    if (isNumeric!T)
{
    return orient2d(line.start, line.end, coord) == Orientation.Colinear
        && pointInRectangle(coord, line.start, line.end);
}

unittest
{
    auto start = Coordinate!int(1, 2);
    auto end = Coordinate!int(3, 4);
    auto line = Line!int(start, end);
    assert(intersects(line, start));
}

private:

bool valueInRange(T)(T value, T min, T max)
{
    return value >= min && value <= max;
}

bool valueInBetween(T)(T value, T bound1, T bound2)
{
    if (bound1 < bound2)
        return valueInRange(value, bound1, bound2);
    return valueInRange(value, bound2, bound1);
}

bool pointInRectangle(T)(Coordinate!T value, Coordinate!T bound1, Coordinate!T bound2)
    if (isNumeric!T)
{
    return valueInBetween(value.x, bound1.x, bound2.x)
        && valueInBetween(value.y, bound1.y, bound2.y);
}
