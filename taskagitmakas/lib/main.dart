import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taş Kağıt Makas',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String? username;

  void _startGame() {
    setState(() {
      username = _usernameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taş Kağıt Makas'),
      ),
      body: Center(
        child: username == null ? _buildLoginScreen() : GameScreen(username: username!),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Kullanıcı Adı',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startGame,
            child: const Text('Oyuna Gir'),
          ),
        ],
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String username;

  const GameScreen({super.key, required this.username});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String userChoice = '';
  String computerChoice = '';
  String result = '';
  bool isWaitingForSelection = true;
  int countdown = 3;
  Timer? countdownTimer;

  void _playGame(String choice) {
    setState(() {
      userChoice = choice;
      isWaitingForSelection = false;
      countdown = 3;
      _startCountdown();
    });
  }

  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        _determineComputerChoice();
      }
    });
  }

  void _determineComputerChoice() {
    computerChoice = ['Taş', 'Kağıt', 'Makas'][DateTime.now().millisecond % 3];
    _determineResult();
  }

  void _determineResult() {
    if (userChoice == computerChoice) {
      result = 'Beraberlik!';
    } else if ((userChoice == 'Taş' && computerChoice == 'Makas') ||
               (userChoice == 'Kağıt' && computerChoice == 'Taş') ||
               (userChoice == 'Makas' && computerChoice == 'Kağıt')) {
      result = 'Kazandın!';
    } else {
      result = 'Kaybettin!';
    }

    setState(() {});
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oyun: ${widget.username}'),
      ),
      body: Center(
        child: isWaitingForSelection ? _buildSelectionScreen() : _buildResultScreen(),
      ),
    );
  }

  Widget _buildSelectionScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('3 saniye içinde bir seçim yap!', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Text(countdown > 0 ? countdown.toString() : '', style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _playGame('Taş'),
              child: const Column(
                children: [
                  Icon(Icons.circle, size: 100, color: Colors.grey), // Taş ikonu
                  Text('Taş'),
                ],
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => _playGame('Kağıt'),
              child: const Column(
                children: [
                  Icon(Icons.document_scanner, size: 100, color: Colors.grey), // Kağıt ikonu
                  Text('Kağıt'),
                ],
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => _playGame('Makas'),
              child: const Column(
                children: [
                  Icon(Icons.cut, size: 100, color: Colors.grey), // Makas ikonu
                  Text('Makas'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Seçimin: $userChoice', style: const TextStyle(fontSize: 24)),
        Text('Rakibin: $computerChoice', style: const TextStyle(fontSize: 24)),
        Text('Sonuç: $result', style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              userChoice = '';
              computerChoice = '';
              result = '';
              isWaitingForSelection = true;
            });
          },
          child: const Text('Yeni Oyun'),
        ),
      ],
    );
  }
}
