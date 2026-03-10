import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // هذه الطبعة للطباعة في Debug فقط
    debugPrint(Theme.of(context).textTheme.bodyMedium?.fontFamily);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        fontFamily: 'Almarai', // الخط الأساسي
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

        // يفرض الخط على كل النصوص
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Almarai',
            ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(fontFamily: 'Almarai'),
          labelStyle: TextStyle(fontFamily: 'Almarai'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontFamily: 'Almarai'),
          ),
        ),
      ),
      builder: (context, child) {
        // يفرض الخط على كل النصوص حتى الـ const Text
        return DefaultTextStyle.merge(
          style: const TextStyle(fontFamily: 'Almarai'),
          child: child!,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // تم إزالة const ليطبق Theme على النص
            Text(
              'You have pushed the button this many times:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}