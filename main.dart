import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;
// import 'package:animations/animations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Price Checker',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MainPage(),
    );
  }
}

/// reusable AppBar + Drawer
class AppScaffold extends StatelessWidget {
  final Widget body;
  final VoidCallback? onSearchTap;

  const AppScaffold({super.key, required this.body, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 73, 73, 73),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Price Checker',
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.pinkAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(onSearchTap: onSearchTap),
      body: body,
    );
  }
}

/// Drawer
class AppDrawer extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const AppDrawer({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 232, 0, 104),
                  Color.fromARGB(255, 12, 0, 24)
                ],
              ),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'App Menu',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.search_rounded, color: Colors.white),
            title: const Text('Search products',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const MainPage(),
                  transitionDuration: const Duration(milliseconds: 1000),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: rive.RiveAnimation.asset(
                            'assets/slice.riv',
                            fit: BoxFit.cover,
                          ),
                        ),
                        FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 2.0, end: 1.0)
                                .animate(animation),
                            child: child,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dataset_outlined, color: Colors.white),
            title: const Text('View products',
                style: TextStyle(color: Colors.white)),
            onTap: () => 
            { Navigator.pop(context),
              Navigator.of(context).push(
            PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => ViewProductsPage(),
  transitionDuration: const Duration(seconds: 2),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    // Page reveal animation starts in second half
    final pageReveal = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.84, 1.0, curve: Curves.linear),     //control the time where page reveal animation start 0.84 of transitionDuration
      ),
    );

    return Stack(
      children: [
        // Door animation plays automatically
        Positioned.fill(
          child: rive.RiveAnimation.asset(
            'assets/door.riv',
            fit: BoxFit.cover,
          ),
        ),
        // Page center-out reveal
        Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: pageReveal.value,
            child: ClipRect(child: child),
          ),
        ),
      ],
    );
  },
)


),}
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail, color: Colors.white),
            title:
                const Text('Contact Us', style: TextStyle(color: Colors.white)),
            onTap: () => { Navigator.pop(context),
              Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const ContactPage(),
              transitionDuration: const Duration(milliseconds: 2000),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
  // 4-second route animation, but you want the page reveal after 2 sec
  final delayedOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(0.0), weight: 1), // hold invisible for 2s
    TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 1), // fade in next 2s
  ]).animate(animation);

  final delayedScale = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(2.0), weight: 1), // stay scaled 2x for 2s
    TweenSequenceItem(tween: Tween<double>(begin: 2.0, end: 1.0), weight: 1), // then scale to 1x
  ]).animate(animation);

  return Stack(
    children: [
      Positioned.fill(
        child: Lottie.asset(
          'assets/transition.json',
          repeat: true,
          animate: true,
          width: MediaQuery.of(context).size.width,   // full screen width
  height: MediaQuery.of(context).size.height, // full screen height
  fit: BoxFit.cover,
        ),
      ),
      FadeTransition(
        opacity: delayedOpacity, // <-- use delayedOpacity
        child: ScaleTransition(
          scale: delayedScale,   // <-- use delayedScale
          child: child,
        ),
      ),
    ],
  );
},

            )),}
          ),
        ],
      ),
    );
  }
}

