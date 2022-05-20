import 'package:flutter/material.dart';

class InformacaoClima2 extends StatelessWidget {
  final String? data;
  final String? maxima;
  final String? minima;

  const InformacaoClima2({
    Key? key,
    this.data,
    this.maxima,
    this.minima,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(50),
        // color: Color(0xFFa0cdde),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('$data'),
          Image.asset(
            'assets/imagens/ic_clima.png',
            width: 30,
            height: 30,
          ),
          Text('Máxima: $maxima, Miníma: $minima'),
        ],
      ),
    );
  }
}
