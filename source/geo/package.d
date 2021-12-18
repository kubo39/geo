module geo;

static import std.math.operations;

public import geo.types;


/// Computes whether two values are approximately equal.
bool isClose(T, U)(T lhs, U rhs)
    if (is(T TT : Coordinate!real) && is(U UU : Coordinate!real))
{
    return std.math.operations.isClose(lhs.x, rhs.x)
        && std.math.operations.isClose(lhs.y, rhs.y);
}


/// Ditto.
bool isClose(T, U, V)(T lhs, U rhs, V maxRelDiff)
    if (is(T TT : Coordinate!real) && is(U UU : Coordinate!real))
{
    return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff)
        && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff);
}

/// Ditto.
bool isClose(T, U, V)(T lhs, U rhs, V maxRelDiff, V maxAbsDiff)
    if (is(T TT : Coordinate!real) && is(U UU : Coordinate!real))
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
    else static if (is(T TT : Line!real) && is(U UU : Line!real))
    {
        return isClose(lhs.start, rhs.start)
            && isClose(lhs.end, rhs.end);
    }
    else static assert(false);
}

/// Ditto.
bool isClose(T, U, V)(T lhs, U rhs, V maxRelDiff)
    if (isGeometry!T && isGeometry!U)
{
    static if (is(T TT : Point!real) && is(U UU : Point!real))
    {
        return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff)
            && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff);
    }
    else static if (is(T TT : Line!real) && is(U UU : Line!real))
    {
        return isClose(lhs.start, rhs.start, maxRelDiff)
            && isClose(lhs.end, rhs.end, maxRelDiff);
    }
    else static assert(false);
}

/// Ditto.
bool isClose(T, U, V)(T lhs, U rhs, V maxRelDiff, V maxAbsDiff)
    if (isGeometry!T && isGeometry!U)
{
    static if (is(T TT : Point!real) && is(U UU : Point!real))
    {
        return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff, maxAbsDiff)
            && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff, maxAbsDiff);
    }
    else static if (is(T TT : Line!real) && is(U UU : Line!real))
    {
        return isClose(lhs.start, rhs.start, maxRelDiff, maxAbsDiff)
            && isClose(lhs.end, rhs.end, maxRelDiff, maxAbsDiff);
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
    auto start = Coordinate!float(1.0, 2.0);
    auto end = Coordinate!float(3.0, 4.0);
    const line = Line!float(start, end);
    assert(isClose(line, line));
    const line2 = Line!float(end, start);
    assert(!isClose(line, line2));
}
