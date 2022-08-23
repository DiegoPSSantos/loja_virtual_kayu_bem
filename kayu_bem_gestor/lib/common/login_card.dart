import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.account_circle,
                    color: Theme.of(context).primaryColor, size: 100),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Faça login para acessar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Theme.of(context).primaryColor),
                    child: const Text('LOGIN',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
              ],
            ),
          )));
}
