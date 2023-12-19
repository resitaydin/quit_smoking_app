import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginui/services/local_storage_service.dart';
import 'chatItem.dart';
import 'chat_helper.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  QuerySnapshot<Map<String, dynamic>>? ref;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchPosts() async {
    posts = [];
    final ref = await FirebaseFirestore.instance.collection('posts').get();
    this.ref = ref;
    final docs = ref.docs;
    docs.forEach((element) {
      if (element.data()['parental_id'] == -1) {
        final data = element.data();
        final post = Post(
          user_id: data['user_id'],
          post_id: data['post_id'],
          content: data['content'],
          parental_id: data['parental_id'],
        );
        posts.add(post);
      }
    });

    posts.sort((a, b) => a.post_id.compareTo(b.post_id));
  }

  void addPost(String value) {
    String userId = LocalStorageService().getUid();
    int postId = ref!.docs.length;
    int parentalId = -1;
    final post = Post(
      user_id: userId,
      post_id: postId,
      content: value,
      parental_id: parentalId,
    );
    posts.add(post);

    FirebaseFirestore.instance.collection('posts').add({
      'user_id': userId,
      'post_id': postId,
      'content': value,
      'parental_id': parentalId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
        ),
        body: FutureBuilder(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('An error occured!'));
              }
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: FutureBuilder<String>(
                              future: ChatHelper()
                                  .getUserName(posts[index].user_id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text('An error occurred!');
                                }
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            subtitle: Text(posts[index].content),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                    post: posts[index],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter a post',
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          addPost(value);
                        });
                      },
                    ),
                  ),
                ],
              );
            }));
  }
}

class CommentScreen extends StatefulWidget {
  final Post post;

  const CommentScreen({super.key, required this.post});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Post> comments = [];
  QuerySnapshot<Map<String, dynamic>>? ref;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchComments() async {
    comments = [];
    final ref = await FirebaseFirestore.instance.collection('posts').get();
    this.ref = ref;
    final docs = ref.docs;
    docs.forEach((element) {
      if (element.data()['parental_id'] == widget.post.post_id) {
        final data = element.data();
        final post = Post(
          user_id: data['user_id'],
          post_id: data['post_id'],
          content: data['content'],
          parental_id: data['parental_id'],
        );
        comments.add(post);
      }
    });

    comments.sort((a, b) => a.post_id.compareTo(b.post_id));
  }

  void addComment(String value) {
    int postId = ref!.docs.length;
    int parentalId = widget.post.post_id;
    final post = Post(
      user_id: LocalStorageService().getUid(),
      post_id: postId,
      content: value,
      parental_id: parentalId,
    );

    comments.add(post);

    FirebaseFirestore.instance.collection('posts').add({
      'user_id': LocalStorageService().getUid(),
      'post_id': postId,
      'content': value,
      'parental_id': parentalId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
        ),
        body: FutureBuilder(
            future: fetchComments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('An error occured!'));
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.post.content),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: FutureBuilder<String>(
                            future: ChatHelper()
                                .getUserName(comments[index].user_id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Text('An error occurred!');
                              }
                              return Text(
                                snapshot.data!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          subtitle: Text(comments[index].content),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter a comment',
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          addComment(value);
                        });
                      },
                    ),
                  ),
                ],
              );
            }));
  }
}
