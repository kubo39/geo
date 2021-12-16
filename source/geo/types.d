module geo.types;

/// 2-dimensional Cartesian plane.
struct Coordinate(T)
    if (__traits(isArithmetic, T))
{
    T x, y;
}

/// A collection of two or more Coordinates.
struct LineString(T)
    if (__traits(isArithmetic, T))
{
    Coordinate!T[] coords;
    alias coords this;
}

unittest
{
    auto coords = [Coordinate!float(1.0f, 2.0f), Coordinate!float(3.0f, 4.0f)];
    auto lineString = LineString!float(coords);
    assert(lineString.length == 2);
}

/// A bounded two-dimensional area.
struct Polygon(T)
    if (__traits(isArithmetic, T))
{
    LineString!T exterior;
    LineString!T[] interiors;
}
