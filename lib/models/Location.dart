class Location {
  String first;
  String second;
  double flat;
  double flong;
  double slat;
  double slong;
  int timeA;
  int timeB;
  Location({
    required this.first,
    required this.second,
    required this.timeA,
    required this.timeB,
    required this.flat,
    required this.flong,
    required this.slat,
    required this.slong,
  });
  Map<String, dynamic> toJson() => {
        'first': first,
        'second': second,
        'timeA': timeA,
        'timeB': timeB,
        'flat': flat,
        'flong': flong,
        'slat': slat,
        'slong': slong,
      };
  factory Location.fromJson(Map<String, dynamic> json) => Location(
      first: json['first'],
      second: json['tsecond'],
      timeA: json['timeA'],
      timeB: json['timeB'],
      flat: json['flat'],
      flong: json['flong'],
      slat: json['slat'],
      slong: json['slong']);
}
