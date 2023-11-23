class User {
  final int id;
  final String name;
  final Role role;
  final String jwt;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.jwt,
  });
}

class UserDTO {
  final int? id;
  final String dni;
  final String fullName;
  final String email;
  final String password;
  final String address;
  final String phone;
  final Role role;

  UserDTO({
    this.id,
    required this.dni,
    required this.fullName,
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
    required this.role,
  });

  UserDTO.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dni = json['dni'],
        fullName = json['fullName'],
        email = json['email'],
        password = json['password'],
        address = json['address'],
        phone = json['phone'],
        role = json['role'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'dni': dni,
        'fullName': fullName,
        'email': email,
        'password': password,
        'address': address,
        'phone': phone,
        'role': role.value,
      };
}

enum Role {
  user("USER"),
  employee("EMPLOYEE"),
  admin("ADMIN");

  const Role(this.value);
  final String value;
}
