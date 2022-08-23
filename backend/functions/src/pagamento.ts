import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import vision from "@google-cloud/vision";
import {
  CieloConstructor,
  Cielo,
  TransactionCreditCardRequestModel,
  CaptureRequestModel,
  CancelTransactionRequestModel,
  EnumBrands
} from "cielo";

const mercadopago = require('mercadopago');
const merchantId = functions.config().cielo.merchantid;
const merchantKey = functions.config().cielo.merchantkey;

const accessToken = functions.config().mercadopago.accesstoken;
// const publicKey = functions.config().mercadopago.publickey;

// const CIELO = 'Cielo';
// const MERCADO_PAGO = 'MercadoPago';

const cieloParams: CieloConstructor = {
  merchantId: merchantId,
  merchantKey: merchantKey,
  sandbox: true,
  debug: true
}

const cielo = new Cielo(cieloParams);

async function authorizeCieloCC(data: any, dadosUsuario: any, brand: any) {
  const saleData: TransactionCreditCardRequestModel = {
    merchantOrderId: data.merchantOrderId,
    customer: {
      name: dadosUsuario!.name,
      identity: data.cpf,
      identityType: 'CPF',
      email: dadosUsuario!.email,
      deliveryAddress: {
        street: dadosUsuario!.endereco.rua,
        number: dadosUsuario!.endereco.numero,
        complement: dadosUsuario!.endereco.complemento,
        district: dadosUsuario!.endereco.bairro,
        zipCode: dadosUsuario!.endereco.cep.replace('.', '').replace('-', ''),
        city: dadosUsuario!.endereco.cidade,
        state: dadosUsuario!.endereco.uf,
        country: 'BRA'
      }
    },
    payment: {
      currency: 'BRL',
      country: 'BRA',
      amount: data.amount,
      installments: data.installments,
      softDescriptor: data.softDescriptor.substring(0, 13),
      type: data.paymentType,
      capture: false,
      creditCard: {
        cardNumber: data.creditCard.cardNumber,
        holder: data.creditCard.holder,
        expirationDate: data.creditCard.expirationDate,
        securityCode: data.creditCard.securityCode,
        brand: brand
      }
    }
  }

  try {
    const autorizacao = await cielo.creditCard.transaction(saleData);

    if (parseInt(autorizacao.payment.returnCode) === 4 || parseInt(autorizacao.payment.returnCode) === 6) {
      return {
        'success': true,
        'paymentId': autorizacao.payment.paymentId
      }
    } else {
      let message = '';
      switch (parseInt(autorizacao.payment.returnCode)) {
        case 5:
          message = 'Não Autorizada';
          break;
        case 57:
          message = 'Cartão Expirado';
          break;
        case 78:
          message = 'Cartão Bloqueado';
          break;
        case 99:
          message = 'Timeout';
          break;
        case 77:
          message = 'Cartão Cancelado';
          break;
        case 70:
          message = 'Problemas com Cartão de Crédito';
          break;
        default:
          message = autorizacao.payment.returnMessage;
          break;
      }
      return {
        'success': false,
        'status': autorizacao.payment.status,
        'error': {
          'code': autorizacao.payment.returnCode,
          'message': message
        }
      }
    }
  } catch (error) {
    console.log('Error:', error);
    return {
      'success': false,
      'error': {
        'code': error.response[0].Code,
        'message': error.response[0].Message
      }
    }
  }
}

export const getPreferenceId = functions.https.onCall(async (data, context) => {
  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -100,
        "message": "Dados não informados"
      }
    }
  }

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -101,
        "message": "Usuário não logado"
      }
    }
  }

  const usuarioId = context.auth.uid;

  const snapshot = await admin.firestore().collection('usuarios').doc(usuarioId).get();
  const dadosUsuario = snapshot.data();

  console.log("##################### INICIANDO CAPTURA DO PREFERENCE_ID #####################");

  console.log('DADOS ENVIADOS -> ', data);

  mercadopago.configure({
    access_token: accessToken
  });
  

  let preference = {
    items: data.items,
    payer: {
      name: dadosUsuario!.name, 
      email: dadosUsuario!.email,
      identification: {
        type: 'CPF',
        number: dadosUsuario!.cpf
      }
    },
    payment_methods: {
        excluded_payment_types: [
            {
                id: "ticket"
            },
            {
                id: "bank_transfer"
            },
        ]
    }
  }

  const pref = await mercadopago.preferences.create(preference);
  return {
    'success': true, 
    'preferenceId': pref.body.id
  };
});

export const getToken = functions.https.onCall(async (_, context) => {
    return {
        'token': accessToken
    }
});

