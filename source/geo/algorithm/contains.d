module geo.algorithm.contains;

import geo.types;

bool contains(T, U)(T lhs, U rhs)
    if (isGeometry!T && (isGeometry!U || is(U UU: Coordinate!real)))
{
    static if (is(T TT : Point!real))
    {
        static if (is(U UU : Coordinate!real))
        {
            return lhs.coord == rhs;
        }
        else static if (is(U UU : Point!real))
        {
            static if(is(T == Point!float) || is(T == Point!double) || is(T == Point!real))
            {
                import std.conv : to;
                import std.math.operations : isClose;
                const distance = Line!T(lhs, rhs).euclideanLength.to!float;
                return isClose(distance, 0.0f);
            }
            else
            {
                return contains(lhs, rhs.coord);
            }
        }
    }
    else static assert(false);
}

unittest
{
    const p = Point!float(1.0, 2.0);
    assert(p.contains(p));
    assert(!p.contains(-p));
}
