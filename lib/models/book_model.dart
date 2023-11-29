import 'package:toshokan/models/author_model.dart';
import 'package:toshokan/models/category_model.dart';
import 'package:toshokan/models/publisher_model.dart';

class BookModel {
  int? id;
  int? authorId;
  int? publisherId;
  String? title;
  String? slug;
  String? isbn;
  String? description;
  String? cover;
  String? year;
  String? language;
  String? pageNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  AuthorModel? author;
  PublisherModel? publisher;
  List<CategoryModel>? categories;

  BookModel({
    this.id,
    this.authorId,
    this.publisherId,
    this.title,
    this.slug,
    this.isbn,
    this.description,
    this.cover,
    this.year,
    this.language,
    this.pageNumber,
    this.createdAt,
    this.updatedAt,
    this.author,
    this.publisher,
    this.categories,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authorId = json['author_id'];
    publisherId = json['publisher_id'];
    title = json['title'];
    slug = json['slug'];
    isbn = json['isbn'];
    description = json['description'];
    cover = json['cover'];
    year = json['year'];
    language = json['language'];
    pageNumber = json['page_number'];
    createdAt = DateTime.parse(json['created_at']).toLocal();
    updatedAt = DateTime.parse(json['updated_at']).toLocal();
    author = AuthorModel.fromJson(json['author']);
    publisher = PublisherModel.fromJson(json['publisher']);
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((value) {
        categories!.add(CategoryModel.fromJson(value));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['author_id'] = authorId;
    data['publisher_id'] = publisherId;
    data['title'] = title;
    data['slug'] = slug;
    data['isbn'] = isbn;
    data['description'] = description;
    data['cover'] = cover;
    data['year'] = year;
    data['language'] = language;
    data['page_number'] = pageNumber;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    data['author'] = author?.toJson();
    data['publisher'] = publisher?.toJson();
    if (categories != null) {
      data['categories'] = categories!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
