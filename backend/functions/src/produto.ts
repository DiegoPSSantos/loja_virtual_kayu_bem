import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const path = require('path');
const os = require('os');
const bucket = admin.storage().bucket("gs://kayu-bem.appspot.com");

async function removerProdutoSecaoHome(pidExcluido: string, secao: string, tipo: string) {
  var snaphot = await admin.firestore().collection("home").where('nome', '==', secao).get();
    snaphot.forEach(async doc => {
      var referencia = doc.ref;
      var dados = doc.data();
          var itemsAtualizados:Array<any> = dados.items.filter((item:any) => item.produto !== pidExcluido);
          const secaoAtualizar = {
            'items': itemsAtualizados,
            'nome': secao,
            'tipo': tipo
          } 
          await referencia.update(secaoAtualizar);
          return;
    });
}

async function atualizarSecaoHome(itemAtualizar: any, secao: string, tipo: string, pid: string, imagem: string) {
  var snap = await admin.firestore().collection('home').where('nome', '==', secao).get();
  if (snap!.empty) {
    await adicionarImagemProdutoSecao(itemAtualizar, secao, tipo);
    return;
  } else {
    await atualizarImagemProdutoSecao(secao, snap, pid, imagem, itemAtualizar);
    return;
  }
}

async function adicionarImagemProdutoSecao(itemAtualizar: any, secao: string, tipo: string) {
  console.log("[LISTA DE " + secao.toUpperCase() + " VAZIA]");
  const dadosAtualizar = {
    'items': [itemAtualizar],
    'nome': secao,
    'tipo': tipo
  }
  await admin.firestore().collection('home').add(dadosAtualizar);
  return;
}

async function atualizarImagemProdutoSecao(secao:string, snap:any, pid:string, imagem:string, itemAtualizar: any) {
  console.log("[LISTA DE " + secao.toUpperCase() + " NÃO VAZIA]");
  var produtoEncontrado = false;
  snap!.forEach(async (doc:any) => {
    var referencia = doc.ref;
    var dados = doc.data();
    dados.items.forEach(async (_: number, item: any) => {
      if (item.produto === pid && item.imagem !== imagem) {
        item.imagem = imagem;
        await referencia.update(dados);
        produtoEncontrado = true;
      }
    });
    if (!produtoEncontrado) {
      dados.items.push(itemAtualizar);
      await referencia.update(dados);
    }
  });
  return;
}

async function apagarImagemWithBucket(bucket: string) {
  return admin.storage().bucket(bucket).delete();
}

function adicionarProdutoMap(categorias: Map<any, any>, produto: any) {
  if (categorias.has(produto.categoria)) {
    var produtos = categorias.get(produto.categoria);
    console.log('[CHAVES PRODUTOS]: ' + [...produtos.keys()])
    console.log('[VALORES PRODUTOS]: ' + [...produtos.values()])
    console.log('[PID VERIFICAR]: ' + produto.pid);
    console.log('[CATEGORIA VERIFICAR]: ' + produto.categoria);
    if (produtos.has(produto.pid)) {
      var contador = produtos.get(produto.pid);
      produtos.set(produto.pid, ++contador);
    } else {
      produtos.set(produto.pid, 1);
    }
    categorias.set(produto.categoria, produtos);
  } else {
    var prods = new Map();
    categorias.set(produto.categoria, prods.set(produto.pid, 1));
  }
  return categorias;
}

export const removerProduto = functions.firestore.document('produtos/categorias/{categoria}/{produtoId}').onDelete(async (snap, context) => {
  var produtoRemovido = snap.data();
  var pidExcluido = context.params.produtoId;
  console.log("============================= PRODUTO EXCLUÍDO =========================");
  console.log('[PID]: ' + pidExcluido);
  var imagensRemovidas = produtoRemovido.imagens;
  var urlImagem = imagensRemovidas[0].url;
  const pedidos = await admin.firestore().collection("pedidos").get();
  pedidos.forEach((pedido) => {
    var p = pedido.data();
    p.items.forEach(async (item: any) => {
      if (item.pid === pidExcluido && item.urlImagem === urlImagem) {
        const fileName = produtoRemovido.imagens[0].bucket;
        const tempFilePath = path.join(os.tmpdir(), fileName.split('/')[2]);
        const metadata = {
          contentType: 'image/png'
        };
        console.log('[PEDIDO_PRODUTO_ID]: ' + item.pid);
        console.log('[URL_IMAGEM]: ' + item.urlImagem);
        console.log('[FILENAME]: ' + fileName);
        console.log('[BUCKET]: ' + bucket.name);
        console.log('[BUCKET_EXISTE]: ' + bucket.exists());
        console.log('[TEMP_FILE_PATH]: ' + tempFilePath);
        console.log('[METADATA]:' + metadata)
        var fileTemp = bucket.file(fileName);
        await fileTemp.download({
          destination: tempFilePath
        });
        await bucket.upload(tempFilePath, {
          destination: 'pedidos/' + produtoRemovido.imagens[0].bucket,
          metadata: metadata,
          public: true
        }).then((response) => {
          console.log('[IMAGE_SAVE_IN]: ' + tempFilePath);
          fileTemp.delete();
          console.log('============================ ARQUIVO EXCLUÍDO COM SUCESSO =====================');
        }).catch(error => console.log(error));
      }
    });
  });

  // REMOVENDO PRODUTO DA TELA DE HOME
  if (produtoRemovido.lancamento) {
    await removerProdutoSecaoHome(pidExcluido, 'Lançamentos', 'Carroussel');
  }

  if (produtoRemovido.oferta) {
    await removerProdutoSecaoHome(pidExcluido, 'Ofertas', 'Staggered');
  }

  if (produtoRemovido.nova_colecao) {
    await removerProdutoSecaoHome(pidExcluido, 'Nova Coleção', 'List');
  }

  imagensRemovidas.forEach((img:any) => apagarImagemWithBucket(img.bucket));
    
});


