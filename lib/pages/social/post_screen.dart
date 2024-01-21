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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchPosts() async {
    posts = [];
    final ref = await FirebaseFirestore.instance.collection('posts').get();
    this.ref = ref;
    final docs = ref.docs;
    for (var element in docs) {
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
      } else {
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
    }

    posts.sort((a, b) => a.created_at.compareTo(b.created_at));
    // wait .5 seconds for the scroll controller to initialize
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void addPost(String value) {
    if (value.isEmpty) {
      return;
    }

    if (LocalStorageService().loadLastMessageTime() != null) {
      final lastMessageTime = LocalStorageService().loadLastMessageTime()!;
      final now = DateTime.now();
      final difference = now.difference(lastMessageTime);
      if (difference.inSeconds < 7) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Wait'),
              content: const Text('Please wait before adding another post.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }

    LocalStorageService().saveLastMessageTime(DateTime.now());

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

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  String getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final duration = now.difference(time);

    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} seconds ago';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours ago';
    } else if (duration.inDays < 7) {
      return '${duration.inDays} days ago';
    } else if (duration.inDays < 30) {
      final weeks = (duration.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (duration.inDays < 365) {
      final months = (duration.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (duration.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.green.shade700,
                Colors.green.shade400,
              ],
            ),
          ),
        ),
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
                    final post = posts[index];
                    String timeAgo = getTimeAgo(post.created_at);

                    return Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      shadowColor: const Color.fromARGB(255, 0, 0, 0),
                      elevation: 3,
                      surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: FutureBuilder<String>(
                          future: ChatHelper().getUserName(post.user_id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.content),
                            Text(
                              'Sent $timeAgo',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          "${comments.where((p) => p.parental_id == post.uid).length} Comments",
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                post: post,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter a post',
                    prefixIcon: Icon(Icons.message),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 25, 184, 233), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 25, 184, 233), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 25, 184, 233), width: 2.0),
                    ),
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
        },
      ),
    );
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
    for (var element in docs) {
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
    }

    comments.sort((a, b) => a.created_at.compareTo(b.created_at));
  }

  void addComment(String value) {
    if (value.isEmpty) {
      return;
    }

    if (LocalStorageService().loadLastMessageTime() != null) {
      final lastMessageTime = LocalStorageService().loadLastMessageTime()!;
      final now = DateTime.now();
      final difference = now.difference(lastMessageTime);
      if (difference.inSeconds < 7) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Wait'),
              content: const Text('Please wait before adding another comment.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }

    LocalStorageService().saveLastMessageTime(DateTime.now());

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
        title: const Center(
            child:
                Text('Posts', style: TextStyle(fontWeight: FontWeight.bold))),
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
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: const Color.fromARGB(255, 25, 184, 233),
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    tileColor: Colors.white, // Set tile background color
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Set tile content padding
                    title: FutureBuilder<String>(
                      future: ChatHelper().getUserName(widget.post.user_id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    subtitle: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        widget.post.content,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25), // Add horizontal padding
                      child: Card(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        elevation: 3,
                        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 87, 87, 87),
                          ),
                        ),
                        child: ListTile(
                          tileColor: const Color.fromARGB(255, 255, 255, 255), // Set list item background color
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Set list item content padding
                          title: FutureBuilder<String>(
                            future: ChatHelper().getUserName(comments[index].user_id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
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
                                ),
                              );
                            },
                          ),
                          subtitle: Text(comments[index].content),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter a comment',
                    prefixIcon: Icon(Icons.message),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 25, 184, 233),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 25, 184, 233),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 25, 184, 233),
                        width: 2.0,
                      ),
                    ),
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
        },
      ),
    );
  }
}
