module geo.types;

/// 2-dimensional Cartesian plane.
struct Coordinate(T)
    if (__traits(isArithmetic, T))
{
    T x, y;

    typeof(this) opUnary(string op)() if (op == "-")
    {
        return Coordinate(-x, -y);
    }

    typeof(this) opBinary(string op)(typeof(this) other)
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
    auto coord = Coordinate!int(1, 2);
    assert(-coord == Coordinate!int(-1, -2));
    assert(coord + coord == Coordinate!int(2, 4));
    assert(coord - coord == Coordinate!int(0, 0));
    assert(coord * coord == Coordinate!int(1, 4));
    assert(coord / coord == Coordinate!int(1, 1));
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
