module geo.types;

import std.traits : isFloatingPoint, isNumeric;
import std.typecons : Tuple, tuple;


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

    static if (isFloatingPoint!T)
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


/// A bounded 2D area whose three verticles are defined by
/// Coordinates.
struct Triangle(T)
    if (isNumeric!T)
{
    Coordinate!T x;
    Coordinate!T y;
    Coordinate!T z;

    this(Coordinate!T x, Coordinate!T y, Coordinate!T z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    this(Coordinate!T[3] coords)
    {
        this.x = coords[0];
        this.y = coords[1];
        this.z = coords[2];
    }
}


/// An axis-aligned bounded 2D rectangle whose area is
/// defined by Coordinates.
struct Rectangle(T)
    if (isNumeric!T)
{
    Coordinate!T min;
    Coordinate!T max;

    this(Coordinate!T c1, Coordinate!T c2)
    {
        T minX, maxX, minY, maxY;
        if (c1.x < c2.x)
        {
            minX = c1.x;
            maxX = c2.x;
        }
        else
        {
            minX = c2.x;
            maxX = c1.x;
        }
        if (c1.y < c2.y)
        {
            minY = c1.y;
            maxY = c2.y;
        }
        else
        {
            minY = c2.y;
            maxY = c1.y;
        }
        this.min = Coordinate!T(minX, minY);
        this.max = Coordinate!T(maxX, maxY);
    }

    /// Returns the width of the Rectangle.
    T width()
    {
        return cast(T)(this.max.x - this.min.x);
    }

    /// Returns the height of the Rectangle.
    T height()
    {
        return cast(T)(this.max.y - this.min.y);
    }

    static if (isFloatingPoint!T)
    {
        Coordinate!T center()
        {
            return Coordinate!T(
                (this.max.x + this.min.x) / 2,
                (this.max.y + this.min.y) / 2);
        }
    }
}

unittest
{
    auto rect = Rectangle!double(
        Coordinate!double(5.0, 5.0),
        Coordinate!double(15.0, 15.0)
        );
    assert(rect.center == Coordinate!double(10.0, 10.0));
}


/// A line segment made up of exactly two Coordinates.
struct Line(T)
    if (isNumeric!T)
{
    Coordinate!T start;
    Coordinate!T end;

    this(Coordinate!T start, Coordinate!T end)
    {
        this.start = start;
        this.end = end;
    }

    this(Point!T start, Point!T end)
    {
        this.start = start.coord;
        this.end = end.coord;
    }

    Coordinate!T delta() const
    {
        return this.end - this.start;
    }

    T dx() const
    {
        return delta().x;
    }

    T dy() const
    {
        return delta().y;
    }

    Tuple!(Point!T, Point!T) points()
    {
        return tuple(Point!T(this.start), Point!T(this.end));
    }
}

unittest
{
    const start = Coordinate!float(1.0f, 2.0f);
    const end = Coordinate!float(3.0f, 4.0f);
    const line = Line!float(start, end);
    assert(line.delta == Coordinate!float(2.0f, 2.0f));
    assert(line.dx == 2.0f);
    assert(line.dy == 2.0f);
}

/// An ordered collection of two or more Coordinates.
struct LineString(T)
    if (isNumeric!T)
{
    Coordinate!T[] coords;
    alias coords this;

    this(Coordinate!T[] coords)
    {
        this.coords = coords;
    }

    this(Point!T[] points)
    {
        import std.algorithm : map;
        import std.array : array;
        this(points.map!(a => a.coord).array);
    }

    this(Line!T line)
    {
        this([line.start, line.end]);
    }

    auto lines()
    {
        import std.algorithm : map;
        import std.range : slide;
        return coords
            .slide(2)
            .map!(a => Line!T(a[0], a[1]));
    }

    /// Close the linestring.
    void close()
    {
        if (!isClosed)
        {
            assert(this.coords.length);
            this.coords ~= this.coords[0];
        }
    }

    /// Checks if the linestring is closed.
    bool isClosed()
    {
        return this.coords[0] == this.coords[$-1];
    }

    Coordinate!T opIndex(size_t index)
    {
        return this.coords[index];
    }

    Coordinate!T opIndexAssign(Coordinate!T value, size_t index)
    {
        return this.coords[index] = value;
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

    assert(lineString[0] == Coordinate!float(1.0f, 2.0f));
    lineString[0] = coords[1];
    assert(lineString[0] == Coordinate!float(3.0f, 4.0f));

    assert(!lineString.isClosed);
    lineString.close;
    assert(lineString.isClosed);
}

/// A bounded two-dimensional area.
struct Polygon(T)
    if (isNumeric!T)
{
    LineString!T exterior;
    LineString!T[] interiors;

    @disable this();

    this(LineString!T exterior, LineString!T[] interiors)
    {
        exterior.close;
        foreach (interior; interiors)
        {
            interior.close;
        }
        this.exterior = exterior;
        this.interiors = interiors;
    }
}

unittest
{
    auto lineString = LineString!float([Coordinate!float(1.0f, 2.0f), Coordinate!float(3.0f, 4.0f)]);
    auto polygon = Polygon!float(lineString, []);
    assert(polygon.exterior.isClosed);
}


/// Whether the argument is geometry types or not.
template isGeometry(X...)
    if (X.length == 1 && is(X[0]))
{
    enum isGeometry =
        is(X[0] T : Point!real) ||
        is(X[0] T : Triangle!real) ||
        is(X[0] T : Rectangle!real) ||
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
    Triangle!byte,
    Triangle!ubyte,
    Triangle!short,
    Triangle!ushort,
    Triangle!int,
    Triangle!uint,
    Triangle!long,
    Triangle!ulong,
    Triangle!float,
    Triangle!double,
    Triangle!real,
    Rectangle!byte,
    Rectangle!ubyte,
    Rectangle!short,
    Rectangle!ushort,
    Rectangle!int,
    Rectangle!uint,
    Rectangle!long,
    Rectangle!ulong,
    Rectangle!float,
    Rectangle!double,
    Rectangle!real,
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
