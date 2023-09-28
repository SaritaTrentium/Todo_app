import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/pages/signup_page.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/theme_changer_provider.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  NotificationService().initialize();
  tz.initializeTimeZones();

    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(UsersAdapter());
    await Hive.openBox<Users>('users');
    await Hive.openBox<Todo>('todos');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ThemeChangerProvider()),
        ChangeNotifierProvider(create: (context) => UserModelProvider()),
        ChangeNotifierProvider(create: (context) => TodoListProvider()),
        ChangeNotifierProvider(create: (context) => TodoPageProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeChangerProvider>(context);
    final todoBox = Hive.box<Todo>('todos');
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData) {
            return LoginPage();
          }else {
            return SignUpPage();
          }
        }
      ),
    );
  }
}

