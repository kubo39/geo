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

bool intersects(T)(Line!T line, Point!T point)
    if (isNumeric!T)
{
    return line.intersects(point.coord);
}

bool intersects(T)(Coordinate!T lhs, Line!T rhs)
    if (isNumeric!T)
{
    return rhs.intersects(lhs);
}

bool intersects(T)(Point!T lhs, Line!T rhs)
    if (isNumeric!T)
{
    return rhs.intersects(lhs);
}

unittest
{
    auto p0 = Point!float(2.0, 4.0);
    // vertical line
    auto line1 = Line!float(Point!float(2.0, 0.0), Point!float(2.0, 5.0));
    assert(line1.intersects(p0));
    assert(p0.intersects(line1));
    // point on line, but outside line segment
    auto line2 = Line!float(Point!float(0.0, 6.0), Point!float(1.5, 4.5));
    assert(!line2.intersects(p0));
    assert(!p0.intersects(line2));
    // point on line
    auto line3 = Line!float(Point!float(0.0, 6.0), Point!float(3.0, 3.0));
    assert(line3.intersects(p0));
    assert(p0.intersects(line3));
    // point above line with positive slope
    auto line4 = Line!float(Point!float(1.0, 2.0), Point!float(5.0, 3.0));
    assert(!line4.intersects(p0));
    assert(!p0.intersects(line4));
    // point below line with positive slope
    auto line5 = Line!float(Point!float(1.0, 5.0), Point!float(5.0, 6.0));
    assert(!line5.intersects(p0));
    assert(!p0.intersects(line5));
    // point above line with negative slope
    auto line6 = Line!float(Point!float(1.0, 2.0), Point!float(5.0, -3.0));
    assert(!line6.intersects(p0));
    assert(!p0.intersects(line6));
    // point below line with negative slope
    auto line7 = Line!float(Point!float(1.0, 6.0), Point!float(5.0, 5.0));
    assert(!line7.intersects(p0));
    assert(!p0.intersects(line7));
}

bool intersects(T)(LineString!T linestring, Coordinate!T coord)
    if (isNumeric!T)
{
    import std.algorithm : any;
    return linestring
        .lines()
        .any!(line => line.intersects(coord));
}

bool intersects(T)(LineString!T linestring, Point!T point)
    if (isNumeric!T)
{
    import std.algorithm : any;
    return linestring
        .lines()
        .any!(line => line.intersects(point));
}

bool intersects(T)(Coordinate!T lhs, LineString!T rhs)
    if (isNumeric!T)
{
    return rhs.intersects(lhs);
}

bool intersects(T)(Line!T lhs, LineString!T rhs)
    if (isNumeric!T)
{
    return rhs.intersects(lhs);
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

bool pointInRectangle(T)(Point!T value, Coordinate!T bound1, Coordinate!T bound2)
    if (isNumeric!T)
{
    return valueInBetween(value.x, bound1.x, bound2.x)
        && valueInBetween(value.y, bound1.y, bound2.y);
}
