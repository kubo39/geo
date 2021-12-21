module geo.operations;

private static import std.math.operations;
import std.traits : isFloatingPoint;

import geo.types;

/// Computes whether two values are approximately equal.
bool isClose(T, U)(T lhs, U rhs)
    if (is(T TT : Coordinate!real) && is(U UU : Coordinate!real))
{
    return std.math.operations.isClose(lhs.x, rhs.x)
        && std.math.operations.isClose(lhs.y, rhs.y);
}


/// Ditto.
bool isClose(T, U, V)(T lhs, U rhs, V maxRelDiff)
    if (is(T TT : Coordinate!real)
        && is(U UU : Coordinate!real)
        && isFloatingPoint!V)
{
    return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff)
        && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff);
}

/// Ditto.
bool isClose(T, U, V)(T lhs, U rhs, V maxRelDiff, V maxAbsDiff)
    if (is(T TT : Coordinate!real)
        && is(U UU : Coordinate!real)
        && isFloatingPoint!V)
{
        return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff, maxAbsDiff)
            && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff, maxAbsDiff);
}

unittest
{
    auto coord1 = Coordinate!float(1.0, 1.0);
    auto coord2 = Coordinate!float(1.0, 1.0);
    assert(isClose(coord1, coord2));
}

/// Ditto.
bool isClose(T, U)(T lhs, U rhs)
    if (isGeometry!T && isGeometry!U)
{
    static if (is(T TT : Point!real) && is(U UU : Point!real))
    {
        return std.math.operations.isClose(lhs.x, rhs.x)
            && std.math.operations.isClose(lhs.y, rhs.y);
    }
    else static if (is(T TT : Triangle!real) && is(U UU : Triangle!real))
    {
        return isClose(lhs.x, rhs.x)
            && isClose(lhs.y, rhs.y)
            && isClose(lhs.z, rhs.z);
    }
    else static if (is(T TT : Line!real) && is(U UU : Line!real))
    {
        return isClose(lhs.start, rhs.start)
            && isClose(lhs.end, rhs.end);
    }
    else static if (is(T TT : LineString!real) && is(U UU : LineString!real))
    {
        import std.range : zip;
        if (lhs.length != rhs.length)
            return false;
        foreach (tup; lhs.coords.zip(rhs.coords))
        {
            if (!isClose(tup[0], tup[1]))
                return false;
        }
        return true;
    }
    else static if (is(T TT : Polygon!real) && is(U UU : Polygon!real))
    {
        import std.range : zip;
        if (!isClose(lhs.exterior, rhs.exterior))
            return false;
        if (lhs.interiors.length != rhs.interiors.length)
            return false;
        foreach (tup; lhs.interiors.zip(rhs.interiors))
        {
            if (!isClose(tup[0], tup[1]))
                return false;
        }
        return true;
    }
    else static assert(false);
}

/// Ditto.
bool isClose(T, U, V)(T lhs, U rhs, V maxRelDiff)
    if (isGeometry!T && isGeometry!U && isFloatingPoint!V)
{
    static if (is(T TT : Point!real) && is(U UU : Point!real))
    {
        return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff)
            && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff);
    }
    else static if (is(T TT : Triangle!real) && is(U UU : Triangle!real))
    {
        return isClose(lhs.x, rhs.x, maxRelDiff)
            && isClose(lhs.y, rhs.y, maxRelDiff)
            && isClose(lhs.z, rhs.z, maxRelDiff);
    }
    else static if (is(T TT : Line!real) && is(U UU : Line!real))
    {
        return isClose(lhs.start, rhs.start, maxRelDiff)
            && isClose(lhs.end, rhs.end, maxRelDiff);
    }
    else static if (is(T TT : LineString!real) && is(U UU : LineString!real))
    {
        import std.range : zip;
        if (lhs.length != rhs.length)
            return false;
        foreach (tup; lhs.coords.zip(rhs.coords))
        {
            if (!isClose(tup[0], tup[1], maxRelDiff))
                return false;
        }
        return true;
    }
    else static if (is(T TT : Polygon!real) && is(U UU : Polygon!real))
    {
        import std.range : zip;
        if (!isClose(lhs.exterior, rhs.exterior, maxRelDiff))
            return false;
        if (lhs.interiors.length != rhs.interiors.length)
            return false;
        foreach (tup; lhs.interiors.zip(rhs.interiors))
        {
            if (!isClose(tup[0], tup[1], maxRelDiff))
                return false;
        }
        return true;
    }
    else static assert(false);
}

