import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'new_entry_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final query = FirebaseFirestore.instance
        .collection('watches')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true);

    Future<void> _add() async {
      final result = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute(builder: (_) => const NewEntryPage()),
      );
      if (result == null) return;

      await FirebaseFirestore.instance.collection('watches').add({
        'brand': result['brand'],
        'model': result['model'],
        'reference': result['reference'],
        'purchaseDate': result['purchaseDate'],
        'userId': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Uhren'),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Fehler: ${snap.error}'));
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Noch keine Uhren. Tippe auf +'));
          }
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final m = docs[i].data() as Map<String, dynamic>;
              final title = [
                (m['brand'] ?? '').toString().trim(),
                (m['model'] ?? '').toString().trim(),
              ].where((s) => s.isNotEmpty).join(' ');
              return ListTile(
                title: Text(title.isEmpty ? '(ohne Titel)' : title),
                subtitle: Text(docs[i].id),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => docs[i].reference.delete(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
    );
  }
}
