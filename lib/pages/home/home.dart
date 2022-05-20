// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:clima_tempo/core/constants/cidades.dart';
import 'package:clima_tempo/pages/home/components/clima.dart';
import 'package:clima_tempo/pages/home/components/informacao_clima.dart';
import 'package:clima_tempo/pages/home/components/informacao_clima2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/linha.dart';
import 'models/clima.dart';

import 'package:http/http.dart' as HTTP;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String cidadeEscolhida = cidades.first;

  var clima = Clima();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Clima Tempo'),
      //   centerTitle: true,
      // ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            opacity: 0.5,
            image: Image.asset('assets/imagens/fundo.jpg').image,
          ),
        ),
        child: FutureBuilder(
          future: _obterClima(cidadeEscolhida),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (clima == null ||
                  clima.climaNaSemana == null ||
                  clima.climaNaSemana!.isEmpty) {
                return Center(child: Text('Nehuma informção foi encontrada!'));
              }

              return Column(
                children: [
                  Center(
                    child: DropdownButton(
                      dropdownColor: Colors.grey[800],
                      borderRadius: BorderRadius.circular(50),
                      style: TextStyle(color: Colors.white),
                      value: cidadeEscolhida,
                      items: cidades
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          cidadeEscolhida = value!;
                        });
                      },
                    ),
                  ),
                  Linha(height: 2),
                  InformacaoClima(
                    cidade: clima.cidade,
                    data: clima.climaNaSemana!.elementAt(0).data,
                    descricao: clima.climaNaSemana!.elementAt(0).descricao,
                    diaDaSemana: clima.climaNaSemana!.elementAt(0).diaNaSemana,
                    maxima: clima.climaNaSemana!.elementAt(0).maxima.toString(),
                    minima: clima.climaNaSemana!.elementAt(0).minima.toString(),
                    temperatura: ', ${clima.temperatura}°',
                  ),
                  Linha(height: 2),
                  Expanded(
                    child: ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      itemCount: clima.climaNaSemana!.length,
                      itemBuilder: (context, index) {
                        if (index > 0) {
                          final climaNaSemana =
                              clima.climaNaSemana!.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: InformacaoClima2(
                              data: climaNaSemana.data,
                              maxima: climaNaSemana.maxima.toString(),
                              minima: climaNaSemana.minima.toString(),
                            ),
                          );
                          // return Padding(
                          //   padding: const EdgeInsets.all(16.0),
                          //   child: InformacaoClima(
                          //     cidade: clima.cidade,
                          //     data: climaNaSemana.data,
                          //     descricao: climaNaSemana.descricao,
                          //     diaDaSemana: climaNaSemana.diaNaSemana,
                          //     maxima: climaNaSemana.maxima.toString(),
                          //     minima: climaNaSemana.minima.toString(),
                          //     temperatura:
                          //         '${index == 0 ? ', ${clima.temperatura}°' : ''}',
                          //   ),
                          // );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child:
                    Text('Ocorreu um erro ao acessar a API: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
    );
  }

  Future<Clima> _obterClima(String cidade) async {
    final woeid = _obterWOEID(cidade);
    String url = 'https://api.hgbrasil.com/weather?woeid=$woeid';
    Map<String, String> headers = <String, String>{};
    headers.putIfAbsent('Accept', () => 'application/json');

    try {
      HTTP.Response response = await HTTP.get(
        Uri.parse(url),
        headers: headers,
      );

      clima = Clima.fromJson(json.decode(response.body)['results']);

      if (clima.climaNaSemana != null && clima.climaNaSemana!.isNotEmpty) {
        final formatadorDeData = DateFormat('dd/MM');
        if (clima.climaNaSemana!.first.data! ==
            formatadorDeData.format(DateTime.now().add(Duration(days: -1)))) {
          clima.climaNaSemana!.removeAt(0);
        }
      }

      return clima;
    } catch (e) {
      print('Ocorreu um erro: $e');
      return clima;
    }
  }

  String _obterWOEID(String cidade) {
    switch (cidade) {
      case 'Primavera do Leste, MT':
        return '457890';
      case 'Rondonópolis, MT':
        return '455907';
      case 'Campo Verde, MT':
        return '55943851';
      default:
        return '457890';
    }
  }
}
