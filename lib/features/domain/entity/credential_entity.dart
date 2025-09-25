
class CredentialEntity {
  final String uid;

  // Flags
  final bool isLogin;
  final bool isCreditCard;
  final bool isNotes;
  final bool isIdentity;
  final bool isAddress;

  // Common fields
  final String name;
  final String notes;

  // Login
  final String? username;
  final String? password;
  final String? url;

  // Credit Card
  final String? cardHolderName;
  final String? cardNumber;
  final String? cardType;
  final String? expiryDate;
  final String? pin;
  final String? postalCode;

  // Identity
  final String? firstName;
  final String? lastName;
  final String? sex;
  final String? birthday;
  final String? occupation;
  final String? company;
  final String? department;
  final String? jobTitle;
  final String? identityAddress;
  final String? email;
  final String? homePhone;
  final String? cellPhone;

  // Address
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? country;
  final String? state;

  const CredentialEntity({
    required this.uid,
    required this.name,
    this.notes = "",
    this.username,
    this.password,
    this.url,
    this.cardHolderName,
    this.cardNumber,
    this.cardType,
    this.expiryDate,
    this.pin,
    this.postalCode,
    this.firstName,
    this.lastName,
    this.sex,
    this.birthday,
    this.occupation,
    this.company,
    this.department,
    this.jobTitle,
    this.identityAddress,
    this.email,
    this.homePhone,
    this.cellPhone,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.country,
    this.state,
    this.isAddress = false,
    this.isCreditCard = false,
    this.isIdentity = false,
    this.isLogin = false,
    this.isNotes = false,
  });
}
