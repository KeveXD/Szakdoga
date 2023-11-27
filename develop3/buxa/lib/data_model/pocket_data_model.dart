class PocketDataModel {
  int? id;
  final String name;
  bool special;

  PocketDataModel({
    this.id,
    required this.name,
    this.special = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? 0,
      'name': name,
      'special': special,
    };
  }

  factory PocketDataModel.fromMap(Map<String, dynamic> map) {
    return PocketDataModel(
      id: map['id'],
      name: map['name'],
      special: map['special'] ==
          1, // Használjuk a 1-et a true és 0-t a false esetére
    );
  }
}