// 1 00 * * * Uma vez por dia à 00:01
// every 2 minutes a cada 2 minutos
export const atualizarProdutosEmAlta = functions.pubsub.schedule('1 00 * * *').onRun(async (context) => {
  console.log('============================ ATUALIZANDO LISTA DE PRODUTOS EM ALTA ==================================');

  var categorias = new Map();
  var pedidos = await admin.firestore().collection("pedidos").get();

  // LISTA DE PEDIDOS
  pedidos.docs.forEach(doc => {
    var dados = doc.data();
    dados.items.forEach((produto: any) => {
      if ((produto.pid as String).length > 0) {
        categorias = adicionarProdutoMap(categorias, produto);
      }
    });
  });

  //LISTA DE PRODUTOS NO CARRINHO
  var usuarios = await admin.firestore().collection("usuarios").get();
  usuarios.docs.forEach(async usuario => {
    var carrinho = await admin.firestore().collection("usuarios").doc(usuario.id).collection('carrinho').get();
    if (!carrinho.empty) {
      carrinho.docs.forEach(p => {
        var pdados = p.data();
        categorias = adicionarProdutoMap(categorias, pdados);
      });
    } 
  });

  var produtosAlta = await admin.firestore().collection('home').where('nome', '==', 'Produtos em Alta').get();
  produtosAlta.docs.forEach(async doc => {
    var listaProdutosPA = new Array();
    for (let [categoria, _] of categorias) {
      for (let [pid, quantidade] of categorias.get(categoria)) {
        let docProduto = await admin.firestore().collection('produtos').doc('categorias').collection(categoria).doc(pid).get();
        let dadosProduto = docProduto.data();
        let item = {
          'categoria': categoria,
          'produto': pid,
          'quantidade': quantidade,
          'imagem': dadosProduto!.imagens[0].url
        };
        listaProdutosPA.push(item);
      };
    };
    doc.ref.update('items', listaProdutosPA);
  });

}); 

export const atualizarProdutoTelaHome = functions.firestore.document('produtos/categorias/{categoria}/{produtoId}').onUpdate(async (change, context) => {

  console.log("============================ ATUALIZANDO TELA DE HOME ==============================");

  var pid = context.params.produtoId;
  var categoria = context.params.categoria;
  var dadosAnteriores = change.before.data();
  var dadosAtuais = change.after.data();
  var imagensAnteriores:[] = dadosAnteriores.imagens;
  var imagemAtualizada = dadosAtuais!.imagens[0].url;

  const item = {
    'imagem': imagemAtualizada,
    'produto': pid,
    'categoria': categoria
  }

  if (imagensAnteriores === undefined) {
    console.log("[IMAGEM NÃO EXISTENTE ANTERIORMENTE]");
    if (dadosAtuais.lancamento) {
      await atualizarSecaoHome(item, 'Lançamentos', 'Carroussel', pid, imagemAtualizada);
    }
    
    if (dadosAtuais.oferta) {
      await atualizarSecaoHome(item, 'Ofertas', 'Staggered', pid, imagemAtualizada);
    }

    if (dadosAtuais.nova_colecao) {
      await atualizarSecaoHome(item, 'Nova Coleção', 'List', pid, imagemAtualizada);
    }
  } else {
    if (dadosAnteriores.lancamento == false && dadosAtuais.lancamento == true) {
      await atualizarSecaoHome(item, 'Lançamentos', 'Carroussel', pid, imagemAtualizada);
    } else if (dadosAnteriores.lancamento == true && dadosAtuais.lancamento == false) {
      await removerProdutoSecaoHome(pid, 'Lançamentos', 'Carroussel');
    }
    
    if (dadosAnteriores.oferta == false && dadosAtuais.oferta == true) {
      await atualizarSecaoHome(item, 'Ofertas', 'Staggered', pid, imagemAtualizada);
    } else if (dadosAnteriores.oferta == true && dadosAtuais.oferta == false){
      await removerProdutoSecaoHome(pid, 'Ofertas', 'Staggered');
    }

    if (dadosAnteriores.nova_colecao == false && dadosAtuais.nova_colecao == true) {
      await atualizarSecaoHome(item, 'Nova Coleção', 'List', pid, imagemAtualizada);
    } else if (dadosAnteriores.nova_colecao == true && dadosAtuais.nova_colecao == false) {
      await removerProdutoSecaoHome(pid, 'Nova Coleção', 'List');
    }

    if (imagensAnteriores.length > dadosAtuais!.imagens.length) {
      var imagensAtuais = dadosAtuais!.imagens;
      var imagemApagar:any = imagensAnteriores.filter(img => !imagensAtuais.includes(img));
      apagarImagemWithBucket(imagemApagar[0].bucket);
    }
  }
    
});
