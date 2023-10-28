import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/theme_changer_provider.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/info/slider.dart';
import 'package:todo_app/screens/info/upTodo.dart';
import 'package:todo_app/screens/info/welcome.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/otp_screen.dart';
import 'package:todo_app/screens/registerWithPhone.dart';
import 'package:todo_app/screens/signup_screen.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  var logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();
  logger.d("Starting Firebase initialization");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.d("Firebase initialization completed");
  await SharedPreferences.getInstance();

  NotificationService().initialize();
  tz.initializeTimeZones();

    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(UsersAdapter());
    await Hive.openBox<Todo>('todos');

  logger.d("App Run");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ThemeChangerProvider()),
        ChangeNotifierProvider(create: (context) => UserModelProvider()),
        ChangeNotifierProvider(create: (context) => TodoListProvider()),
        ChangeNotifierProvider(create: (context) => TodoProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    late ThemeChangerProvider _themeProvider;
   _themeProvider = Provider.of<ThemeChangerProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: UpTodo(),
      // home: StreamBuilder(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return CircularProgressIndicator();
      //       } else if (snapshot.hasData) {
      //         return TodoListScreen();
      //       } else {
      //         return UpTodo();
      //       }
      //   }
      // ),
      routes: {
        '/todoFirst': (context) => UpTodo(),
        '/slider': (context) => SliderScreen(),
        '/welcome': (context) => Welcome(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/todoList': (context) => TodoListScreen(),
        '/todo': (context) => TodoScreen(),
        '/registerWithPhone': (context) => RegisterWithPhone(),
        'otp': (context) => OtpScreen(),
      },
    );
  }
}

