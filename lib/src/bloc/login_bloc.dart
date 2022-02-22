import 'dart:async';
//import 'package:formvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ubo_fun/src/bloc/validators.dart';

class LoginBloc with Validators {
  //static final String routeName = 'loginbloc';
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => Rx.combineLatest2(
      emailStream, passwordStream, (dynamic e, dynamic p) => true);

  // Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  set email(String value) {
    _emailController.value = value;
  }

  set password(String value) {
    _passwordController.value = value;
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
