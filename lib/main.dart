import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const finance = "https://api.hgbrasil.com/finance?format=json&key=6c14734f";
const clima =
    "https://api.hgbrasil.com/weather?key=6c14734f&city_name=Rio%20de%20Janeiro,Rj";
//var request = Uri.https('api.hgbrasil.com', '/finance?format=json&key=6c14734f');
void main() async {
  //var response = await http.get(request);
  //print(await getFinance());
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getFinance() async {
  http.Response response = await http.get(Uri.parse(finance));
  return json.decode(response.body);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final btcController = TextEditingController();

  double dolar = 0;
  double euro = 0;
  double real = 0;
  double btc = 0;

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    real = double.parse(text);
    dolarController.text = (dolar * real).toStringAsFixed(2);
    euroController.text = (euro * real).toStringAsFixed(2);
    btcController.text = (real * this.real / btc).toStringAsFixed(15);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    btcController.text = (dolar * this.dolar / btc).toStringAsFixed(15);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    btcController.text = (euro * this.euro / btc).toStringAsFixed(15);
  }

  void _btcChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double btc = double.parse(text);
    realController.text = (btc * this.btc).toStringAsFixed(2);
    dolarController.text = (btc * this.btc / dolar).toStringAsFixed(2);
    euroController.text = (btc * this.btc / euro).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    btcController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("\$ Conversor de Moedas \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getFinance(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text(
                    "Sem conexão com a internet",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: Text(
                    "Carregando dados....",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Erro ao carregar os dados :(",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  btc = snapshot.data!["results"]["currencies"]["BTC"]["buy"];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        buildTextField(
                            "Real", "R\$: ", realController, _realChanged),
                        const Divider(),
                        buildTextField(
                            "Dolar", "US\$: ", dolarController, _dolarChanged),
                        const Divider(),
                        buildTextField(
                            "Euro", "€: ", euroController, _euroChanged),
                        const Divider(),
                        buildTextField(
                            "Bitcoin", "BTC: ", btcController, _btcChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function? f) {
  return TextField(
    controller: c,
    onChanged: f as void Function(String)?,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25,
    ),
  );
}
