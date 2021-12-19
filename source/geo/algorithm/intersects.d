module geo.algorithm.intersects;

import geo.types;

bool intersects(T, U)(T lhs, U rhs)
    if (is(T TT : Coordinate!real) && is(U UU : Coordinate!real))
{
    return lhs == rhs;
}

unittest
{
    auto coord1 = Coordinate!float(1.0, 2.0);
    auto coord2 = Coordinate!float(4.0, 3.0);
    assert(intersects(coord1, coord1));
    assert(!intersects(coord1, coord2));
}

bool intersects(T, U)(T lhs, U rhs)
    if (isGeometry!T && is(U UU : Coordinate!real))
{
    static if (is(T TT : Point!real))
    {
        return lhs.coord.intersects(rhs);
    }
    else static assert(false, "Not implemented yet.");
}

unittest
{
    auto point = Point!float(1.0, 2.0);
    auto coord = Coordinate!float(1.0, 2.0);
    assert(intersects(point, coord));
    assert(!intersects(point, -coord));
}
