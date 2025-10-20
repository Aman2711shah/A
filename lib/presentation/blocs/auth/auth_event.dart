import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String phone;
  final String fullName;
  final String password;

  const RegisterRequested({
    required this.email,
    required this.phone,
    required this.fullName,
    required this.password,
  });

  @override
  List<Object?> get props => [email, phone, fullName, password];
}

class OtpVerificationRequested extends AuthEvent {
  final String phone;
  final String otp;

  const OtpVerificationRequested({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}

class BiometricAuthRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}