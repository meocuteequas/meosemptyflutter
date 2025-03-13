class Room {
  final String name;
  final double price;
  final String image;
  final List<String> amenities;
  final int capacity;
  final String bedType;

  Room({
    required this.name,
    required this.price,
    this.image = '',
    this.amenities = const [],
    this.capacity = 2,
    this.bedType = 'King',
  });
}
