class Account {
  final int? id;
  final String email;
  final String? createdAt;

  const Account({this.id, required this.email, this.createdAt});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      email: '${json['email'] ?? ''}',
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
