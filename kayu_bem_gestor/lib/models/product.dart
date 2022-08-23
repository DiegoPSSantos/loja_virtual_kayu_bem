import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/helpers/image_helper.dart';
import 'package:kayu_bem_gestor/models/product_manager.dart';
import 'package:kayu_bem_gestor/models/section_item.dart';
import 'package:provider/src/provider.dart';
import 'package:uuid/uuid.dart';

import 'item_size.dart';
import 'section.dart';

class Product extends ChangeNotifier {
  Product(
      {this.id,
      this.nome,
      this.descricao,
      this.lancamento,
      this.oferta,
      this.imagens,
      this.tamanhos,
      this.novaColecao,
      this.novasImagens,
      this.categoria}) {
    imagens = imagens?? [];
    tamanhos = tamanhos?? [];
    novasImagens = novasImagens?? [];
  }

  Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    nome = doc.data()!['nome'] as String;
    descricao = doc.data()!['descricao'] as String;
    lancamento = doc.data()!['lancamento'] as bool;
    oferta = doc.data()!['oferta'] as bool;
    novaColecao = doc.data()!['nova_colecao'] as bool;
    categoria = doc.reference.parent.path.split('/').last;
    novasImagens = [];
    imagens = List.from(doc.data()!['imagens'] as List<dynamic>)
        .map((imageData) => ImageHelper.fromMap(imageData as Map<String, dynamic>))
        .toList();
    tamanhos =
        (doc.data()!['tamanhos'] as List<dynamic>).map((t) => ItemSize.fromMap(t as Map<String, dynamic>)).toList();
  }

  String? id;
  String? novoId;
  String? nome;
  String? descricao;
  String? categoria;
  String? novaCategoria;
  bool? lancamento = false;
  bool? oferta = false;
  bool? novaColecao = false;
  bool remove = false;
  List<dynamic>? imagens;
  List<ItemSize>? tamanhos;
  List<dynamic>? novasImagens;
  ItemSize? _tamanhoSelecionado;

  ItemSize get tamanhoSelecionado => _tamanhoSelecionado!;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Reference get storageRef =>
      categoria != null ? _storage.ref().child(categoria!) : _storage.ref().child(novaCategoria!);

  bool get existeTamanhoSelecionado {
    bool retorno;
    try {
      retorno = _tamanhoSelecionado!.estoqueDisponivel;
    } catch (ex) {
      retorno = false;
    }
    return retorno;
  }

  int get totalEstoque {
    int estoque = 0;
    for (final tamanho in tamanhos!) {
      estoque += tamanho.estoque!;
    }
    return estoque;
  }

  bool get estoqueDisponivel {
    return totalEstoque > 0;
  }

  set tamanhoSelecionado(ItemSize t) {
    _tamanhoSelecionado = t;
    notifyListeners();
  }

  ItemSize? encontrarTamanho(String nome) {
    try {
      return tamanhos!.firstWhere((t) => t.nome!.compareTo(nome) == 0);
    } catch (e) {
      return ItemSize();
    }
  }

  List<Map<String, dynamic>> exportarListaTamnhos() {
    return tamanhos!.map((tamanho) => tamanho.toMap()).toList();
  }

  num get menorPreco {
    num menorPreco = double.infinity;
    for (final tamanho in tamanhos!) {
      if (tamanho.preco! < menorPreco && tamanho.estoqueDisponivel) {
        menorPreco = tamanho.preco!;
      }
    }
    return menorPreco;
  }

  Product clone() => Product(
        id: id,
        nome: nome,
        descricao: descricao,
        categoria: categoria,
        lancamento: lancamento,
        oferta: oferta,
        novaColecao: novaColecao,
        imagens: List.from(imagens!),
        novasImagens: List.from(novasImagens!),
        tamanhos: tamanhos!.map((t) => t.clone()).toList());

  Future<void> edit(Function onSuccess, BuildContext context) async {
    loading = true;

    var productManager = context.read<ProductManager>();
    productManager.loadProductsCategory(categoria!);

    List<Map<String, String>> listaImagensAtualizadas;

    final Map<String, dynamic> data = {
      'nome': nome,
      'descricao': descricao,
      'lancamento': lancamento,
      'oferta': oferta,
      'nova_colecao': novaColecao,
      'tamanhos': exportarListaTamnhos()
    };

    if (categoria!.compareTo(novaCategoria!) != 0) {
      await _atualizarImagens();
      _firestore.collection('produtos').doc('categorias').collection(categoria!).doc(id).delete();
      final doc = await _firestore.collection('produtos').doc('categorias').collection(novaCategoria!).add(data);
      novoId = doc.id;
      listaImagensAtualizadas = await _uploadImagensNovas();
    } else {
      listaImagensAtualizadas = await _uploadImagensDiferentes();
      await _firestore.collection('produtos').doc('categorias/$categoria/$id').update(data);
    }

    await atualizarTelaHome(listaImagensAtualizadas.first.values.first, productManager.filteredProducts);

    loading = false;
    onSuccess();
  }

  Future<void> save(Function onSuccess) async {
    loading = true;

    final List<ImageHelper> imagensAtualizarLocal = [];
    final List<Map<String, String>> imagensAtualizarFirebase = [];

    final Map<String, dynamic> data = {
      'nome': nome,
      'descricao': descricao,
      'lancamento': lancamento,
      'oferta': oferta,
      'nova_colecao': novaColecao,
      'tamanhos': exportarListaTamnhos()
    };

    final doc = await _firestore.collection('produtos').doc('categorias').collection(categoria!).add(data);
    id = doc.id;

    for (final imagem in imagens!) {
      final ih = await _uploadImagem(imagem as File, categoria!);
      imagensAtualizarFirebase.add(_getImageData(ih));
      imagensAtualizarLocal.add(ih);
    }

    await _firestore.doc('produtos/categorias/$categoria/$id').update({'imagens': imagensAtualizarFirebase});

    imagens = imagensAtualizarLocal;

    await adicionarProdutoTelaHome(imagensAtualizarFirebase);

    loading = false;
    onSuccess();
  }

  @override
  String toString() {
    return 'Product{nome: $nome, descricao: $descricao, categoria: $categoria, imagens: $imagens, tamanhos: $tamanhos, novasImagens: $novasImagens}';
  }

  Future<void> adicionarProdutoTelaHome(List<Map<String, String>> images) async {
    if (oferta!) {
      _adicionarSecaoHome(images.first.values.first, 'Ofertas');
    }

    if (lancamento!) {
      _adicionarSecaoHome(images.first.values.first, 'Lançamentos');
    }

    if (novaColecao!) {
      _adicionarSecaoHome(images.first.values.first, 'Nova Coleção');
    }
  }

  Future<void> atualizarTelaHome(String urlImagem, List<Product> produtos) async {
    var produto = produtos.firstWhere((p) => p.id == id);
    if (produto.lancamento == true && lancamento == false) {
      await _removerSecaoHome('Lançamentos');
    } else if (produto.lancamento == false && lancamento == true) {
      await _adicionarSecaoHome(urlImagem, 'Lançamentos');
    }

    if (produto.oferta == true && oferta == false) {
      await _removerSecaoHome('Ofertas');
    } else if (produto.oferta == false && oferta == true) {
      await _adicionarSecaoHome(urlImagem, 'Ofertas');
    }

    if (produto.novaColecao == true && novaColecao == false) {
      await _removerSecaoHome('Nova Coleção');
    } else if (produto.novaColecao == false && novaColecao == true) {
      await _adicionarSecaoHome(urlImagem, 'Nova Coleção');
    }
  }

  Future<void> _removerSecaoHome(String ns) async {
    var nomeSecao = await _firestore.collection('home').where('nome', isEqualTo: ns).get();
    nomeSecao.docs.forEach((doc) async {
      var secao = Section.fromDocument(doc);
      secao.items!.removeWhere((p) => p.produto!.compareTo(id!) == 0);
      await doc.reference.update(secao.toMap());
    });
  }

  Future<void> _adicionarSecaoHome(String urlImagem, String ns) async{
    var nomeSecao = await _firestore.collection('home').where('nome', isEqualTo: ns).get();
    nomeSecao.docs.forEach((doc) async {
      var secao = Section.fromDocument(doc);
      if (id != null) {
        var produto = secao.items!.where((p) => p.produto!.compareTo(id!) == 0);
        if (produto.isEmpty) {
          SectionItem item = SectionItem(imagem: urlImagem, categoria: categoria, produto: id);
          secao.items!.add(item);
          await doc.reference.update(secao.toMap());
        }
      }
    });
  }

  Future<List<Map<String, String>>> _uploadImagensNovas() async {
    final List<ImageHelper> imagensAtualizarLocal = [];
    final List<Map<String, String>> imagensAtualizarFirebase = [];

    for (final imagem in novasImagens!) {
      if (imagem is File) {
        final ih = await _uploadImagem(imagem, novaCategoria!);
        imagensAtualizarFirebase.add(_getImageData(ih));
        imagensAtualizarLocal.add(ih);
      }
    }

    await _firestore.doc('produtos/categorias/$novaCategoria/$novoId').update({'imagens': imagensAtualizarFirebase});

    imagens = imagensAtualizarLocal;

    return imagensAtualizarFirebase;
  }

  Future<List<Map<String, String>>> _uploadImagensDiferentes() async {
    final List<ImageHelper> imagensAtualizarLocal = [];
    final List<Map<String, String>> imagensAtualizarFirebase = [];
    ImageHelper ih;

    for (final imagem in novasImagens!) {
      if (imagem is File) {
          ih = await _uploadImagem(imagem, categoria!);
          imagensAtualizarFirebase.add(_getImageData(ih));
          imagensAtualizarLocal.add(ih);
      } else {
        imagensAtualizarFirebase.add(_getImageData(imagem as ImageHelper));
        imagensAtualizarLocal.add(imagem);
      }
    }

    await _firestore.doc('produtos/categorias/$categoria/$id').update({'imagens': imagensAtualizarFirebase});

    imagens = imagensAtualizarLocal;

    return imagensAtualizarFirebase;
  }

  Future<ImageHelper> _uploadImagem(File imagem, String categoria) async {
    final UploadTask task = _storage.ref().child(categoria).child(id!).child(const Uuid().v1()).putFile(imagem);
    final Reference ref = (await task).ref;
    final url = await ref.getDownloadURL();
    return ImageHelper(url: url, bucket: ref.fullPath);
  }

  Future<void> _atualizarImagens() async {
    novasImagens = await _getImagensUpload();
    _apagarImagensAntigaCategoria();
  }

  Future<List<dynamic>> _getImagensUpload() async {
    List<dynamic> imagensUpload = [];
    File tempFile;
    for (var imagem in novasImagens!) {
      if (imagem is ImageHelper) {
        // ESCREVER IMAGEM ANTIGO NO ARQUIVO LOCAL
        tempFile = await _getArquivoImagem(imagem.nomeImagem);
        await _escreverArquivoImagemUrl(imagem.url!, tempFile);
        imagensUpload.add(tempFile);
      } else {
        imagensUpload.add(imagem);
      }
    }
    return imagensUpload;
  }

  Future<void> _apagarImagensAntigaCategoria() async {
    for (final imagem in imagens!) {
      if (imagem is ImageHelper) {
        await _apagarImagem(imagem.url!);
      }
    }
  }

  Future<void> _apagarImagem(String url) async {
    final ref = _storage.refFromURL(url);
    await ref.delete();
  }

  Future<File> _getArquivoImagem(String nomeImagem) async {
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/$nomeImagem');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    return tempFile.create();
  }

  Future<void> _escreverArquivoImagemUrl(String url, File tempFile) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.writeToFile(tempFile);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  Map<String, String> _getImageData(ImageHelper ih) {
    return {'url': ih.url!, 'bucket': ih.bucket!};
  }
}
