import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  String? number;
  String? holder;
  String? expirationDate;
  String? securityCode;
  String? brand;

  void setHolder(String? name) => holder = name;

  void setExpirationDate(String? date) => expirationDate = date;

  void setCVV(String? cvv) => securityCode = cvv;

  void setNumber(String? number) {
    this.number = number;
    brand = detectCCType(number!.replaceAll(' ', ''))
        .toString()
        .toUpperCase()
        .split('.')
        .last;
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': number!.replaceAll(' ', ''), // DEVE SER PASSADO SEM ESPAÇOS
      'holder': holder,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'brand': brand
    };
  }
}
