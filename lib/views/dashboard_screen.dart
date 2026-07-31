import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalSaldo = 0;
  List<Map<String, dynamic>> _riwayatPengeluaran = [];

  @override
  void initState() {
    super.initState();
    _muatDataLokal();
  }

  Future<void> _muatDataLokal() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _totalSaldo = prefs.getInt('total_saldo') ?? 0;

      final dataStringList = prefs.getStringList('riwayat');

      if (dataStringList != null) {
        _riwayatPengeluaran = dataStringList
            .map((item) => jsonDecode(item) as Map<String, dynamic>)
            .toList();
      }
    });
  }

  Future<void> _simpanDataLokal() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('total_saldo', _totalSaldo);

    final dataStringList =
        _riwayatPengeluaran.map((item) => jsonEncode(item)).toList();

    await prefs.setStringList('riwayat', dataStringList);
  }

  void _tambahPengeluaran(String judul, int nominal) {
    if (nominal <= 0 || judul.isEmpty) return;

    setState(() {
      _totalSaldo -= nominal;

      _riwayatPengeluaran.insert(0, {
        'judul': judul,
        'nominal': nominal,
        'tanggal': DateTime.now().toString().substring(0, 10),
      });
    });

    _simpanDataLokal();
  }

  void _tampilkanModalInput() {
    final judulController = TextEditingController();
    final nominalController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Pengeluaran',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText:
                    'Keterangan (misal: Beli Pop Ice / Print Tugas)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal (Rp)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final judul = judulController.text;

                  final nominal =
                      int.tryParse(nominalController.text) ?? 0;

                  _tambahPengeluaran(judul, nominal);

                  Navigator.pop(ctx);
                },
                child: const Text('Simpan Pengeluaran'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SakuSiswa Dashboard'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BalanceCard(
  balance: _totalSaldo,
  onAddBalance: () {
    setState(() => _totalSaldo += 50000);
    _simpanDataLokal();
  },
),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Pengeluaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: _riwayatPengeluaran.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada pengeluaran hari ini. '
                        'Hemat banget! 🎉',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _riwayatPengeluaran.length,
                      itemBuilder: (context, index) {
                        final item = _riwayatPengeluaran[index];

                        return ExpenseTile(item: item);
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tampilkanModalInput,
        icon: const Icon(Icons.remove_circle_outline),
        label: const Text('Catat Pengeluaran'),
      ),
    );
  }
}