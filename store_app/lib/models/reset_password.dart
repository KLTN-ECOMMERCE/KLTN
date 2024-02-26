class ResetPassword {
  const ResetPassword({
    required this.password,
    required this.confirmPassword,
    required this.otp,
  });

  final String password;
  final String confirmPassword;
  final int otp;
}
