module geo.algorithm;

public import geo.algorithm.contains;
public import geo.algorithm.intersects;
public import geo.types;


/// Calculation of its length.
auto euclideanLength(T)(T geometry)
    if (isGeometry!T)
{
    static if (is(T TT : Line!float) || is(T TT : Line!double) || is(T TT : Line!real))
    {
        import std.math.algebraic : hypot;
        alias line = geometry;
        return line.dx().hypot(line.dy());
    }
    else static if (is(T TT : LineString!float) || is(T TT : LineString!double) || is(T TT : LineString!real))
    {
        import std.algorithm : map, sum;
        alias linestring = geometry;
        return linestring
            .lines()
            .map!(line => line.euclideanLength)
            .sum;
    }
    else static assert(false, "Not implemented yet.");
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
