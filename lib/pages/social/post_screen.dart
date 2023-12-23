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
  List<Post> comments = [];
  ScrollController _scrollController = ScrollController();

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
      if (element.data()['parental_id'] == "") {
        final data = element.data();
        final post = Post(
          user_id: data['user_id'],
          content: data['content'],
          parental_id: data['parental_id'],
          uid: element.id,
          created_at: data['date'].toDate(),
        );
        posts.add(post);
      }
      else
      {
        final data = element.data();
        final post = Post(
          user_id: data['user_id'],
          content: data['content'],
          parental_id: data['parental_id'],
          uid: element.data()['uid'],
          created_at: element.data()['date'].toDate(),
        );
        comments.add(post);
      }
    });

    posts.sort((a, b) => a.created_at!.compareTo(b.created_at!));
    // wait .5 seconds for the scroll controller to initialize
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  void addPost(String value) {
    String userId = LocalStorageService().getUid();
    String parentalId = "";
    final post = Post(
      user_id: userId,
      content: value,
      parental_id: parentalId,
      uid: "",
      created_at: DateTime.now(),
    );
    posts.add(post);

    FirebaseFirestore.instance.collection('posts').add({
      'user_id': userId,
      'content': value,
      'parental_id': parentalId,
      'date': DateTime.now(),
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Posts', style: TextStyle(fontWeight: FontWeight.bold))),
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
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return Card(  
                          color: Color.fromARGB(255, 255, 255, 255),
                          shadowColor: Color.fromARGB(255, 0, 0, 0),
                          elevation: 3,
                          surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: FutureBuilder<String>(
                              future: ChatHelper().getUserName(posts[index].user_id),
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
                                    color: Color.fromARGB(255, 25, 184, 233),
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            subtitle: Text(posts[index].content),
                            trailing: Text("${comments.where((post) => post.parental_id == posts[index].uid).length} Comments"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                    post: posts[index],
                                  ),
                                ),
                              );
                            }),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                          labelText: 'Enter a post',
                          prefixIcon: Icon(Icons.message),
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
      if (element.data()['parental_id'] == widget.post.uid) {
        final data = element.data();
        final post = Post(
          user_id: data['user_id'],
          content: data['content'],
          parental_id: data['parental_id'],
          uid: element.data()['uid'],
          created_at: element.data()['date'].toDate(),
        );
        comments.add(post);
      }
    });

    comments.sort((a, b) => a.created_at!.compareTo(b.created_at!));
  }

  void addComment(String value) {
    String parentalId = widget.post.uid ?? "";
    final post = Post(
      user_id: LocalStorageService().getUid(),
      content: value,
      parental_id: parentalId,
      created_at: DateTime.now(),
    );

    comments.add(post);

    FirebaseFirestore.instance.collection('posts').add({
      'user_id': LocalStorageService().getUid(),
      'content': value,
      'parental_id': parentalId,
      'date': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Posts', style: TextStyle(fontWeight: FontWeight.bold))),
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
                    child: ListTile(
                            title: FutureBuilder<String>(
                              future: ChatHelper()
                                  .getUserName(widget.post.user_id),
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
                                      color: Color.fromARGB(255, 25, 184, 233)),
                                );
                              },
                            ),
                            subtitle: Text(widget.post.content)
                            ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color.fromARGB(255, 255, 255, 255),
                          shadowColor: Color.fromARGB(255, 0, 0, 0),
                          elevation: 3,
                          surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
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
                                      color: Color.fromARGB(255, 25, 184, 233)),
                                );
                              },
                            ),
                            subtitle: Text(comments[index].content),
                        )
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                          labelText: 'Enter a comment',
                          prefixIcon: Icon(Icons.message),
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