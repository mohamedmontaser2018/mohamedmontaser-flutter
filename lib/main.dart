import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'fix.dart';
import 'items.dart';
import 'login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FixProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Potato Tech Flutter Assignment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Listen to tab changes and update the state
    _tabController.addListener(() {
      setState(() {
        tab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          isScrollable: true,
          tabs: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: const Tab(
                child: Text('Login'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: const Tab(
                child: Text('Items'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: const Tab(
                child: Text('Fix'),
              ),
            ),
          ],
          onTap: (v) {
            _tabController.animateTo(v); // Added for tab changes on tap
          },
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LoginTab(),
          ItemsTab(),
          FixTab(),
        ],
      ),
    );
  }
}
