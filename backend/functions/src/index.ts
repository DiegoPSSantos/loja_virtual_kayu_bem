import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp(functions.config().firebase);

exports.pagamento = require('./pagamento_mercadopago');
exports.pedido = require('./pedido');
exports.produto = require('./produto');
exports.relatorioGerencial = require('./relatorio_gerencial');