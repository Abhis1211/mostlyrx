class User {
  User({
    this.id,
    this.name,
    this.email,
    this.permanentAddress,
    this.contact,
    this.token,
    this.userStatus,
    this.password,
    this.isMachineAccept,
    this.status,
    this.latitude,
    this.longitude,
    this.documentsProvided = false,
    this.verified = 0,
    this.imageurl
  });

  int? id;
  String? name;
  String? email;
  String? permanentAddress;
  String? contact;
  String? token;
  String? userStatus;
  String? password;
  String? isMachineAccept;
  String? status;
  String? imageurl;
  double? latitude;
  double? longitude;
  bool documentsProvided;
  int verified;
  bool get isApproved => verified == 1;
  bool get isAvailable => status == 'available';

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      imageurl: json['imageurl']??null,
      name: json['name'],
      email: json['email'],
      permanentAddress: json['permanent_address'] ?? '',
      contact: json['contact'],
      token: json['_token'] ?? '',
      userStatus: json['user_status'] ?? '',
      password: json['password'],
      isMachineAccept: json['is_machine_accept'] ?? '',
      status: json['status'] ?? '',
      verified: json['verified'] ?? 0,
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      documentsProvided: json['documents_provided'] ?? false);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'permanent_address': permanentAddress,
        'contact': contact,
        '_token': token,
        'user_status': userStatus,
        'password': password,
        'is_machine_accept': isMachineAccept,
        'status': status,
        'latitude': latitude,
        'longitude': longitude,
      };
}
