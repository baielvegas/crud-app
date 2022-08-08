// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  Note({
    this.id,
    required this.name,
    required this.price,
  });

  int? id;
  String name;
  String price;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
      };

  Note copy({
    int? id,
    String? name,
    String? price,
  }) =>
      Note(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
      );
}
