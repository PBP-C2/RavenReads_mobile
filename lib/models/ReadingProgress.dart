// To parse this JSON data, do
//
//     final readingProgress = readingProgressFromJson(jsonString);

import 'dart:convert';

ReadingProgress readingProgressFromJson(String str) =>
    ReadingProgress.fromJson(json.decode(str));

String readingProgressToJson(ReadingProgress data) =>
    json.encode(data.toJson());

class ReadingProgress {
  String model;
  int pk;
  Fields fields;

  ReadingProgress({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      ReadingProgress(
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
  int user;
  int book;
  String title;
  String image;
  int pages;
  int progress;
  int rating;
  String review;

  Fields({
    required this.user,
    required this.book,
    required this.title,
    required this.image,
    required this.pages,
    required this.progress,
    required this.rating,
    required this.review,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        book: json["book"],
        title: json["title"],
        image: json["image"],
        pages: json["pages"],
        progress: json["progress"],
        rating: json["rating"],
        review: json["review"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "book": book,
        "title": title,
        "image": image,
        "pages": pages,
        "progress": progress,
        "rating": rating,
        "review": review,
      };
}
