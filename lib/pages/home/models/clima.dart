class Clima {
  Clima({
    this.cidade,
    this.climaNaSemana,
    this.data,
    this.descricao,
    this.hora,
    this.temperatura,
  });

  final String? cidade;
  final int? temperatura;
  final String? data;
  final String? hora;
  final String? descricao;
  final List<ClimaNaSemana>? climaNaSemana;

  factory Clima.fromJson(Map<String, dynamic> json) => Clima(
        cidade: json['city'],
        temperatura: json['temp'],
        data: json['date'],
        hora: json['time'],
        descricao: json['description'],
        climaNaSemana: json['forecast'] == null
            ? []
            : List<ClimaNaSemana>.from(
                json['forecast'].map(
                  (climaNaSemana) => ClimaNaSemana.fromJson(climaNaSemana),
                ),
              ),
      );
}

class ClimaNaSemana {
  ClimaNaSemana({
    this.data,
    this.descricao,
    this.diaNaSemana,
    this.maxima,
    this.minima,
  });

  final String? data;
  final String? diaNaSemana;
  final int? maxima;
  final int? minima;
  final String? descricao;

  factory ClimaNaSemana.fromJson(Map<String, dynamic> json) => ClimaNaSemana(
        data: json['date'],
        diaNaSemana: json['weekday'],
        maxima: json['max'],
        minima: json['min'],
        descricao: json['description'],
      );
}
