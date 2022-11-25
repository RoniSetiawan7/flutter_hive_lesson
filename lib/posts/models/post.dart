import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_lesson/posts/models/constant.dart' as constant;

part 'post.g.dart';

@HiveType(typeId: constant.postTypeId)
class Post extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String content;

  final int id;

  Post(this.title, this.author, this.content, {this.id = 0});
}
