import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});
  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String _error = '';

  Future<void> _login() async {
    setState(() => _error = '');
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? e.code);
    }
  }

  Future<void> _register() async {
    setState(() => _error = '');
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Registrieren')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'E-Mail'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _pass,
            decoration: const InputDecoration(labelText: 'Passwort'),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          if (_error.isNotEmpty)
            Text(_error, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: FilledButton(onPressed: _login, child: const Text('Login'))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: _register, child: const Text('Registrieren'))),
          ]),
        ]),
      ),
    );
  }
}
