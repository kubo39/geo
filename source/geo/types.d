module geo.types;

import std.traits : isNumeric;
import std.typecons : Tuple;

/// 2-dimensional Cartesian plane.
struct Coordinate(T)
    if (isNumeric!T)
{
    T x, y;

    this(T x, T y)
    {
        this.x = x;
        this.y = y;
    }

    this(Point!T point)
    {
        this(point.x, point.y);
    }

    this(Tuple!(T, T) coords)
    {
        this(coords[0], coords[1]);
    }

    this(T[2] coords)
    {
        this(coords[0], coords[1]);
    }

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
    assert(-coord == Coordinate!int([-1, -2]));
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

    this(Tuple!(T, T) coords)
    {
        this(coords[0], coords[1]);
    }

    this(T[2] coords)
    {
        this(coords[0], coords[1]);
    }

    T x() const
    {
        return coord.x;
    }

    T y() const
    {
        return coord.y;
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

    // T is a guaranteed built-in numeric type, so isFloating is enough.
    static if (__traits(isFloating, T))
    {
        import std.math : PI;

        /// Covert to degrees.
        Point!T degrees() const
        {
            return Point!T(this.x * (180.0 / PI), this.y * (180.0 / PI));
        }

        /// Convert to radians.
        Point!T radians() const
        {
            return Point!T(this.x * (PI / 180.0), this.y * (PI / 180.0));
        }
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

unittest
{
    const p = Point!float(1.0, 2.0);
    const degrees = p.degrees;
    assert(p == degrees.radians);
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
        is(X[0] T : Point!real) ||
        is(X[0] T : Line!real) ||
        is(X[0] T : LineString!real) ||
        is(X[0] T : Polygon!real);
}

static assert(!isGeometry!(Coordinate!float));
static assert(!isGeometry!float);

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
    Point!real,
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
    Line!real,
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
    LineString!real,
    Polygon!byte,
    Polygon!ubyte,
    Polygon!short,
    Polygon!ushort,
    Polygon!int,
    Polygon!uint,
    Polygon!long,
    Polygon!ulong,
    Polygon!float,
    Polygon!double,
    Polygon!real);

static foreach (T; GeometryTypeList)
    static assert(isGeometry!T);
static assert(!isGeometry!(int*));
unittest
{
    import std.complex : Complex;
    static assert(!isGeometry!(Complex!double));
}
