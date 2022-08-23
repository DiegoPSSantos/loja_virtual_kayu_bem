import 'package:flutter_masked_text2/flutter_masked_text2.dart';

mixin StringHelper {

  static const String MSG_AJUSTES_ATUALIZADOS = 'Ajustes atualizados com sucesso!!!';
  static const String MSG_SELECT_PHOTO = 'Selecionar foto para o item';
  static const String MSG_SELECT_ORIGIN_PHOTO = 'Escolha a origem da foto';

  static const String ERROR_MSG_001 = 'Insira ao menos uma imagem';

  static const String PATH_CATEGORIA_1 = 'blusas';
  static const String PATH_CATEGORIA_2 = 'calcas';
  static const String PATH_CATEGORIA_3 = 'shorts';
  static const String PATH_CATEGORIA_4 = 'conjuntos';//conjuntos';
  static const String PATH_CATEGORIA_5 = 'vestidos';
  static const String PATH_CATEGORIA_6 = 'saias';

  static const String STATUS_PEDIDO_0 = 'Cancelado';
  static const String STATUS_PEDIDO_1 = 'Separando produto no estoque';
  static const String STATUS_PEDIDO_2 = 'Enviando produto';
  static const String STATUS_PEDIDO_3 = 'Produto Entregue';

  static final String LABEL_CATEGORIA_1 = PATH_CATEGORIA_1[0].toUpperCase() + PATH_CATEGORIA_1.substring(1);
  static final String LABEL_CATEGORIA_2 = PATH_CATEGORIA_2[0].toUpperCase() + PATH_CATEGORIA_2.substring(1);
  static final String LABEL_CATEGORIA_3 = PATH_CATEGORIA_3[0].toUpperCase() + PATH_CATEGORIA_3.substring(1);
  static final String LABEL_CATEGORIA_4 = PATH_CATEGORIA_4[0].toUpperCase() + PATH_CATEGORIA_4.substring(1);
  static final String LABEL_CATEGORIA_5 = PATH_CATEGORIA_5[0].toUpperCase() + PATH_CATEGORIA_5.substring(1);
  static final String LABEL_CATEGORIA_6 = PATH_CATEGORIA_6[0].toUpperCase() + PATH_CATEGORIA_6.substring(1);

  static const String LABEL_AVANCAR = 'Avançar';
  static const String LABEL_RECUAR = 'Recuar';
  static const String LABEL_CANCELAR = 'Cancelar';
  static const String LABEL_CONCLUIR = 'Concluir';
  static const String LABEL_CAMERA = 'Câmera';
  static const String LABEL_GALERIA = 'Galeria';

  static const String LABEL_LANCAMENTO = 'Lançamento';
  static const String LABEL_OFERTA = 'Oferta';
  static const String LABEL_NOVA_COLECAO = 'Nova Coleção';

  static const String TITULO_ADD_PRODUTO = 'Criar Produto';
  static const String TITULO_EDIT_PRODUTO = 'Editar Produto';
  static const String TITULO_EDIT_IMAGE = 'Editar Imagem';
  static const String TITULO_EDIT_IMAGE_UPPER = 'EDITAR IMAGEM';

  static const String TXT_PROD_TELA_INCIAL = 'Selecione as seções onde o produto também aparecerá na tela inicial';

  static const VAZIO = '';

  static String getValorMonetario(String valor) {
    final valorMascarado = MoneyMaskedTextController(
        initialValue: double.parse(valor), decimalSeparator: ',', precision: 2, thousandSeparator: '.');
    return valorMascarado.text;
  }
}
