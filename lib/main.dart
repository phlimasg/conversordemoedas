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
                  return Container(
                    color: Colors.amber,
                  );
                }
            }
          }),
    );
  }
}
