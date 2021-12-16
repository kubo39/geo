module geo.types;

import std.traits : isNumeric;

/// 2-dimensional Cartesian plane.
struct Coordinate(T)
    if (isNumeric!T)
{
    T x, y;

    typeof(this) opUnary(string op)() const if (op == "-")
    {
        return Coordinate!T(cast(T) -x, cast(T) -y);
    }

    typeof(this) opBinary(string op)(typeof(this) other) const
    {
        static if (op == "+")
        {
            return Coordinate!T(cast(T)(this.x + other.x), cast(T)(this.y + other.y));
        }
        else static if (op == "-")
        {
            return Coordinate!T(cast(T)(this.x - other.x), cast(T)(this.y - other.y));
        }
        else static if (op == "*")
        {
            return Coordinate!T(cast(T)(this.x * other.x), cast(T)(this.y * other.y));
        }
        else static if (op == "/")
        {
            return Coordinate!T(cast(T)(this.x / other.x), cast(T)(this.y / other.y));
        }
        else static assert(false, "Operator" ~ op ~ " no implemented");
    }
}

unittest
{
    const coord = Coordinate!int(1, 2);
    assert(-coord == Coordinate!int(-1, -2));
    assert(coord + coord == Coordinate!int(2, 4));
    assert(coord - coord == Coordinate!int(0, 0));
    assert(coord * coord == Coordinate!int(1, 4));
    assert(coord / coord == Coordinate!int(1, 1));
}

/// A single point in 2D space.
struct Point(T)
    if (isNumeric!T)
{
    Coordinate!T coord;

    this(T x, T y)
    {
        this.coord = Coordinate!T(x, y);
    }

    this(Coordinate!T coord)
    {
        this(coord.x, coord.y);
    }

    typeof(this) opUnary(string op)() const if (op == "-")
    {
        return Point!T(-this.coord);
    }

    typeof(this) opBinary(string op)(typeof(this) other) const
    {
        static if (op == "+")
        {
            return Point!T(this.coord + other.coord);
        }
        else static if (op == "-")
        {
            return Point!T(this.coord - other.coord);
        }
        else static if (op == "*")
        {
            return Point!T(this.coord * other.coord);
        }
        else static if (op == "/")
        {
            return Point!T(this.coord / other.coord);
        }
        else static assert(false, "Operator" ~ op ~ " no implemented");
    }

    T dot(typeof(this) other)
    {
        return cast(T)(this.coord.x * other.coord.x + this.coord.y * other.coord.y);
    }
}

unittest
{
    const p = Point!int(1, 2);
    assert(-p == Point!int(-1, -2));
    assert(p + p == Point!int(2, 4));
    assert(p - p == Point!int(0, 0));
    assert(p * p == Point!int(1, 4));
    assert(p / p == Point!int(1, 1));
}

/// A line segment made up of exactly two Coordinates.
struct Line(T)
    if (isNumeric!T)
{
    Coordinate!T start;
    Coordinate!T end;

    Coordinate!T delta() const
    {
        return this.end - this.start;
    }
}

unittest
{
    const start = Coordinate!float(1.0f, 2.0f);
    const end = Coordinate!float(3.0f, 4.0f);
    const line = Line!float(start, end);
    assert(line.delta == Coordinate!float(2.0f, 2.0f));
}

/// An ordered collection of two or more Coordinates.
struct LineString(T)
    if (isNumeric!T)
{
    Coordinate!T[] coords;
    alias coords this;

    auto lines()
    {
        import std.algorithm : map;
        import std.range : slide;
        return coords
            .slide(2)
            .map!(a => Line!T(a[0], a[1]));
    }

    bool isClosed()
    {
        return coords[0] == coords[$-1];
    }
}

