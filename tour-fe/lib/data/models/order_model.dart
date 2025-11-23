class OrderModel {
  final int id;
  final int numberOfChild;
  final int numberOfAdult;
  final String nameTourist;
  final String phoneTourist;
  final String emailTourist;
  final double total;
  final DateTime orderAt;
  final String? note;
  final int typeConfirmId;
  final String userId;
  final int tourId;
  final String? typeName;

  OrderModel({
    required this.id,
    required this.numberOfChild,
    required this.numberOfAdult,
    required this.nameTourist,
    required this.phoneTourist,
    required this.emailTourist,
    required this.total,
    required this.orderAt,
    this.note,
    required this.typeConfirmId,
    required this.userId,
    required this.tourId,
    this.typeName,
  });
  

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      numberOfChild: json["number_of_child"],
      numberOfAdult: json["number_of_adult"],
      nameTourist: json["name_tourist"],
      phoneTourist: json["phone_tourist"],
      emailTourist: json["email_tourist"],
      total: double.tryParse(json["total"].toString()) ?? 0,
      orderAt: DateTime.parse(json["order_at"]),
      note: json["note"],
      typeConfirmId: json["type_confirm_id"],
      userId: json["user_id"].toString(),
      tourId: json["tour_id"],
      typeName: json["type_name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "number_of_child": numberOfChild,
      "number_of_adult": numberOfAdult,
      "name_tourist": nameTourist,
      "phone_tourist": phoneTourist,
      "email_tourist": emailTourist,
      "total": total,
      "order_at": orderAt.toIso8601String(),
      "note": note,
      "type_confirm_id": typeConfirmId,
      "user_id": userId,
      "tour_id": tourId,
      "type_name": typeName,
    };
  }
}
