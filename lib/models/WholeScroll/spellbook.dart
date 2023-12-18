// To parse this JSON data, do
//
//     final scroll = scrollFromJson(jsonString);

import 'dart:convert';

List<Scroll> scrollFromJson(String str) => List<Scroll>.from(json.decode(str).map((x) => Scroll.fromJson(x)));

String scrollToJson(List<Scroll> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Scroll {
    Model model;
    int pk;
    Fields fields;

    Scroll({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Scroll.fromJson(Map<String, dynamic> json) => Scroll(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int person;
    String title;
    String imageUrl;
    String content;

    Fields({
        required this.person,
        required this.title,
        required this.imageUrl,
        required this.content,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        person: json["person"],
        title: json["title"],
        imageUrl: json["image_url"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "person": person,
        "title": title,
        "image_url": imageUrl,
        "content": content,
    };
}

enum Model {
    SPELL_BOOK_SCROLL
}

final modelValues = EnumValues({
    "spell_book.scroll": Model.SPELL_BOOK_SCROLL
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
