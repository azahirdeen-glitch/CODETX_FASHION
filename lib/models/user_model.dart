

class AddressModel {
  final String id;
  final String name;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      country: map['country'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  AddressModel copyWith({
    String? id,
    String? name,
    String? street,
    String? city,
    String? state,
    String? zip,
    String? country,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PaymentCardModel {
  final String id;
  final String cardType;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final bool isDefault;

  PaymentCardModel({
    required this.id,
    required this.cardType,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardType': cardType,
      'cardNumber': cardNumber,
      'cardHolder': cardHolder,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'isDefault': isDefault,
    };
  }

  factory PaymentCardModel.fromMap(Map<String, dynamic> map) {
    return PaymentCardModel(
      id: map['id'] ?? '',
      cardType: map['cardType'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      cardHolder: map['cardHolder'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvv: map['cvv'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  PaymentCardModel copyWith({
    String? id,
    String? cardType,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    String? cvv,
    bool? isDefault,
  }) {
    return PaymentCardModel(
      id: id ?? this.id,
      cardType: cardType ?? this.cardType,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final List<AddressModel> addresses;
  final List<PaymentCardModel> paymentCards;
  final List<String> wishlist;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.addresses = const [],
    this.paymentCards = const [],
    this.wishlist = const [],
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'addresses': addresses.map((x) => x.toMap()).toList(),
      'paymentCards': paymentCards.map((x) => x.toMap()).toList(),
      'wishlist': wishlist,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      addresses: List<AddressModel>.from(
        (map['addresses'] as List<dynamic>?)?.map((x) => AddressModel.fromMap(Map<String, dynamic>.from(x))) ?? const [],
      ),
      paymentCards: List<PaymentCardModel>.from(
        (map['paymentCards'] as List<dynamic>?)?.map((x) => PaymentCardModel.fromMap(Map<String, dynamic>.from(x))) ?? const [],
      ),
      wishlist: List<String>.from(map['wishlist'] ?? const []),
    );
  }

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    List<AddressModel>? addresses,
    List<PaymentCardModel>? paymentCards,
    List<String>? wishlist,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addresses: addresses ?? this.addresses,
      paymentCards: paymentCards ?? this.paymentCards,
      wishlist: wishlist ?? this.wishlist,
    );
  }
}