/// MainPage with explode + idle + search
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _showExplode = false;
  bool _showGradient = false;
  bool _showContent = false;
  bool _showHole = false;

  late rive.RiveAnimationController _idleController;
  final TextEditingController _searchController = TextEditingController();

  final Duration explodeDuration = const Duration(seconds: 3);
  final Duration fadeDuration = const Duration(seconds: 1);
  final Duration blackHoleDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _idleController = rive.SimpleAnimation('Timeline 1', autoplay: true);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      setState(() {
        _showExplode = true;
        _showGradient = false;
      });

      Future.delayed(explodeDuration, () {
        if (!mounted) return;
        setState(() {
          _showExplode = false;
          _showGradient = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            _showGradient = false;
            _showContent = true;
          });
        });
      });
    });
  }

  void _startBlackHoleAndNavigate(String query) {
  setState(() {
    _showHole = true;
    _showContent = false;
  });

  Future.delayed(blackHoleDuration, () {
    if (!mounted) return;

    // just navigate – don’t create an unused variable
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SearchResultPage(query: query), // pass query
        transitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 3.0, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onSearchTap: () => setState(() {
        _showExplode = false;
        _showGradient = false;
        _showHole = false;
        _showContent = true;
      }),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _showGradient ? 1.0 : 0.0,
            duration: fadeDuration,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 255, 38),
                    Color.fromARGB(255, 73, 73, 73)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          if (_showExplode)
            rive.RiveAnimation.asset(
              'assets/explode.riv',
              fit: BoxFit.cover,
            ),
          AnimatedOpacity(
            opacity: _showContent ? 1.0 : 0.0,
            duration: fadeDuration,
            child: Stack(
              children: [
                rive.RiveAnimation.asset(
                  'assets/idleanimation.riv',
                  fit: BoxFit.cover,
                  controllers: [_idleController],
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Searching Anything?',
                        style: GoogleFonts.lobster(
                          textStyle: const TextStyle(
                              fontSize: 30, color: Colors.deepOrange),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 300,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 3))
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (value) {
                            _startBlackHoleAndNavigate(value);
                          },
                          decoration: const InputDecoration(
                            hintText: "Search products",
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.teal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showHole)
            Center(
              child: AnimatedScale(
                scale: _showHole ? 2.0 : 0.5,
                duration: blackHoleDuration,
                child: SizedBox(
                  width: 450,
                  height: 450,
                  child: rive.RiveAnimation.asset(
                    'assets/blackholelite.riv',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Search results page
class SearchResultPage extends StatefulWidget {
  final String query; // pass the query instead of a list

  const SearchResultPage({super.key, required this.query});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  bool _loading = true;
  List<Map<String, String>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
  try {
    final response = await http.get(Uri.parse(
        'https://pricechecker-lwp8.onrender.com/search?thing=${widget.query}'));
    // decode the API response
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    // suppose your API returns {"products": [{"name": "...", "image": "..."}]}
    final apiProducts = (decoded['products'] as List)
        .map<Map<String, String>>((p) => {
              'title': p['name'].toString(),
              'market':p['Market'].toString(),
              'image': p['image'].toString(),
              'price': p['final price'].toString(),
              'stock':p['stock'].toString()
            })
        .toList();

    if (!mounted) return;
    setState(() {
      _products = apiProducts;
      _loading = false;
    });
  } catch (e) {
    // fallback demo data if API fails
    if (!mounted) return;
    setState(() {
      _products = [
        {
          'title': 'API Item 1',
          'image': 'https://via.placeholder.com/150'
        },
        {
          'title': 'API Item 2',
          'image': 'https://via.placeholder.com/150'
        },
      ];
      _loading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _loading
          ? Center(child: SizedBox(
          width: 400,
          height: 400,
          child: rive.RiveAnimation.asset(
            'assets/loading_box.riv',
            fit: BoxFit.contain,
          ),
        ),
        )
          : _products.isEmpty
              ? const Center(child: Text('No results', style: TextStyle(color: Colors.white)))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final stock = product['stock'];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.network(
                                product['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['market']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                  fontSize: 15, color: Color.fromARGB(255, 255, 140, 0)),
                            ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['price']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),                       
                          if (stock != null && stock.isNotEmpty&&stock.toString().toLowerCase() != 'null')
                            Text(
                              product['stock']!,
                              style: const TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class ViewProductsPage extends StatefulWidget {
  const ViewProductsPage({super.key});

  @override
  State<ViewProductsPage> createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {
  bool _loading = true;
  List<Map<String, String>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
  try {
    final response = await http.get(Uri.parse(
        'https://pricechecker-lwp8.onrender.com/products'));
    // decode the API response
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    // suppose your API returns {"products": [{"name": "...", "image": "..."}]}
    final apiProducts = (decoded['products'] as List)
        .map<Map<String, String>>((p) => {
              'title': p['name'].toString(),
              'market':p['Market'].toString(),
              'image': p['image'].toString(),
              'price': p['final price'].toString(),
              'stock':p['stock'].toString()
            })
        .toList();

    if (!mounted) return;
    setState(() {
      _products = apiProducts;
      _loading = false;
    });
  } catch (e) {
    // fallback demo data if API fails
    if (!mounted) return;
    setState(() {
      _products = [
        {
          'title': 'API Item 1',
          'image': 'https://via.placeholder.com/150'
        },
        {
          'title': 'API Item 2',
          'image': 'https://via.placeholder.com/150'
        },
      ];
      _loading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _loading
          ? Center(child: SizedBox(
          width: 400,
          height: 400,
          child: rive.RiveAnimation.asset(
            'assets/loading_box.riv',
            fit: BoxFit.contain,
          ),
        ),
        )
          : _products.isEmpty
              ? const Center(child: Text('No results', style: TextStyle(color: Colors.white)))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final stock = product['stock'];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.network(
                                product['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['market']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                  fontSize: 15, color: Color.fromARGB(255, 255, 140, 0)),
                            ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['price']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),                       
                          if (stock != null && stock.isNotEmpty&&stock.toString().toLowerCase() != 'null')
                            Text(
                              product['stock']!,
                              style: const TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          // Background animation sits behind everything
          Positioned.fill(
            child: Align(
    alignment: const Alignment(-1.0, -0.8),
            child: Opacity(
    opacity: 0.5,
            child: Lottie.asset(
              'assets/background.json',
              fit: BoxFit.cover,
              repeat: true,
            ),))
          ),
          Center(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(height: 100),
    Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.contact_mail, color: Colors.white, size: 40),
      const SizedBox(width: 8),
      Text(
        'Gmail :\nlyneow777@gmail.com',
        style: GoogleFonts.lobster(
          textStyle: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    ],
  ),
  const SizedBox(height: 25),
    Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.code, color: Colors.white, size: 40),
      const SizedBox(width: 8),
      Text(
        'Github :\nhttps://github.com\n/Neon2077',
        style: GoogleFonts.lobster(
          textStyle: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    ],
  ),
  const SizedBox(height: 25),
  Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.list_rounded, color: Colors.white, size: 40),
      const SizedBox(width: 8),
      Text(
        'LinkedIn :\nhttps://www.linkedin.com\n/in/yong-lin-neow/',
        style: GoogleFonts.lobster(
          textStyle: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    ],
  ),
  ])
)


    ]
    )
    );
  }
}
