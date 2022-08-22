import 'package:blood_bank_system/helpers/converters.dart';
import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/pages/create_form_and_client_page.dart';
import 'package:blood_bank_system/pages/create_form_page.dart';
import 'package:blood_bank_system/services/auth_service.dart';
import 'package:blood_bank_system/services/donor_forms_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers/constant_variables.dart';
import 'helpers/statics.dart';
import 'models/client/client.dart';
import 'models/user/user.dart';
import 'pages/main_page/main_page.dart';
import 'pages/login_page.dart';
import 'services/users_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions.fromMap(firebaseConfig));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final primarySwatch = Colors.blue;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (ctx) => AuthService(),
        // ),
        ChangeNotifierProvider(
          create: (ctx) => DonorFormsService(),
        ),
      ],
      child: MaterialApp(
        title: 'Blood Bank System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: CupertinoColors.white,
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(color: primarySwatch, fontSize: 16),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
          ),
        ),
        home: StreamBuilder(
            stream: AuthService().authStateStream,
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return streamSnapshot.hasData
                    ? FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: UsersService().get(
                          Variable.currentUserId,
                        ),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            Variable.currentUser = User.fromJson(
                              snapshot.data!.data()!,
                            );
                            return const MainPage();
                          }
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        })
                    : const LogInPage();
              }
            }),
        routes: {
          MainPage.routeName: (ctx) => const MainPage(),
          LogInPage.routeName: (ctx) => const LogInPage(),
          CreateFormPage.routeName: (ctx) => const CreateFormPage(),
          CreateFormAndClientPage.routeName: (ctx) => const CreateFormAndClientPage(),
        },
      ),
    );
  }
}
