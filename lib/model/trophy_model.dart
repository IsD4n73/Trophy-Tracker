class TrophyModel {
  final String name;
  final String description;
  final String type;
  final String image;
  final String rarity;
  final String? guide;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'rarity': rarity,
        'image': image,
        'guide': guide,
      };

  factory TrophyModel.fromJson(Map<String, dynamic> json) {
    return TrophyModel(
      json["name"],
      json["description"],
      json["type"],
      json["image"],
      json["rarity"],
      json["guide"],
    );
  }

  TrophyModel(this.name, this.description, this.type, this.image, this.rarity,
      [this.guide]);

  @override
  String toString() {
    return 'TrophyModel{name: $name, description: $description, type: $type, image: $image, rarity: $rarity, guide: $guide}';
  }
}
