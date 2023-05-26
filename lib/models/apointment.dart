class Appointment {
  final int id;
  final String date;
  final String day;
  final String time;
  final String groomingPackageName;
  final int status;
  final double price;
  final int packageId;

  Appointment({
    required this.id,
    required this.date,
    required this.day,
    required this.time,
    required this.groomingPackageName,
    required this.status,
    required this.price,
    required this.packageId
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: json['date'],
      day: json['day'],
      time: json['time'],
      groomingPackageName: json['groomingPackage']['name'],
      status: json['status'],
      price: json['groomingPackage']['price'],
      packageId: json['groomingPackage']['id']
    );
  }
}
