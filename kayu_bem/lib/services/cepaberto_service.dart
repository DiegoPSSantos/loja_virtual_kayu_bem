import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kayu_bem/models/cepaberto_address.dart';

const token = '04e293975a0f3a501bd983af57c01128';

class CepAbertoService {

  Future<CepAbertoAddress> encontrarEnderecoPorCep(String cep) async {
    final cepLimpo = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = 'https://www.cepaberto.com/api/v3/cep?cep=$cepLimpo';

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      print(response.data);

      if (response.data!.isEmpty) {
        return Future.error('CEP inválido');
      }

      final CepAbertoAddress endereco = CepAbertoAddress.fromMap(response.data!);

      return endereco;
    } on DioError catch (e) {
      return Future.error('Erro ao buscar o CEP');
    }
  }
}