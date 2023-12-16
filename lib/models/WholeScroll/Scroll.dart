// To parse this JSON data, do
//
//     final scroll = scrollFromJson(jsonString);

import 'dart:convert';

List<Scroll> scrollFromJson(String str) => List<Scroll>.from(json.decode(str).map((x) => Scroll.fromJson(x)));

String scrollToJson(List<Scroll> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Scroll {
    String model;
    int pk;
    Fields fields;

    Scroll({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Scroll.fromJson(Map<String, dynamic> json) => Scroll(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
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
