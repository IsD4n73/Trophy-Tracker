class TrophyModel {
  final String name;
  final String description;
  final String type;
  final String image;
  final String rarity;
  final String? guide;
  final TrophyLevel level;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'rarity': rarity,
        'image': image,
        'level': level.name,
        'guide': guide,
      };

  static TrophyLevel getLevel(String level) {
    switch (level.toLowerCase()) {
      case 'platinum':
        return TrophyLevel.platinum;
      case 'gold':
        return TrophyLevel.gold;
      case 'silver':
        return TrophyLevel.silver;
      default:
        return TrophyLevel.bronze;
    }
  }

  factory TrophyModel.fromJson(Map<String, dynamic> json) {
    return TrophyModel(
      json["name"],
      json["description"],
      json["type"],
      json["image"],
      json["rarity"],
      getLevel(json["level"]),
      json["guide"],
    );
  }

  TrophyModel(
    this.name,
    this.description,
    this.type,
    this.image,
    this.rarity,
    this.level, [
    this.guide,
  ]);

  @override
  String toString() {
    return 'TrophyModel{name: $name, description: $description, type: $type, image: $image, rarity: $rarity}';
  }
}

enum TrophyLevel {
  platinum,
  gold,
  silver,
  bronze,
}
