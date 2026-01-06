class SendOtpRequest {
  final String phoneNumber;
  final String countryCode;

  SendOtpRequest({
    required this.phoneNumber,
    required this.countryCode,
  });

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'country_code': countryCode,
  };
}

class SendOtpResponse {
  final bool success;
  final String message;
  final String? requestId;
  final int? expiresIn;

  SendOtpResponse({
    required this.success,
    required this.message,
    this.requestId,
    this.expiresIn,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Failed to send OTP',
      requestId: json['request_id'],
      expiresIn: json['expires_in'],
    );
  }
}

class VerifyOtpRequest {
  final String phoneNumber;
  final String otpCode;
  final String? requestId;

  VerifyOtpRequest({
    required this.phoneNumber,
    required this.otpCode,
    this.requestId,
  });

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'otp_code': otpCode,
    'request_id': requestId,
  };
}

class VerifyOtpResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final UserData? user;

  VerifyOtpResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Failed to verify OTP',
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class UserData {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? avatar;

  UserData({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {
    'refresh_token': refreshToken,
  };
}

class RefreshTokenResponse {
  final bool success;
  final String? accessToken;
  final String? refreshToken;

  RefreshTokenResponse({
    required this.success,
    this.accessToken,
    this.refreshToken,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] ?? false,
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

class LogoutRequest {
  final String accessToken;

  LogoutRequest({required this.accessToken});

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
  };
}

class LogoutResponse {
  final bool success;
  final String message;

  LogoutResponse({
    required this.success,
    required this.message,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Logout failed',
    );
  }
}
