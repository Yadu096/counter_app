import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/counter_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final userEmail = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (userEmail != null) ...[
                Text(
                  'Welcome, $userEmail',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Counter Value',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$counter',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CounterButton(
                    icon: Icons.add,
                    label: 'Increment',
                    color: Colors.green,
                    onPressed: () {
                      ref.read(counterProvider.notifier).increment();
                    },
                  ),
                  _CounterButton(
                    icon: Icons.remove,
                    label: 'Decrement',
                    color: Colors.orange,
                    onPressed: () {
                      ref.read(counterProvider.notifier).decrement();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _CounterButton(
                icon: Icons.refresh,
                label: 'Reset',
                color: Colors.red,
                onPressed: () {
                  ref.read(counterProvider.notifier).reset();
                },
                isWide: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isWide;

  const _CounterButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 32 : 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: isWide ? const Size(double.infinity, 56) : null,
      ),
    );
  }
}
