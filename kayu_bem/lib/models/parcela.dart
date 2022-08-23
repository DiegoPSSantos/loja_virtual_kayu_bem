class Parcela {

  Parcela();

  Parcela.fromMap(Map<String, dynamic> map) {
    installments = map['installments'] as num;
    installmentRate = map['installment_rate'] as num;
    discountRate = map['discount_rate'] as num;
    labels = map['labels'] as List<String>;
    installmentRateCollector = map['installment_rate_collector'] as List<String>;
    minAllowedAmount = map['min_allowed_amount'] as num;
    maxAllowedAmount = map['max_allowed_amount'] as num;
    recomendMessage = map['recomend_message'] as String;
    installmentAmount = map['intallmen_amount'] as num;
    totalAmount = map['total_amount'] as num;
    paymentMethodOptionId = map['payment_method_option_id'] as String;
  }

  num? installments;
  num? installmentRate;
  num? discountRate;
  List<String>? labels;
  List<String>? installmentRateCollector;
  num? minAllowedAmount;
  num? maxAllowedAmount;
  String? recomendMessage;
  num? installmentAmount;
  num? totalAmount;
  String? paymentMethodOptionId;
}