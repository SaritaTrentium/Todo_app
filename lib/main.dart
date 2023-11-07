import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/models/check_user_status_adapter.dart';
import 'package:todo_app/models/theme_mode_adapter.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/theme_changer_provider.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/aboutUs_screen.dart';
import 'package:todo_app/screens/home/task_complete.dart';
import 'package:todo_app/screens/home/user_profile.dart';
import 'package:todo_app/screens/home/home_screen.dart';
import 'package:todo_app/screens/info/slider.dart';
import 'package:todo_app/screens/info/upTodo.dart';
import 'package:todo_app/screens/info/welcome.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/home/search_screen.dart';
import 'package:todo_app/screens/signup_screen.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/screens/home/add_todo_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/widget/change_theme_widget.dart';
import 'providers/user_provider.dart';

Future<void> main() async {
  var logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();
  logger.d("Starting Firebase initialization");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.d("Firebase initialization completed");
  tz.initializeTimeZones();
  //await SharedPreferences.getInstance();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(UsersAdapter());
  Hive.registerAdapter(CheckUserStatusAdapter());
  Hive.registerAdapter(ThemeModeAdapter());

 // await Hive.openBox<Todo>('todos');

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
      title: StringResources.getTitle,
      debugShowCheckedModeBanner: false,
      themeMode: _themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: UpTodo(),
      routes: {
        '/todoFirst': (context) => UpTodo(),
        '/slider': (context) => SliderScreen(),
        '/welcome': (context) => Welcome(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/taskComplete': (context) => TaskComplete(),
        '/userPanel': (context) => UserPanel(),
        '/todoList': (context) => TodoListScreen(),
        '/addTodo': (context) => TodoScreen(),
        '/search': (context) => SearchScreen(),
        '/aboutUs': (context) => AboutUsScreen(),
        '/theme': (context) => ChangeThemeButtonWidget(),
      },
    );
  }
}

