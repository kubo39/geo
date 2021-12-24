module geo.algorithm.intersects;

import geo.types;

bool intersects(T, U)(Coordinate!T lhs, Coordinate!U rhs)
    if (is(T TT : real) && is(U UU : real))
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

bool intersects(T, U)(Point!T lhs, Coordinate!U coord)
    if (is(T TT : real) && is(U UU : real))
{
    return lhs.coord.intersects(coord);
}

unittest
{
    auto point = Point!float(1.0, 2.0);
    auto coord = Coordinate!float(1.0, 2.0);
    assert(intersects(point, coord));
    assert(!intersects(point, -coord));
}
