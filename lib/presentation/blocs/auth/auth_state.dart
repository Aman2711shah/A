import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpSent extends AuthState {
  final String phone;

  const OtpSent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class RegistrationSuccess extends AuthState {
  final String message;

  const RegistrationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}