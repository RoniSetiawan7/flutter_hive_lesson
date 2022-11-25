import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_lesson/posts/models/constant.dart' as constant;
import 'package:hive_lesson/posts/models/post.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({super.key});

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  final _title = TextEditingController();
  final _author = TextEditingController(text: 'Roni Setiawan');
  final _content = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Post'),
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

                        openBox.add(post).then((value) {
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
                                  content: Text(
                                    'Post has been created with id $value',
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
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  content: Text(error.toString()),
                                );
                              });
                        });
                      }
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
