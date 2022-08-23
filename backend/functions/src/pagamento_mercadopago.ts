import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const mercadopago = require('mercadopago');

const accessToken = functions.config().mercadopago.accesstoken;

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
            excluded_payment_types: [{
                id: "ticket"
            }, ],
            default_payment_method_id: 'pix',
            installments: 6
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

export const getQRCodePix = functions.https.onCall(async (data, context) => {

    console.log("##################### GERANDO QRCODE PARA PAGAMENTO #####################");

    mercadopago.configure({
        access_token: accessToken
    });

    try {
        const payment = await mercadopago.payment.create(data);

        return {
            'success': true,
            'pagamento': payment.body
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