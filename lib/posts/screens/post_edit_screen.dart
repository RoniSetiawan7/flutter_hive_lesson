import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_lesson/posts/models/constant.dart' as constant;

import 'package:hive_lesson/posts/models/post.dart';

class PostEditScreen extends StatefulWidget {
  final Post? post;

  const PostEditScreen({super.key, required this.post});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _content = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      _title.text = widget.post!.title;
      _author.text = widget.post!.author;
      _content.text = widget.post!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Post | ID : ${widget.post!.id}'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _title,
                    decoration: postInputDecoration(
                      label: 'Title',
                      hint: 'Type your title here',
                    ),
                    validator: ((titleValue) {
                      if (titleValue == null || titleValue.isEmpty) {
                        return 'Title required';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: _author,
                    decoration: postInputDecoration(
                      label: 'Author',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 10,
                    controller: _content,
                    decoration: postInputDecoration(
                      label: 'Content',
                      hint: 'Type your content here',
                    ),
                    validator: ((contentValue) {
                      if (contentValue == null || contentValue.isEmpty) {
                        return 'Content required';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(0, 50),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        late Box<Post> openBox;
                        final isOpen = Hive.isBoxOpen(constant.postBox);

                        if (isOpen) {
                          openBox = Hive.box(constant.postBox);
                        } else {
                          openBox = await Hive.openBox(constant.postBox);
                        }

                        final post = Post(
                          _title.text,
                          _author.text,
                          _content.text,
                        );

                        openBox.put(widget.post!.id, post).then((value) {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 2), (() {
                                  Navigator.pop(context, true);
                                }));
                                return const CupertinoAlertDialog(
                                  title: Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  content: Text(
                                    'Post has been successfully updated',
                                  ),
                                );
                              });
                        }).onError((error, stackTrace) {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 2), (() {
                                  Navigator.pop(context, true);
                                }));

                                return CupertinoAlertDialog(
                                  title: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  content: Text(error.toString()),
                                );
                              });
                        });
                      }
                    },
                    child: const Text('Update'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration postInputDecoration({required String label, String? hint}) {
    return InputDecoration(
      helperText: '',
      labelText: label,
      hintText: hint,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }
}
