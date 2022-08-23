import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

function adicionarCategoriaMap(categorias: Map<any, any>, categoria: any) {
  if (categorias.has(categoria)) {
    var contador = categorias.get(categoria);
      categorias.set(categoria, ++contador);
  } else {
      categorias.set(categoria, 1);
  }
  return categorias;
}

function converterMapToList(categorias: Map<any, any>) {
  let lista:any[] = [];
  for (let [chave, valor] of categorias.entries()) {
    lista.push({'categoria': chave, 'quantidade': valor});
  }
  return lista;
}

// 1 00 * * * Uma vez por dia à 00:01
// every 2 minutes a cada 2 minutos
export const relatorioCategoriaPorPedidos = functions.pubsub.schedule('1 00 * * *').onRun(async (context) => {
  console.log('============================ RELATÓRIO DE PRODUTOS PEDIDOS POR CATEGORIA ==================================');

  var categorias = new Map();
  var pedidos = await admin.firestore().collection("pedidos").get();
  var totalPedidos = pedidos.docs.length;

  // LISTA DE PEDIDOS
  pedidos.docs.forEach(doc => {
    var dados = doc.data();
    dados.items.forEach((produto: any) => {
      if ((produto.categoria as String).length > 0) {
        categorias = adicionarCategoriaMap(categorias, produto.categoria);
      }
    });
  });

  var dadosAtualizar = {
    'totalPedidos': totalPedidos,
    'categorias': converterMapToList(categorias)
  }

  await admin.firestore().collection('relatorios').doc('categoria_pedido').set(dadosAtualizar);
  return;
});