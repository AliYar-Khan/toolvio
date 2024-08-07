class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        json['x'] as String,
        (json['y'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'x': x,
        'y': y,
      };
}