unittest
{
    auto coords = [
        Coordinate!float(1.0f, 2.0f),
        Coordinate!float(3.0f, 4.0f),
        Coordinate!float(5.0f, 6.0f)
        ];
    auto lineString = LineString!float(coords);
    assert(lineString.length == 3);

    import std.array : array;
    assert(lineString.lines.array == [
               Line!float(Coordinate!float(1.0f, 2.0f), Coordinate!float(3.0f, 4.0f)),
               Line!float(Coordinate!float(3.0f, 4.0f), Coordinate!float(5.0f, 6.0f)),
               ]
        );

    assert(!lineString.isClosed);
}

/// A bounded two-dimensional area.
struct Polygon(T)
    if (isNumeric!T)
{
    LineString!T exterior;
    LineString!T[] interiors;
}

unittest
{
    auto lineString = LineString!float([Coordinate!float(1.0f, 2.0f), Coordinate!float(3.0f, 4.0f)]);
    auto polygon = Polygon!float(lineString, []);
}


/// Whether the argument is geometry types or not.
template isGeometry(X...)
    if (X.length == 1 && is(X[0]))
{
    enum isGeometry =
        is(X[0] == Point!byte) ||
        is(X[0] == Point!ubyte) ||
        is(X[0] == Point!short) ||
        is(X[0] == Point!ushort) ||
        is(X[0] == Point!int) ||
        is(X[0] == Point!uint) ||
        is(X[0] == Point!long) ||
        is(X[0] == Point!ulong) ||
        is(X[0] == Point!float) ||
        is(X[0] == Point!double) ||
        is(X[0] == Line!byte) ||
        is(X[0] == Line!ubyte) ||
        is(X[0] == Line!short) ||
        is(X[0] == Line!ushort) ||
        is(X[0] == Line!int) ||
        is(X[0] == Line!uint) ||
        is(X[0] == Line!long) ||
        is(X[0] == Line!ulong) ||
        is(X[0] == Line!float) ||
        is(X[0] == Line!double) ||
        is(X[0] == LineString!byte) ||
        is(X[0] == LineString!ubyte) ||
        is(X[0] == LineString!short) ||
        is(X[0] == LineString!ushort) ||
        is(X[0] == LineString!int) ||
        is(X[0] == LineString!uint) ||
        is(X[0] == LineString!long) ||
        is(X[0] == LineString!ulong) ||
        is(X[0] == LineString!float) ||
        is(X[0] == LineString!double) ||
        is(X[0] == Polygon!byte) ||
        is(X[0] == Polygon!ubyte) ||
        is(X[0] == Polygon!short) ||
        is(X[0] == Polygon!ushort) ||
        is(X[0] == Polygon!int) ||
        is(X[0] == Polygon!uint) ||
        is(X[0] == Polygon!long) ||
        is(X[0] == Polygon!ulong) ||
        is(X[0] == Polygon!float) ||
        is(X[0] == Polygon!double);
}

static assert(!isGeometry!(Coordinate!float));
static assert(isGeometry!(LineString!uint));
static assert(isGeometry!(Polygon!double));


private import std.meta : AliasSeq;
alias GeometryTypeList = AliasSeq!(
    Point!byte,
    Point!ubyte,
    Point!short,
    Point!ushort,
    Point!int,
    Point!uint,
    Point!long,
    Point!ulong,
    Point!float,
    Point!double,
    Line!byte,
    Line!ubyte,
    Line!short,
    Line!ushort,
    Line!int,
    Line!uint,
    Line!long,
    Line!ulong,
    Line!float,
    Line!double,
    LineString!byte,
    LineString!ubyte,
    LineString!short,
    LineString!ushort,
    LineString!int,
    LineString!uint,
    LineString!long,
    LineString!ulong,
    LineString!float,
    LineString!double,
    Polygon!byte,
    Polygon!ubyte,
    Polygon!short,
    Polygon!ushort,
    Polygon!int,
    Polygon!uint,
    Polygon!long,
    Polygon!ulong,
    Polygon!float,
    Polygon!double);

static foreach (T; GeometryTypeList)
    static assert(isGeometry!T);
