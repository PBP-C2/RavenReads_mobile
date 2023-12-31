// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Model model;
  int pk;
  Fields fields;

  Book({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
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
  String isbn;
  String title;
  String author;
  int yearPublication;
  String publisher;
  String imageUrlS;
  String imageUrlM;
  String imageUrlL;

  Fields({
    required this.isbn,
    required this.title,
    required this.author,
    required this.yearPublication,
    required this.publisher,
    required this.imageUrlS,
    required this.imageUrlM,
    required this.imageUrlL,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        isbn: json["isbn"],
        title: json["title"],
        author: json["author"],
        yearPublication: json["year_publication"],
        publisher: json["publisher"],
        imageUrlS: json["image_url_s"],
        imageUrlM: json["image_url_m"],
        imageUrlL: json["image_url_l"],
      );

  Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "title": title,
        "author": author,
        "year_publication": yearPublication,
        "publisher": publisher,
        "image_url_s": imageUrlS,
        "image_url_m": imageUrlM,
        "image_url_l": imageUrlL,
      };
}

enum Model { BOOK_BOOK }

final modelValues = EnumValues({"book.book": Model.BOOK_BOOK});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}