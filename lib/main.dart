import 'package:flutter/material.dart';
import 'package:loginui/models/user.dart';
import 'package:loginui/pages/authenticate/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginui/pages/home/navigatorBarPage.dart';
import 'package:loginui/pages/userInfo/userInfoPage.dart';
import 'package:loginui/services/auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            final user = Provider.of<MyUser?>(context);
            if (user == null) {
              return const Authenticate();
            } else {
              if (AuthService.isSignUp) {
                return const UserInfoPage();
              } else {
                return const NavigatorBarPage();
              }
            }
          },
        ),
      ),
    );
  }
}
