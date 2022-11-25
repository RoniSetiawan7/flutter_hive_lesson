import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_lesson/posts/models/constant.dart' as constant;
import 'package:hive_lesson/posts/models/post.dart';
import 'package:hive_lesson/posts/posts.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final List<Post> _listPost = [];

  @override
  void initState() {
    super.initState();
    Hive.openBox<Post>(constant.postBox).then((box) {
      _listPost.addAll(
        box.values.map((e) {
          final newPost = Post(
            e.title,
            e.author,
            e.content,
            id: e.key,
          );
          return newPost;
        }).toList(),
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posts List'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: ListView.builder(
            itemCount: _listPost.length,
            itemBuilder: ((context, index) {
              return Card(
                elevation: 3,
                child: ListTile(
                  title: Text(
                    '${_listPost[index].title}'
                    ' | ID : ${_listPost[index].id.toString()}',
                  ),
                  subtitle: Text(_listPost[index].author),
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(
                          post: _listPost[index],
                        ),
                      ),
                    );
                  }),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.orange,
                        ),
                        onPressed: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostEditScreen(
                                post: _listPost[index],
                              ),
                            ),
                          ).then((value) async {
                            _refreshData();
                          });
                        }),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await showDialog<bool?>(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Delete Post !'),
                                  content: Text(
                                    'Are you sure want to delete ${_listPost[index].title} ?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  (() {
                                                Navigator.pop(context, true);
                                              }));
                                              return const CupertinoAlertDialog(
                                                title: Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                ),
                                                content: Text(
                                                  'Post has been successfully deleted',
                                                ),
                                              );
                                            });
                                      },
                                      child: const Text('Yes'),
                                    )
                                  ],
                                );
                              }).then((result) async {
                            if (result != null && result) {
                              _deleteData(_listPost[index].id);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostAddScreen(),
              ),
            ).then((value) async {
              _refreshData();
            });
          },
          label: Row(
            children: const [
              Icon(Icons.add),
              SizedBox(width: 5),
              Text('Add Post'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  Future<void> _deleteData(int id) async {
    late Box<Post> box;
    if (Hive.isBoxOpen(constant.postBox)) {
      box = Hive.box(constant.postBox);
    } else {
      box = await Hive.openBox(constant.postBox);
    }
    await box.delete(id);
    _refreshData();
  }

  Future<void> _refreshData() async {
    late Box<Post> box;
    if (Hive.isBoxOpen(constant.postBox)) {
      box = Hive.box(constant.postBox);
    } else {
      box = await Hive.openBox(constant.postBox);
    }
    _listPost
      ..clear()
      ..addAll(box.values.map((e) {
        final newPost = Post(
          e.title,
          e.author,
          e.content,
          id: e.key,
        );
        return newPost;
      }).toList());
    setState(() {});
  }
}
