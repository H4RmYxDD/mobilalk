class Tile {
  final String id;
  final String type; // pl. '1', '2', 'D' (dragon), 'W' (wind) stb.
  final int x;       // oszlop
  final int y;       // sor
  final int z;       // réteg (0 = alap, magasabb = felül)
  bool isRemoved;

  Tile({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    this.isRemoved = false,
  });

  Tile copyWith({bool? isRemoved}) {
    return Tile(
      id: id,
      type: type,
      x: x,
      y: y,
      z: z,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }
}