class Location {
  String first;
  String second;
  Location({
    required this.first,
    required this.second,
  });
  Map<String, dynamic> toJson() => {
        'first': first,
        'second': second,
      };
  factory Location.fromJson(Map<String, dynamic> json) => Location(
        first: json['first'],
        second: json['tsecond'],
      );
}
