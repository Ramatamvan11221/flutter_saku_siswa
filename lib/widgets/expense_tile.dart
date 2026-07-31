import 'package:flutter/material.dart';


class ExpenseTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const ExpenseTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.shopping_bag_outlined),
        ),
        title: Text(item['judul']),
        subtitle: Text(item['tanggal']),
        trailing: Text(
          '- Rp ${item['nominal']}',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}