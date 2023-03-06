import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:movel/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Movel : Mobil Travel',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        ),
        // home: LoginScreen(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => IntroScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<String> images = [
    'assets/images/sopir.png',
    'assets/images/money.png',
    'assets/images/fleksibel.png',
  ];
  final List<Map<String, String>> headings = [
    {
      "heading": "Harga Pasti dan Jelas",
      "desc":
          "Anda dapat merencanakan perjalanan dengan lebih mudah dan aman tanpa khawatir akan biaya yang tidak terduga."
    },
    {"heading": "Heading 2", "desc": "Description 2"},
    {"heading": "Heading 3", "desc": "Description 3"},
    {"heading": "Heading 4", "desc": "Description 4"},
  ];
  final CarouselController _controller = CarouselController();
  var _currentPage;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight =
        screenHeight - kToolbarHeight - kBottomNavigationBarHeight - 48;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        // color: Colors.amber,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              // height: availableHeight * .9,
              child: CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    height: double.infinity,
                    child: Column(children: [
                      Expanded(
                        flex: 8,
                        child: SizedBox(
                          height: 200,
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // SizedBox(height: 10),
                      Expanded(
                        flex: 2,
                        child: Container(
                          // height: availableHeight * 0.1,
                          // decoration: BoxDecoration(color: Colors.blue),
                          // margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                // flex: 8,
                                child: Text(
                                  headings[index]['heading']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                // flex: 2,
                                child: Text(
                                  headings[index]['desc']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  );
                },
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    // Update the current page indicator
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
            ),
            // Expanded(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: images.map((url) {
            //       int index = images.indexOf(url);
            //       return Container(
            //         width: 8.0,
            //         height: 8.0,
            //         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color:
            //               _currentPage == index ? Colors.blueAccent : Colors.grey,
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),
            // Expanded(child:CarouselSlider(
            //     items: headings
            //         .map(
            //           (text) => Container(
            //             margin: EdgeInsets.all(10),
            //             padding: EdgeInsets.all(20),
            //             decoration: BoxDecoration(
            //               color: Colors.grey[200],
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Text(
            //                   text['heading']!,
            //                   style: TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 24,
            //                   ),
            //                 ),
            //                 SizedBox(height: 10),
            //                 Text(
            //                   text['desc']!,
            //                   style: TextStyle(
            //                     fontSize: 16,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         )
            //         .toList(),
            //     options: CarouselOptions(
            //       height: 300,
            //       enlargeCenterPage: true,
            //       onPageChanged: (index, _) {
            //         setState(() {
            //           _currentPage = index;
            //         });
            //       },
            //     ),
            //   ),
            // ),
            Expanded(
              // flex: 1,
              // height: availableHeight * .2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text('Login'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => RegisterScreen()),
                    //     );
                    //   },
                    //   child: Text('Register'),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CarouselSlider(
//           items: textList
//               .map(
//                 (text) => Container(
//                   margin: EdgeInsets.all(10),
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         text['heading']!,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         text['desc']!,
//                         style: TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               .toList(),
//           options: CarouselOptions(
//             height: 300,
//             enlargeCenterPage: true,
//             onPageChanged: (index, _) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//           ),
//         ),
//         SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: textList.map((text) {
//             int index = textList.indexOf(text);
//             return Container(
//               width: 10,
//               height: 10,
//               margin: EdgeInsets.symmetric(horizontal: 5),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _currentIndex == index
//                     ? Colors.blueAccent
//                     : Colors.grey,
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     Widget page;
//     switch (selectedIndex) {
//       case 0:
//         page = GeneratorPage();
//         break;
//       case 1:
//         page = FavoritesPage();
//         break;
//       default:
//         throw UnimplementedError('no widget for $selectedIndex');
//     }
//     return LayoutBuilder(builder: (context, constraints) {
//       return Scaffold(
//         body: Row(
//           children: [
//             SafeArea(
//               child: NavigationRail(
//                 extended: constraints.maxWidth >= 600,
//                 destinations: [
//                   NavigationRailDestination(
//                     icon: Icon(Icons.home),
//                     label: Text('Home'),
//                   ),
//                   NavigationRailDestination(
//                     icon: Icon(Icons.favorite),
//                     label: Text('Favorites'),
//                   ),
//                 ],
//                 selectedIndex: selectedIndex,
//                 onDestinationSelected: (value) {
//                   setState(() {
//                     selectedIndex = value;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: Theme.of(context).colorScheme.primaryContainer,
//                 child: page,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   appState.toggleFavorite();
//                 },
//                 icon: Icon(icon),
//                 label: Text('Like'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     if (appState.favorites.isEmpty) {
//       return Center(
//         child: Text('No favorites yet.'),
//       );
//     }

//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('You have '
//               '${appState.favorites.length} favorites:'),
//         ),
//         for (var pair in appState.favorites)
//           ListTile(
//             leading: Icon(Icons.favorite),
//             title: Text(pair.asLowerCase),
//           ),
//       ],
//     );
//   }
// }

// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );
//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Text(
//           pair.asLowerCase,
//           style: style,
//           semanticsLabel: pair.asPascalCase,
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';

// import 'package:movel/screens/home.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:movel/network/api.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginController extends GetxController {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   Future<void> loginWithEmail() async {
//     var headers = {'Content-Type': 'application/json'};
//     try {
//       var url = Uri.parse(
//           ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
//       Map body = {
//         'email': emailController.text.trim(),
//         'password': passwordController.text
//       };
//       http.Response response =
//           await http.post(url, body: jsonEncode(body), headers: headers);

//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         if (json['code'] == 0) {
//           var token = json['data']['Token'];
//           final SharedPreferences? prefs = await _prefs;
//           await prefs?.setString('token', token);

//           emailController.clear();
//           passwordController.clear();
//           Get.offAll(HomeScreen());
//         } else if (json['code'] == 1) {
//           throw jsonDecode(response.body)['message'];
//         }
//       } else {
//         throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
//       }
//     } catch (error) {
//       Get.back();
//       showDialog(
//           context: Get.context!,
//           builder: (context) {
//             return SimpleDialog(
//               title: Text('Error'),
//               contentPadding: EdgeInsets.all(20),
//               children: [Text(error.toString())],
//             );
//           });
//     }
//   }
// }

class AuthState with ChangeNotifier {
  String _token = '';

  String get token => _token;

  set token(String newToken) {
    _token = newToken;
    notifyListeners();
  }
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

class AuthService {
  static const API_URL = 'https://mobiltravelapp.shym2501.repl.co/api';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$API_URL/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Save authentication data here, such as a JWT token
      final responseData = jsonDecode(response.body);
      final token = responseData['access_token'];
      AuthState()._token = token; // set the token in the state management class
      await saveToken(token); // save the token to storage

      // ... save token to state management system or storage
      return true; // Return true to indicate successful login
    } else {
      return false; // Return false to indicate failed login
    }
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  TextEditingController get emailController => _emailController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    final email = emailController.text;
    final password = _passwordController.text;

    final result = await _authService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (result) {
      Navigator.pushNamed(context, '/home');
    } else {
      // Show an error message to the user
    }
  }
}


// class LoginController {
//   final AuthService _authService = AuthService();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> login() async {
//     setState(() {
//       isLoading = true;
//     });

//     final email = emailController.text;
//     final password = passwordController.text;

//     final result = await _authService.login(email, password);

//     setState(() {
//       isLoading = false;
//     });

//     if (result) {
//       Navigator.pushNamed(context, '/home');
//     } else {
//       // Show an error message to the user
//     }
//   }
// }
