class Client {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;

  Client({this.id, this.name, this.email, this.phone, this.address});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
  };
}
