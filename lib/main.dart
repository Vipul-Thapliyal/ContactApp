

import 'contact_exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body:
      Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget> [
             Center(
               child: Container(
                 color: Colors.blue,
                 height: 200,
                 width: 200,
                 child: ElevatedButton(
                   child: Text('Press'),
                   onPressed: () {
                     // Navigator.of(context).pushNamed(ContactScreen());
                     Navigator.push(context, MaterialPageRoute(
                       builder: (context) => ContactScreen(),
                     ),
                     );
                   },
                 ),
               ),
             ),
           ],
        ),
    );
  }
}
