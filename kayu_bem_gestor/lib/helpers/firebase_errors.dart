String getErrorString(String error) {
  final code = getCodeError(error);
  print(code);
  switch (code) {
    case 'ERROR_WEAK_PASSWORD':
      return 'Sua senha é muito fraca.';
    case 'ERROR_INVALID_EMAIL':
      return 'Seu e-mail é inválido.';
    case 'email-already-in-use':
      return 'E-mail já está sendo utilizado em outra conta.';
    case 'ERROR_INVALID_CREDENTIAL':
      return 'Seu e-mail é inválido.';
    case 'wrong-password':
      return 'Sua senha está incorreta.';
    case 'user-not-found':
      return 'Não há usuário com este e-mail.';
    case 'ERROR_USER_DISABLED':
      return 'Este usuário foi desabilitado.';
    case 'too-many-requests':
      return 'Muitas solicitações. Tente novamente mais tarde.';
    case 'ERROR_OPERATION_NOT_ALLOWED':
      return 'Operação não permitida.';
    case 'network-request-failed':
      return 'Internet indisponível';
    case 'facebook.com':
      return 'Você já possui uma conta do Facebook vinculada a este e-mail.';
    case 'user_not_admin':
      return 'O usuário informado não é administrador! Informe um usuário com perfil de adminstrador';
    case 'account-exists-with-different-credential':
      return 'Já existe uma conta cadastrada com esse email. Favor utilizar o login acima.';
    default:
      return 'Um erro indefinido ocorreu.';
  }
}

String getCodeError(String error) {
  if (error.contains(':')) {
    return error.split(":")[1].trim();
  } else if (error.contains('/')) {
    final int inicio = error.indexOf('/') + 1;
    final int fim = error.indexOf(']');
    return error.substring(inicio, fim);
  }
  return error;
}
