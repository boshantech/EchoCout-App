import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/driver_otp_bloc.dart';

class DriverOtpBlocProvider {
  static BlocProvider<DriverOtpBloc> create() {
    return BlocProvider<DriverOtpBloc>(
      create: (context) => DriverOtpBloc(),
    );
  }
}
