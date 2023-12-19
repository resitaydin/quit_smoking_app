class MyUser {
  // define
  final String uid;
  bool isNew; // Add this line

  MyUser({required this.uid, this.isNew = false});
}

class UserData {
  // define
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  // set
  UserData(
      {required this.uid,
      required this.name,
      required this.sugars,
      required this.strength});
}
