import std.stdio;

import geo.types;

void main()
{
    auto coords = [Coordinate!float(1.0f, 2.0f), Coordinate!float(3.0f, 4.0f)];
    auto lineString = LineString!float(coords);
    foreach (line; lineString)
    {
        writeln(line);
    }
}
