// To parse this JSON data, do
//
//     final replyThread = replyThreadFromJson(jsonString);

import 'dart:convert';

List<ReplyThread> replyThreadFromJson(String str) => List<ReplyThread>.from(json.decode(str).map((x) => ReplyThread.fromJson(x)));

String replyThreadToJson(List<ReplyThread> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReplyThread {
    String model;
    int pk;
    Fields fields;

    ReplyThread({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ReplyThread.fromJson(Map<String, dynamic> json) => ReplyThread(
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
    int mainThread;
    String content;
    String images;
    DateTime dateCreated;
    DateTime dateUpdated;

    Fields({
        required this.person,
        required this.mainThread,
        required this.content,
        required this.images,
        required this.dateCreated,
        required this.dateUpdated,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        person: json["person"],
        mainThread: json["main_thread"],
        content: json["content"],
        images: json["images"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateUpdated: DateTime.parse(json["date_updated"]),
    );

    Map<String, dynamic> toJson() => {
        "person": person,
        "main_thread": mainThread,
        "content": content,
        "images": images,
        "date_created": dateCreated.toIso8601String(),
        "date_updated": dateUpdated.toIso8601String(),
    };
}
