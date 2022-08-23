import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const bucket = admin.storage().bucket("gs://kayu-bem.appspot.com");

const pedidoStatus = new Map([
  [0, 'Cancelado'],
  [1, 'Separando produto no estoque'],
  [2, 'Enviando produto'],
  [3, 'Produto Entregue']
]);

async function sendPushFCM(tokens: string[], titulo: string, mensagem: string) {
  if (tokens.length > 0) {
    const payload = {
      notification: {
        title: titulo,
        body: mensagem,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    }
    return admin.messaging().sendToDevice(tokens, payload);
  }
  return;
}

async function getDeviceTokens(uid: string) {
  const querySnap = await admin.firestore().collection('usuarios').doc(uid).collection('tokens').get();

  const tokens = querySnap.docs.map(doc => doc.id);

  return tokens;
}

export const atualizarImagemPedidos = functions.storage.bucket().object().onFinalize(async (objeto, context) => {
  console.log('[IMAGEM_ATUALIZAR]:' + objeto.name);
  const pid = (objeto.name as string).split('/')[2];
  const file = await bucket.file(objeto.name as string);
  const metaData = await (file.getMetadata());
  const urlImagem = metaData[0].mediaLink;
  console.log('[IMAGE_URL]:' + urlImagem);
  var pedidoAtualizar: any;
  var idPedidoAtualizar;

  await admin.firestore().collection("pedidos").get().then(snapshot => {
    snapshot.docs.forEach(doc => {
      var pedido = doc.data();
      pedido.items.forEach((item: any) => {
        if (item.pid === pid) {
          pedidoAtualizar = pedido;
          idPedidoAtualizar = doc.id;
          console.log(item.pid + ' [SÃO IGUAIS] ' + pid);
          console.log('[ATUALIZAR PEDIDO]: ' + doc.id);
        }
      });
    });
  });

  if (idPedidoAtualizar !== undefined) {
    var items: any[] = [];
    pedidoAtualizar.items.forEach((item: any) => items.push({
      'categoria': item.categoria,
      'nome': item.nome,
      'pid': item.pid === pid ? '' : item.pid, // TORNA O PRODUTO INDISPONÍVEL PARA NOVA COMPRA JÁ QUE O MESMO FOI REMOVIDO
      'precoFixo': item.precoFixo,
      'quantidade': item.quantidade,
      'tamanho': item.tamanho,
      'urlImagem': item.pid === pid ? urlImagem : item.urlImagem,
    }));

    var pedidoAtualizado = {
      'data': pedidoAtualizar.data,
      'entrega': {
        'bairro': pedidoAtualizar.entrega.bairro,
        'cidade': pedidoAtualizar.entrega.cidade,
        'cep': pedidoAtualizar.entrega.cep,
        'complemento': pedidoAtualizar.entrega.complemento,
        'lat': pedidoAtualizar.entrega.lat,
        'long': pedidoAtualizar.entrega.long,
        'numero': pedidoAtualizar.entrega.numero,
        'rua': pedidoAtualizar.entrega.rua,
        'uf': pedidoAtualizar.entrega.uf
      },
      'items': items,
      'pagamentoId': pedidoAtualizar.pagamentoId,
      'preco': pedidoAtualizar.preco,
      'status': pedidoAtualizar.status,
      'usuario': pedidoAtualizar.usuario
    }

    await admin.firestore().collection("pedidos").doc(idPedidoAtualizar).update(pedidoAtualizado);

    admin.firestore().collection("usuarios").get().then(snapshot => {
      snapshot.docs.forEach(async doc => {
        await admin.firestore().collection('usuarios').doc(doc.id).collection('carrinho').get().then(snap => {
          if (snap != null) {
            snap.docs.forEach(async p => {
              let produto = p.data();
              if (produto.pid === pid) {
                await admin.firestore().collection('usuarios').doc(doc.id).collection('carrinho').doc(p.id).delete();
              }
            })
          }
        })
      })
    });

    console.log('[IMAGEM ATUALIZADA NO PRODUTO]: ' + pid);
  }
});

export const onPedidoStatusChanged = functions.firestore.document('/pedidos/{pedidoId}').onUpdate(async (snapshot, context) => {
  const beforeStatus = snapshot.before.data().status;
  const afterStatus = snapshot.after.data().status;

  if (beforeStatus !== afterStatus) {
    const tokensUsuario = await getDeviceTokens(snapshot.after.data().usuario);

    await sendPushFCM(tokensUsuario, 'Pedido: ' + context.params.pedidoId, 'Status atualizado para: ' + pedidoStatus.get(afterStatus));
  }
})

export const onNovoPedido = functions.firestore.document('/pedidos/{pedidoId}').onCreate(async (snapshot, context) => {
  const pedidoId = context.params.pedidoId;

  const querySnap = await admin.firestore().collection('gestores').get();

  const gestores = querySnap.docs.map(doc => doc.id);

  let adminsTokens: string[] = [];
  for (let i = 0; i < gestores.length; i++) {
    const tokensGestor: string[] = await getDeviceTokens(gestores[i]);
    adminsTokens = adminsTokens.concat(tokensGestor);
  }

  await sendPushFCM(adminsTokens, 'Novo Pedido', 'Nova venda realizada. Pedido: ' + pedidoId);

});

