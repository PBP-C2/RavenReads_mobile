// To parse this JSON data, do
//
//     final muggleThread = muggleThreadFromJson(jsonString);

import 'dart:convert';

List<MuggleThread> muggleThreadFromJson(String str) => List<MuggleThread>.from(json.decode(str).map((x) => MuggleThread.fromJson(x)));

String muggleThreadToJson(List<MuggleThread> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MuggleThread {
    String model;
    int pk;
    Fields fields;

    MuggleThread({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory MuggleThread.fromJson(Map<String, dynamic> json) => MuggleThread(
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
    String content;
    String images;
    int threadCount;
    DateTime dateCreated;
    DateTime dateUpdated;

    Fields({
        required this.person,
        required this.title,
        required this.content,
        required this.images,
        required this.threadCount,
        required this.dateCreated,
        required this.dateUpdated,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        person: json["person"],
        title: json["title"],
        content: json["content"],
        images: json["images"],
        threadCount: json["thread_count"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateUpdated: DateTime.parse(json["date_updated"]),
    );

    Map<String, dynamic> toJson() => {
        "person": person,
        "title": title,
        "content": content,
        "images": images,
        "thread_count": threadCount,
        "date_created": dateCreated.toIso8601String(),
        "date_updated": dateUpdated.toIso8601String(),
    };
}
