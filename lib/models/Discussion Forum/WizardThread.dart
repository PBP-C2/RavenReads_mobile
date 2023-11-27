// To parse this JSON data, do
//
//     final wizardThread = wizardThreadFromJson(jsonString);

import 'dart:convert';

List<WizardThread> wizardThreadFromJson(String str) => List<WizardThread>.from(json.decode(str).map((x) => WizardThread.fromJson(x)));

String wizardThreadToJson(List<WizardThread> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WizardThread {
    String model;
    int pk;
    Fields fields;

    WizardThread({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory WizardThread.fromJson(Map<String, dynamic> json) => WizardThread(
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