export const confirmPIXTransaction = functions.https.onCall(async (data, context) => {
  const client = new vision.ImageAnnotatorClient();
  const pixREGEX = new RegExp('^[a-zA-Z0-9]{26,35}$');

  var urlComprovante = data.urlComprovante;

  const [result] = await client.textDetection(urlComprovante);
  const documento = result.fullTextAnnotation;
  let txid: String | undefined = undefined;
  console.log('================================= [TEXTO EM DOCUMENTO DENSO] ===============================');
  documento?.pages?.every(pagina => {
    pagina.blocks?.every(bloco => {
      bloco.paragraphs?.every(paragrafo => {
        paragrafo.words?.every(frase => {
          const f = frase.symbols?.map(palavra => palavra.text).join('');
          console.log(f);
          if (f?.match(pixREGEX)) {
            console.log('================================= [ID DA TRANSAÇÃO] ===============================');
            console.log(f);
            txid = f;
            return false;
          }
          return true;
        });
        console.log('[paragrafo]: ', paragrafo.confidence);
        if (txid !== undefined) {
          return false;
        }
        return true;
      });
      console.log('[bloco]: ', bloco.confidence);
      if (txid !== undefined) {
        return false;
      }
      return true;
    });
    console.log('[pagina]: ', pagina.confidence);
    if (txid !== undefined) {
      console.log('[TXID] ', txid);
      return false;
    }
    return true;
  });

  if (txid !== undefined) {
    return {
      'success': true,
      'paymentId': txid
    }
  } else {
    return {
      "success": false,
      "error": {
        "code": -103,
        "message": "ID da transação não encontrado no arquivo enviado"
      }
    }
  }

});

export const getMeiosPagamento = functions.https.onCall(async (_, context) => {
    mercadopago.configure({
        access_token: accessToken
      });

    var response = await mercadopago.payment_methods.listAll();

    return {
        'meios_pagamento': response.body
    }
})

export const getParcelasCartaoCredito = functions.https.onCall(async (data, context) => {
    mercadopago.configure({
        access_token: accessToken
    });

    if (data === null) {
        return {
            "success": false,
            "error": {
              "code": -100,
              "message": "Dados não informados"
            }
          }
    }

    let bin = data.bin;
    let total = data.total;

    const parcelamento = {
        bin: bin,
        amount: total
    }

    const parcelas = await mercadopago.getPaymentMethod(parcelamento);

    return {
        "success": true,
        "parcelas": parcelas
    }

})

export const authorizeCreditCard = functions.https.onCall(async (data, context) => {
  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -100,
        "message": "Dados não informados"
      }
    }
  }

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -101,
        "message": "Usuário não logado"
      }
    }
  }

  const usuarioId = context.auth.uid;

  const snapshot = await admin.firestore().collection('usuarios').doc(usuarioId).get();
  const dadosUsuario = snapshot.data();

  console.log("##################### INICIANDO AUTORIZAÇÃO #####################");

  console.log('DADOS ENVIADOS -> ', data);

  let brand: EnumBrands;
  switch (data.creditCard.brand) {
    case "VISA":
      brand = EnumBrands.VISA;
      break;
    case "MASTERCARD":
      brand = EnumBrands.MASTER;
      break;
    case "AMEX":
      brand = EnumBrands.AMEX;
      break;
    case "ELO":
      brand = EnumBrands.ELO;
      break;
    case "JCB":
      brand = EnumBrands.JCB;
      break;
    case "DINERS":
      brand = EnumBrands.DINERS;
      break;
    case "DISCOVER":
      brand = EnumBrands.DISCOVER;
      break;
    case "HIPERCARD":
      brand = EnumBrands.HIPERCARD;
      break;
    default:
      return {
        "success": false,
        "error": {
          "code": -103,
          "message": "Bandeira de cartão não aceita: " + data.creditCard.brand
        }
      }
  }

  // let gateway = data.gateway;
  // if (gateway == CIELO) {
  return authorizeCieloCC(data, dadosUsuario, brand);
  // }
});

export const captureCreditCard = functions.https.onCall(async (data, context) => {
  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -100,
        "message": "Dados não informados"
      }
    }
  }

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -101,
        "message": "Usuário não logado"
      }
    }
  }

  const captureParams: CaptureRequestModel = {
    paymentId: data.payId
  }

  try {
    const capture = await cielo.creditCard.captureSaleTransaction(captureParams);

    if (capture.status === 2) {
      console.log('Status:' + capture.status);
      return {
        "success": true
      }
    } else {
      console.log('Error', capture);
      return {
        "success": false,
        "status": capture.status,
        "error": {
          "code": capture.returnCode,
          "message": capture.returnMessage
        }
      }
    }
  } catch (error) {
    console.log('Error:', error);
    return {
      'success': false,
      'error': {
        'code': error.response[0].Code,
        'message': error.response[0].Message
      }
    }
  }
});

export const cancelSale = functions.https.onCall(async (data, context) => {
  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -100,
        "message": "Dados não informados"
      }
    }
  }

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -101,
        "message": "Usuário não logado"
      }
    }
  }

  const cancelParams: CancelTransactionRequestModel = {
    paymentId: data.payId
  }

  try {
    const cancel = await cielo.creditCard.cancelTransaction(cancelParams);

    if (cancel.status === 10 || cancel.status === 11) {
      console.log('Status:' + cancel.status);
      return {
        "success": true
      }
    } else {
      console.log('Error', cancel);
      return {
        "success": false,
        "status": cancel.status,
        "error": {
          "code": cancel.returnCode,
          "message": cancel.returnMessage
        }
      }
    }
  } catch (error) {
    console.log('Error:', error);
    return {
      'success': false,
      'error': {
        'code': error.response[0].Code,
        'message': error.response[0].Message
      }
    }
  }
});