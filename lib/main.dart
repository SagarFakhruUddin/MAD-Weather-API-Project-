import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/ui/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAD Weather',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  var isSignIn = false;
  var error = "";

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      emailController.dispose();
      passController.dispose();
      super.dispose();
    }

    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return isSignIn
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: emailController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: passController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(40)),
                        icon: Icon(Icons.lock_open_outlined),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ));
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passController.text.trim());
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            setState(() {
                              error = e.message!;
                            });
                          }
                          navigatorKey.currentState!
                              .popUntil((route) => route.isFirst);
                        },
                        label: Text('Sign In'),
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          const SizedBox(width: 5.0),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  isSignIn = false;
                                });
                              },
                              child: const Text(
                                'Signup',
                                style: TextStyle(color: Color(0xff22A45D)),
                              ))
                        ],
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: emailController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: passController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(40),
                            primary: Colors.green),
                        icon: Icon(Icons.lock_open_outlined),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ));
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passController.text.trim());
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            setState(() {
                              error = e.message!;
                            });
                          }
                          navigatorKey.currentState!
                              .popUntil((route) => route.isFirst);
                        },
                        label: const Text('Signup'),
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          const SizedBox(width: 5.0),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  isSignIn = true;
                                });
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Color(0xff22A45D)),
                              ))
                        ],
                      ),
                    ],
                  ),
                );
        }
      },
    )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
