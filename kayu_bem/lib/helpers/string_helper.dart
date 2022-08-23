import 'package:flutter_masked_text2/flutter_masked_text2.dart';

mixin StringHelper {

  static const String BTN_ANEXO_COMPROVANTE = 'Anexe o comprovante';

  static const String PIX_LOGO = 'assets/images/logo/pix-logo.png';
  static const String PIX_CONTA = 'assets/images/pix_conta.png';
  static const String CODIGO_QRCODE = '00020126360014BR.GOV.BCB.PIX0114+55619933205135204000053039865802BR5925Diego Patrick da Silva Sa6009SAO PAULO61080540900062110507KayuBem63045604';

  static const String COPIA_QRCODE = 'Código do QR Code copiado';

  static const String CREDIT_CARD_TYPE = 'credit_card';

  static const String BRAND_GENERIC = 'assets/images/brands/generic.svg';
  static const String BRAND_ALIPAY = 'assets/images/brands/alipay.svg';
  static const String BRAND_AMEX = 'assets/images/brands/amex.svg';
  static const String BRAND_CABAL = 'assets/images/brands/cabal.svg';
  static const String BRAND_CODE = 'assets/images/brands/code.svg';
  static const String BRAND_DINERS = 'assets/images/brands/diners.svg';
  static const String BRAND_DISCOVERY = 'assets/images/brands/discovery.svg';
  static const String BRAND_ELO = 'assets/images/brands/elo.svg';
  static const String BRAND_HIPER = 'assets/images/brands/hiper.svg';
  static const String BRAND_HIPERCARD = 'assets/images/brands/hipercard.svg';
  static const String BRAND_JCB = 'assets/images/brands/jcb.svg';
  static const String BRAND_MAESTRO = 'assets/images/brands/maestro.svg';
  static const String BRAND_MASTERCARD = 'assets/images/brands/mastercard.svg';
  static const String BRAND_MIR = 'assets/images/brands/mir.svg';
  static const String BRAND_PAYPAL = 'assets/images/brands/paypal.svg';
  static const String BRAND_UNIONPAY = 'assets/images/brands/unionpay.svg';
  static const String BRAND_VISA = 'assets/images/brands/visa.svg';

  static const String PATH_CATEGORIA_1 = 'blusas';
  static const String PATH_CATEGORIA_2 = 'calcas';
  static const String PATH_CATEGORIA_3 = 'shorts';
  static const String PATH_CATEGORIA_4 = 'conjuntos';
  static const String PATH_CATEGORIA_5 = 'vestidos';
  static const String PATH_CATEGORIA_6 = 'saias';

  static const String LABEL_CREDIT_CARD = 'Cartão de Crédito';
  static const String LABEL_PIX = 'Transferência via PIX';
  static const String LABEL_MERCADO_PAGO = 'Mercado Pago';
  static const String PUBLIC_KEY_MP = 'TEST-aab7e227-9d1f-4772-9d70-9eeb98ae1a23';
  static const String CLIENT_ID_MP = '4384031367927779';

  static const String VAZIO = '';
  static const String ESPACO = ' ';

  static const String URL_API_OCR = 'https://api.ocr.space/parse/image';

  static const String STATUS_PEDIDO_0 = 'Cancelado';
  static const String STATUS_PEDIDO_1 = 'Separando produto no estoque';
  static const String STATUS_PEDIDO_2 = 'Enviando produto';
  static const String STATUS_PEDIDO_3 = 'Produto Entregue';

  static const String CEP_ENDERECO_LOJA = '71901240';
  static const String NUMERO_ENDERECO_LOJA = '604';
  static const String COMPLEMENTO_ENDERECO_LOJA = 'Ed. Casa Bela';
  static const String REALIZAR_RETIRADA = 'Realizar a retirada';

  static String LABEL_CATEGORIA_1 = PATH_CATEGORIA_1[0].toUpperCase() + PATH_CATEGORIA_1.substring(1);
  static String LABEL_CATEGORIA_2 = PATH_CATEGORIA_2[0].toUpperCase() + PATH_CATEGORIA_2.substring(1);
  static String LABEL_CATEGORIA_3 = PATH_CATEGORIA_3[0].toUpperCase() + PATH_CATEGORIA_3.substring(1);
  static String LABEL_CATEGORIA_4 = PATH_CATEGORIA_4[0].toUpperCase() + PATH_CATEGORIA_4.substring(1);
  static String LABEL_CATEGORIA_5 = PATH_CATEGORIA_5[0].toUpperCase() + PATH_CATEGORIA_5.substring(1);
  static String LABEL_CATEGORIA_6 = PATH_CATEGORIA_6[0].toUpperCase() + PATH_CATEGORIA_6.substring(1);

  static String getValorMonetario(String valor) {
    final valorMascarado = MoneyMaskedTextController(
        initialValue: double.parse(valor), decimalSeparator: ',', precision: 2, thousandSeparator: '.');
    return valorMascarado.text;
  }

  static String getPrimeiroNome(String nome) {
    if (nome.isNotEmpty) {
      return nome.split(ESPACO).length > 0 ? nome.split(ESPACO).first : nome;
    }
    return VAZIO;
  }

  static String getUltimoNome(String nome) {
    if (nome.isNotEmpty) {
      return nome.split(ESPACO).length > 0 ? nome.split(ESPACO).last : nome;
    }
    return VAZIO;
  }
}
