class Scroll {
  final int personId; // Assumed person ID
  final String title;
  final String imageUrl;
  final String content;

  Scroll({required this.personId, required this.title, required this.imageUrl, required this.content});

  // Metode untuk mengonversi objek Dart menjadi JSON, jika diperlukan untuk API
  Map<String, dynamic> toJson() => {
    'personId': personId,
    'title': title,
    'imageUrl': imageUrl,
    'content': content,
  };

  // Metode untuk membuat objek Scroll dari JSON, jika Anda menerima data dari API
  factory Scroll.fromJson(Map<String, dynamic> json) => Scroll(
    personId: json['personId'],
    title: json['title'],
    imageUrl: json['imageUrl'],
    content: json['content'],
  );
}
