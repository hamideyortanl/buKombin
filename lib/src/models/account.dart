class Account {
  final String username;
  final String email;
  final String passwordHash;
  final String salt;
  final bool isFamilyAccount;

  Account({
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.isFamilyAccount,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'passwordHash': passwordHash,
        'salt': salt,
        'isFamilyAccount': isFamilyAccount,
      };

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: (json['username'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      // Geriye dönük uyumluluk: eski kayıtlarda 'password' vardı.
      // Yeni sürümde düz metin yerine hash saklıyoruz.
      passwordHash: (json['passwordHash'] ?? json['password'] ?? '') as String,
      salt: (json['salt'] ?? '') as String,
      isFamilyAccount: (json['isFamilyAccount'] ?? false) as bool,
    );
  }
}
