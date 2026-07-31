import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Menyimpan data ke memori HP
Future<void> simpanDataLokal(
  int totalSaldo,
  List<Map<String, dynamic>> riwayat,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('total_saldo', totalSaldo);

  final dataStringList =
      riwayat.map((item) => jsonEncode(item)).toList();

  await prefs.setStringList('riwayat', dataStringList);
}

// Membaca data dari memori HP
Future<Map<String, dynamic>> muatDataLokal() async {
  final prefs = await SharedPreferences.getInstance();

  final saldo = prefs.getInt('total_saldo') ?? 0;

  final dataStringList = prefs.getStringList('riwayat');
  List<Map<String, dynamic>> riwayat = [];

  if (dataStringList != null) {
    riwayat = dataStringList
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  return {
    'saldo': saldo,
    'riwayat': riwayat,
  };
}