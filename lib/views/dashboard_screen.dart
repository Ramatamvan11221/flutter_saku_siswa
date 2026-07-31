import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_tile.dart';
import '../services/storage_service.dart';

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
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await muatDataLokal();

    setState(() {
      _totalSaldo = data['saldo'];
      _riwayatPengeluaran = List<Map<String, dynamic>>.from(
        data['riwayat'],
      );
    });
  }

  Future<void> _saveData() async {
    await simpanDataLokal(
      _totalSaldo,
      _riwayatPengeluaran,
    );
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

    _saveData();
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BalanceCard(
              balance: _totalSaldo,
              onAddBalance: () {
                setState(() {
                  _totalSaldo += 50000;
                });
                _saveData();
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
                        'Belum ada pengeluaran hari ini. Hemat banget! 🎉',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _riwayatPengeluaran.length,
                      itemBuilder: (context, index) {
                        return ExpenseTile(
                          item: _riwayatPengeluaran[index],
                        );
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