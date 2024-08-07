import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(QrInitial());

  void showQrCode(int index) {
    emit(QrCodeVisible(index));
  }

  void hideQrCode() {
    emit(QrCodeHidden());
  }
}
