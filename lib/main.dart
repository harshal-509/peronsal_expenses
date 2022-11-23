// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peronsal_expenses/modalbottomsheet.dart';
import 'package:peronsal_expenses/transaction.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartupPage(),
      routes: <String, WidgetBuilder>{
        '/screen1': (BuildContext context) => FirstPage(),
      },
      theme: ThemeData(
          fontFamily: 'PatrickHand-Regular',
          primarySwatch: Colors.brown,
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                primary: Colors.white, backgroundColor: Colors.brown),
          )),
    );
  }
}

class StartupPage extends StatelessWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "PERSONAL EXPENSES",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 191, 208, 172),
      body: Stack(fit: StackFit.expand, children: [
        FittedBox(
            fit: BoxFit.fill,
            child: Image(
                image: NetworkImage(
                    'https://images.ctfassets.net/ifu905unnj2g/4EPQDIZAwMKSAAKeEao84E/4b26cf630da967ea0d86c7581e53767c/Pie_Chart_and_Calculator_Green_Background-min.png'))),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(10),
          child: Text(
            'IT\'S YOUR \n  MONEY \n  OWN IT',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.08,
                fontWeight: FontWeight.bold),
          ),
        ),
        Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width / 2,
                      MediaQuery.of(context).size.height / 20),
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05),
                ),
                onPressed: () =>
                    Navigator.of(context).popAndPushNamed('/screen1'),
                child: Text('ENTER')))
      ]),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final List<Transaction> transactionlist = [];

  callback(String title, double amount, DateTime date) {
    setState(() {
      transactionlist.add(Transaction(
          id: DateTime.now().toString(),
          date: date,
          amount: amount,
          title: title));
    });
  }

  var orientation, size, height, width;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 191, 208, 172),
      appBar: AppBar(
        title: Center(
          child: Text(
            "PERSONAL EXPENSES",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: height * 0.1,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            alignment: Alignment.centerLeft,
            child: Center(
              child: Text(
                "Transactions",
                style: TextStyle(
                  fontSize: (height * 0.1) / 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          transactionlist.isEmpty
              ? Container(
                  height: height * 0.5,
                  width: width * 0.8,
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                    child: Column(
                      children: [
                        Icon(Icons.error),
                        Text('No transactions to show')
                      ],
                    ),
                  ))
              : Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 191, 208, 172)),
                  height: height * 0.8,
                  child: ListView.builder(
                    itemCount: transactionlist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        elevation: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    child: Text(
                                      transactionlist[index].amount.toString(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(transactionlist[index].title),
                                  Text(
                                    transactionlist[index]
                                        .date
                                        .toString()
                                        .substring(0, 10),
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              alignment: Alignment.centerRight,
                              onPressed: () {
                                setState(() {
                                  transactionlist.removeWhere((transaction) =>
                                      transaction.id ==
                                      transactionlist[index].id);
                                });
                              },
                              icon: Icon(Icons.delete),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Modalbottomsheet(
                  transaction: transactionlist,
                  callback: callback,
                );
              },
            );
          },
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
