import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Ha313FullApp());

class Ha313FullApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  String quality = "720p";
  List favorites = [];
  String selectedLeague = "الكل";

  List matches = [
    {"home": "العراق", "away": "السعودية", "time": "21:00", "league": "تصفيات كأس العالم", "country": "العراق", "commentator": "علي الكعبي", "live": true, "score": "1-1"},
    {"home": "الزوراء", "away": "القوة الجوية", "time": "19:30", "league": "دوري نجوم العراق", "country": "العراق", "commentator": "رؤوف خليف", "live": false, "score": "VS"},
    {"home": "الهلال", "away": "النصر", "time": "20:30", "league": "دوري روشن", "country": "السعودية", "commentator": "فارس عوض", "live": true, "score": "0-0"},
    {"home": "برشلونة", "away": "ريال مدريد", "time": "22:00", "league": "الليغا", "country": "اسبانيا", "commentator": "عصام الشوالي", "live": false, "score": "VS"},
    {"home": "الشرطة", "away": "دهوك", "time": "18:00", "league": "دوري نجوم العراق", "country": "العراق", "commentator": "خليل البلوشي", "live": false, "score": "VS"},
    {"home": "مان سيتي", "away": "ارسنال", "time": "19:45", "league": "البريميرليغ", "country": "انكلترا", "commentator": "حفيظ دراجي", "live": true, "score": "2-1"},
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    loadFav();
  }

  loadFav() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() => favorites = prefs.getStringList('fav') ?? []);
  }

  toggleFav(String id) async {
    var prefs = await SharedPreferences.getInstance();
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await prefs.setStringList('fav', favorites.cast<String>());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية علم العراق مع الشهادة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade800, Colors.white, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("اشهد ان لا اله الا الله", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(height: 8),
                    Text("واشهد ان محمد رسول الله", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(height: 8),
                    Text("واشهد ان علياً ولي الله", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(height: 20),
                    Icon(Icons.flag, size: 100, color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
          // المحتوى
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.black87,
                  title: Text('HA313 - كل المباريات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  centerTitle: true,
                  bottom: TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(text: "الكل"),
                      Tab(text: "مباشر 🔴"),
                      Tab(text: "المفضلة ❤️"),
                      Tab(text: "اعدادات"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      buildMatchesList(matches),
                      buildMatchesList(matches.where((m) => m['live'] == true).toList()),
                      buildMatchesList(matches.where((m) => favorites.contains(m['home'])).toList()),
                      buildSettings(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMatchesList(List list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (c, i) {
        var m = list[i];
        bool isFav = favorites.contains(m['home']);
        return Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: m['live'] ? Colors.red : Colors.grey.shade800),
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(m['league'], style: TextStyle(fontSize: 10, color: Colors.grey)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: m['live'] ? Colors.red : Colors.grey, borderRadius: BorderRadius.circular(10)),
                  child: Text(m['live'] ? "مباشر" : m['time'], style: TextStyle(fontSize: 10)),
                ),
              ]),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(m['home'], style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  Column(
                    children: [
                      Text(m['score'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                      Text("المعلق: ${m['commentator']}", style: TextStyle(fontSize: 9, color: Colors.yellow)),
                    ],
                  ),
                  Expanded(child: Text(m['away'], style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white, size: 18), onPressed: () => toggleFav(m['home'])),
                  Text("الجودة: $quality", style: TextStyle(fontSize: 10)),
                  Icon(Icons.play_circle_fill, color: Colors.green),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSettings() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: ListView(
        children: [
          ListTile(title: Text('تغيير الجودة'), subtitle: Text(quality), trailing: DropdownButton<String>(
            value: quality,
            items: ["144p", "240p", "360p", "480p", "720p", "1080p"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => quality = v!),
          )),
          ListTile(title: Text('الدوري'), subtitle: Text(selectedLeague), trailing: DropdownButton<String>(
            value: selectedLeague,
            items: ["الكل", "العراق", "السعودية", "اسبانيا", "انكلترا"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => selectedLeague = v!),
          )),
          ListTile(title: Text('توقيت بغداد'), subtitle: Text('GMT+3 مضبوط'), trailing: Icon(Icons.access_time, color: Colors.green)),
          ListTile(title: Text('المطور: Ha313'), subtitle: Text('علم العراق - الشهادة')),
        ],
      ),
    );
  }
}