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

/// A collection of two or more Coordinates.
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
