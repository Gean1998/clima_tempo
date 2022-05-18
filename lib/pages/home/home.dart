// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:clima_tempo/core/constants/cidades.dart';
import 'package:clima_tempo/pages/home/components/clima.dart';
import 'package:clima_tempo/pages/home/components/informacao_clima.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('Clima Tempo'),
        centerTitle: true,
      ),
      body: FutureBuilder(
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
                  diaDaSemana: clima.climaNaSemana![1].diaNaSemana,
                  data: clima.climaNaSemana![1].data,
                  descricao: clima.climaNaSemana![1].descricao,
                  maxima: clima.climaNaSemana![1].maxima.toString(),
                  minima: clima.climaNaSemana![1].minima.toString(),
                  cidade: clima.cidade,
                  temperatura: clima.temperatura.toString(),
                ),
                Linha(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InformacaoClima(
                      diaDaSemana: clima.climaNaSemana![2].diaNaSemana,
                      data: clima.climaNaSemana![2].data,
                      descricao: clima.climaNaSemana![2].descricao,
                      maxima: clima.climaNaSemana![2].maxima.toString(),
                      minima: clima.climaNaSemana![2].minima.toString(),
                      cidade: clima.cidade,
                      temperatura: '',
                    ),
                    InformacaoClima(
                      diaDaSemana: clima.climaNaSemana![3].diaNaSemana,
                      data: clima.climaNaSemana![3].data,
                      descricao: clima.climaNaSemana![3].descricao,
                      maxima: clima.climaNaSemana![3].maxima.toString(),
                      minima: clima.climaNaSemana![3].minima.toString(),
                      cidade: clima.cidade,
                      temperatura: '',
                    ),
                  ],
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
    );
  }

  Future<Clima> _obterClima(String cidade) async {
    print('Passei pelo Obter Clima!');
    final woeid = _obterWOEID(cidade);
    String url = 'https://api.hgbrasil.com/weather?woeid=$woeid';
    // Map<String, String> headers = <String, String>{};
    // headers.putIfAbsent('Accept', () => 'application/json');

    try {
      HTTP.Response response = await HTTP.get(
        Uri.parse(url),
        // headers: headers,
      );

      clima = Clima.fromJson(json.decode(response.body)['results']);
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
