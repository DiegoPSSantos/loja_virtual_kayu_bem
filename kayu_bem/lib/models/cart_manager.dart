import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kayu_bem/models/cart_product.dart';
import 'package:kayu_bem/models/endereco.dart';
import 'package:kayu_bem/models/product.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:kayu_bem/models/usuario.dart';
import 'package:kayu_bem/services/cepaberto_service.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];
  Usuario? usuario;
  Endereco? endereco;
  num precoProdutos = 0.0;
  var precoEntrega;
  bool _loading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool get loading => _loading;

  set loading(bool valor) {
    _loading = valor;
    notifyListeners();
  }

  num get precoTotal {
    if (precoEntrega != null) {
      return precoProdutos + (precoEntrega as num);
    }
    return precoProdutos;
  }

  void atualizarUsuario(UserManager userManager) {
    items.clear();
    removerEndereco();
    precoProdutos = 0.0;

    if (userManager.usuario != null) {
      usuario = userManager.usuario!;
      _carregarItensCarrinho();
      _carregarEndereco();
    }
  }

  Future<void> _carregarItensCarrinho() async {
    final QuerySnapshot qs = await usuario!.cartRef.get();

    items = qs.docs
        .map((d) => CartProduct.fromDocument(d)..addListener(_atualizarItem))
        .toList();
  }

  Future<void> _carregarEndereco() async {
    if (usuario!.endereco != null &&
        await calcularEntrega(
            usuario!.endereco!.lat!, usuario!.endereco!.long!)) {
      endereco = usuario!.endereco;
      notifyListeners();
    }
  }

  void adicionarProdutoCarrinho(Product produto) {
    try {
      final p =
          items.firstWhere((p) => p.verificarProdutoJaAdicionado(produto));
      p.incrementar();
    } catch (e) {
      final produtoCarrinho = CartProduct.fromProduct(produto);
      produtoCarrinho.addListener(_atualizarItem);
      items.add(produtoCarrinho);
      usuario!.cartRef
          .add(produtoCarrinho.converterCarrinhoMap())
          .then((doc) => produtoCarrinho.id = doc.id);
      _atualizarItem();
    }
    notifyListeners();
  }

  void removerItemCarrinho(CartProduct cp) {
    items.removeWhere((item) => item.id!.compareTo(cp.id!) == 0);
    usuario!.cartRef.doc(cp.id).delete();
    cp.removeListener(_atualizarItem);
    notifyListeners();
  }

  void _atualizarItem() {
    precoProdutos = 0.0;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.quantidade == 0) {
        removerItemCarrinho(item);
        i--;
        continue;
      }
      precoProdutos += item.precoTotal;
      _atualizarCarrinho(item);
    }

    notifyListeners();
  }

  void _atualizarCarrinho(CartProduct cp) {
    if (cp.id != null) {
      usuario!.cartRef.doc(cp.id).update(cp.converterCarrinhoMap());
    }
  }

  bool get carrinhoValido {
    for (final cp in items) {
      if (!cp.estoqueDisponivel) return false;
    }
    return true;
  }

  bool get enderecoValido => endereco != null;

  bool get possuiEntrega => precoEntrega != null;

  Future<void> getEnderecoCepAberto(String cep) async {
    loading = true;
    final cepAbertoService = CepAbertoService();

    try {
      final cepAbertoEndereco =
          await cepAbertoService.encontrarEnderecoPorCep(cep);

      endereco = Endereco(
          rua: cepAbertoEndereco.logradouro,
          bairro: cepAbertoEndereco.bairro,
          cep: cepAbertoEndereco.cep,
          cidade: cepAbertoEndereco.cidade.nome,
          uf: cepAbertoEndereco.estado.sigla,
          lat: double.parse(cepAbertoEndereco.latitude),
          long: double.parse(cepAbertoEndereco.longitude));
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('CEP Inválido!!!');
    }
  }

  void removerEndereco() {
    endereco = null;
    precoEntrega = null;
    notifyListeners();
  }

  void zerarTaxaEntrega() {
    precoEntrega = null;
    notifyListeners();
  }

  Future<void> getEndereco(Endereco endereco) async {
    loading = true;
    this.endereco = endereco;

    if (await calcularEntrega(this.endereco!.lat!, this.endereco!.long!)) {
      usuario!.setEndereco(this.endereco!);
      loading = false;
    } else {
      loading = false;
      return Future.error(
          'Infelizmente ainda não estamos entregando para sua localidade.');
    }
  }

  Future<bool> calcularEntrega(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.doc('aux/entrega').get();

    final latOrigem = doc.get('lat') as double;
    final longOrigem = doc.get('long') as double;
    final maxkm = doc.get('maxkm') as num;
    final base = doc.get('base') as num;
    final precokm = doc.get('precokm') as double;

    // distância em metros, converter para quilometros
    // vale ressaltar que essa api retorna a distância em linha reta
    // caso seja necessário utilizar outra a distância por vias utilizar
    // a API do google
    double distancia =
        await Geolocator.distanceBetween(latOrigem, longOrigem, lat, long);

    distancia /= 1000; // distância em km

    if (distancia > maxkm) {
      return false;
    }

    precoEntrega = base * distancia * precokm;

    return true;
  }

  void limparCarrinho() {
    for (final pc in items) {
      usuario!.cartRef.doc(pc.id).delete();
    }
    items.clear();
    notifyListeners();
  }
}