/// Ditto.
bool isClose(T, U, V)(T lhs, U rhs, V maxRelDiff, V maxAbsDiff)
    if (isGeometry!T && isGeometry!U && isFloatingPointV)
{
    static if (is(T TT : Point!real) && is(U UU : Point!real))
    {
        return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff, maxAbsDiff)
            && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff, maxAbsDiff);
    }
    else static if (is(T TT : Triangle!real) && is(U UU : Triangle!real))
    {
        return isClose(lhs.x, rhs.x, maxRelDiff, maxAbsDiff)
            && isClose(lhs.y, rhs.y, maxRelDiff, maxAbsDiff)
            && isClose(lhs.z, rhs.z, maxRelDiff, maxAbsDiff);
    }
    else static if (is(T TT : Line!real) && is(U UU : Line!real))
    {
        return isClose(lhs.start, rhs.start, maxRelDiff, maxAbsDiff)
            && isClose(lhs.end, rhs.end, maxRelDiff, maxAbsDiff);
    }
    else static if (is(T TT : LineString!real) && is(U UU : LineString!real))
    {
        import std.range : zip;
        if (lhs.length != rhs.length)
            return false;
        foreach (tup; lhs.coords.zip(rhs.coords))
        {
            if (!isClose(tup[0], tup[1], maxRelDiff, maxAbsDiff))
                return false;
        }
        return true;
    }
    else static if (is(T TT : Polygon!real) && is(U UU : Polygon!real))
    {
        import std.range : zip;
        if (!isClose(lhs.exterior, rhs.exterior, maxRelDiff, maxAbsDiff))
            return false;
        if (lhs.interiors.length != rhs.interiors.length)
            return false;
        foreach (tup; lhs.interiors.zip(rhs.interiors))
        {
            if (!isClose(tup[0], tup[1], maxRelDiff, maxAbsDiff))
                return false;
        }
        return true;
    }
    else static assert(false);
}

unittest
{
    auto point1 = Point!float(1.0, 1.0);
    auto point2 = Point!float(1.0, 1.0);
    assert(isClose(point1, point2));
}

unittest
{
    auto a = Triangle!float(
        Coordinate!float(0.0, 0.0),
        Coordinate!float(10.0, 10.0),
        Coordinate!float(0.0, 5.0));
    auto b = Triangle!float(
        Coordinate!float(0.0, 0.0),
        Coordinate!float(10.01, 10.0),
        Coordinate!float(0.0, 5.0));
    assert(!isClose(a, b));
    assert(isClose(a, b, 0.1));
}

unittest
{
    auto start = Coordinate!float(1.0, 2.0);
    auto end = Coordinate!float(3.0, 4.0);
    const line = Line!float(start, end);
    assert(isClose(line, line));
    const line2 = Line!float(end, start);
    assert(!isClose(line, line2));
}

unittest
{
    auto coordsA = [
        Coordinate!double(0.0, 0.0),
        Coordinate!double(5.0, 0.0),
        Coordinate!double(7.0, 0.0)
        ];
    auto a = LineString!double(coordsA);
    auto coordsB = [
        Coordinate!double(0.0, 0.0),
        Coordinate!double(5.0, 0.0),
        Coordinate!double(7.001, 0.0)
        ];
    auto b = LineString!double(coordsB);
    assert(!isClose(a, b));
    assert(isClose(a, b, 0.1));
}

unittest
{
    auto coordsA = [
        Coordinate!double(0.0, 0.0),
        Coordinate!double(5.0, 0.0),
        Coordinate!double(7.0, 9.0),
        Coordinate!double(0.0, 0.0)
        ];
    auto coordsB = [
        Coordinate!double(0.0, 0.0),
        Coordinate!double(5.0, 0.0),
        Coordinate!double(7.01, 9.0),
        Coordinate!double(0.0, 0.0)
        ];

    auto a = Polygon!double(LineString!double(coordsA), []);
    auto b = Polygon!double(LineString!double(coordsB), []);

    assert(!isClose(a, b));
    assert(isClose(a, b, 0.1));
}
