class Outfit {
  final int id;
  final String name;
  final String imageUrl;
  final int items;
  final bool isAI;
  final bool isFavorite;
  final String date;

  const Outfit({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.items,
    required this.isAI,
    required this.isFavorite,
    required this.date,
  });
}
