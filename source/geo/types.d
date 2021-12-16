module geo.types;

/// 2-dimensional Cartesian plane.
struct Coordinate(T)
    if (__traits(isArithmetic, T))
{
    T x, y;

    typeof(this) opUnary(string op)() const if (op == "-")
    {
        return Coordinate(-x, -y);
    }

    typeof(this) opBinary(string op)(typeof(this) other) const
    {
        static if (op == "+")
        {
            return Coordinate(this.x + other.x, this.y + other.y);
        }
        else static if (op == "-")
        {
            return Coordinate(this.x - other.x, this.y - other.y);
        }
        else static if (op == "*")
        {
            return Coordinate(this.x * other.x, this.y * other.y);
        }
        else static if (op == "/")
        {
            return Coordinate(this.x / other.x, this.y / other.y);
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
    if (__traits(isArithmetic, T))
{
    Coordinate!T start;
    Coordinate!T end;

    Coordinate!T delta() const
    {
        return end - start;
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
    if (__traits(isArithmetic, T))
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
    if (__traits(isArithmetic, T))
{
    LineString!T exterior;
    LineString!T[] interiors;
}

unittest
{
    auto lineString = LineString!float([Coordinate!float(1.0f, 2.0f), Coordinate!float(3.0f, 4.0f)]);
    auto polygon = Polygon!float(lineString, []);
}
