module geo.operations;

private static import std.math.operations;
import std.traits : isFloatingPoint, isNumeric;

import geo.types;

nothrow:
pure:
@safe:

/// Computes whether two values are approximately equal.
bool isClose(T, U)(Coordinate!T lhs, Coordinate!U rhs) @nogc
    if (isNumeric!T && isNumeric!U)
{
    return std.math.operations.isClose(lhs.x, rhs.x)
        && std.math.operations.isClose(lhs.y, rhs.y);
}


/// Ditto.
bool isClose(T, U, V)(Coordinate!T lhs, Coordinate!U rhs, V maxRelDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
    return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff)
        && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff);
}

/// Ditto.
bool isClose(T, U, V)(Coordinate!T lhs, Coordinate!U rhs, V maxRelDiff, V maxAbsDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
        return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff, maxAbsDiff)
            && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff, maxAbsDiff);
}

@nogc unittest
{
    auto coord1 = Coordinate!float(1.0, 1.0);
    auto coord2 = Coordinate!float(1.0, 1.0);
    assert(isClose(coord1, coord2));
}


/// Ditto.
bool isClose(T, U)(Point!T lhs, Point!U rhs) @nogc
    if (isNumeric!T && isNumeric!U)
{
    return std.math.operations.isClose(lhs.x, rhs.x)
        && std.math.operations.isClose(lhs.y, rhs.y);
}

@nogc unittest
{
    auto point1 = Point!float(1.0, 1.0);
    auto point2 = Point!float(1.0, 1.0);
    assert(isClose(point1, point2));
}


/// Ditto.
bool isClose(T, U)(Triangle!T lhs, Triangle!U rhs) @nogc
    if (isNumeric!T && isNumeric!U)
{
    return isClose(lhs.x, rhs.x)
        && isClose(lhs.y, rhs.y)
        && isClose(lhs.z, rhs.z);
}

@nogc unittest
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


/// Ditto.
bool isClose(T, U)(Rectangle!T lhs, Rectangle!U rhs) @nogc
    if (isNumeric!T && isNumeric!U)
{
    return isClose(lhs.min, rhs.min)
        && isClose(lhs.max, rhs.max);
}

/// Ditto.
bool isClose(T, U)(Line!T lhs, Line!U rhs) @nogc
    if (isNumeric!T && isNumeric!U)
{
    return isClose(lhs.start, rhs.start)
        && isClose(lhs.end, rhs.end);
}

@nogc unittest
{
    auto start = Coordinate!float(1.0, 2.0);
    auto end = Coordinate!float(3.0, 4.0);
    const line = Line!float(start, end);
    assert(isClose(line, line));
    const line2 = Line!float(end, start);
    assert(!isClose(line, line2));
}


/// Ditto.
bool isClose(T, U)(LineString!T lhs, LineString!U rhs) @nogc
    if (isNumeric!T && isNumeric!U)
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


/// Ditto.
bool isClose(T, U)(Polygon!T lhs, Polygon!U rhs) @nogc
    if (isNumeric!T && isNumeric!U)
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


/// Ditto.
bool isClose(T, U, V)(Point!T lhs, Point!U rhs, V maxRelDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
    return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff)
        && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff);
}

/// Ditto.
bool isClose(T, U, V)(Triangle!T lhs, Triangle!U rhs, V maxRelDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
    return isClose(lhs.x, rhs.x, maxRelDiff)
        && isClose(lhs.y, rhs.y, maxRelDiff)
        && isClose(lhs.z, rhs.z, maxRelDiff);
}

/// Ditto.
bool isClose(T, U, V)(Rectangle!T lhs, Rectangle!U rhs, V maxRelDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
    return isClose(lhs.min, rhs.min, maxRelDiff)
        && isClose(lhs.max, rhs.max, maxRelDiff);
}

/// Ditto.
bool isClose(T, U, V)(Line!T lhs, Line!U rhs, V maxRelDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
    return isClose(lhs.start, rhs.start, maxRelDiff)
        && isClose(lhs.end, rhs.end, maxRelDiff);
}

/// Ditto.
bool isClose(T, U, V)(LineString!T lhs, LineString!U rhs, V maxRelDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
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

/// Ditto.
bool isClose(T, U, V)(Polygon!T lhs, Polygon!U rhs, V maxRelDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
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

/// Ditto.
bool isClose(T, U, V)(Point!T lhs, Point!U rhs, V maxRelDiff, V maxAbsDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
    return std.math.operations.isClose(lhs.x, rhs.x, maxRelDiff, maxAbsDiff)
        && std.math.operations.isClose(lhs.y, rhs.y, maxRelDiff, maxAbsDiff);
}

/// Ditto.
bool isClose(T, U, V)(Triangle!T lhs, Triangle!U rhs, V maxRelDiff, V maxAbsDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
    return isClose(lhs.x, rhs.x, maxRelDiff, maxAbsDiff)
        && isClose(lhs.y, rhs.y, maxRelDiff, maxAbsDiff)
        && isClose(lhs.z, rhs.z, maxRelDiff, maxAbsDiff);
}

/// Ditto.
bool isClose(T, U, V)(Rectangle!T lhs, Rectangle!U rhs, V maxRelDiff, V maxAbsDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
{
    return isClose(lhs.min, rhs.min, maxRelDiff, maxAbsDiff)
        && isClose(lhs.max, rhs.max, maxRelDiff, maxAbsDiff);
}

/// Ditto.
bool isClose(T, U, V)(Line!T lhs, Line!U rhs, V maxRelDiff, V maxAbsDiff) @nogc
    if (is(T TT : real) && is(U UU : real) && isFloatingPoint!V)
{
    return isClose(lhs.start, rhs.start, maxRelDiff, maxAbsDiff)
        && isClose(lhs.end, rhs.end, maxRelDiff, maxAbsDiff);
}

/// Ditto.
bool isClose(T, U, V)(LineString!T lhs, LineString!U rhs, V maxRelDiff, V maxAbsDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
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

/// Ditto.
bool isClose(T, U, V)(Polygon!T lhs, Polygon!U rhs, V maxRelDiff, V maxAbsDiff) @nogc
    if (isNumeric!T && isNumeric!U && isFloatingPoint!V)
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
