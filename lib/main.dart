import 'package:flutter/material.dart';

void main() {
  runApp(const DoLixoAoLuxo());
}

class DoLixoAoLuxo extends StatelessWidget {
  const DoLixoAoLuxo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do Lixo ao Luxo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 87, 165, 255),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/montanhas.png', fit: BoxFit.fill),
          ),
          Positioned(
            bottom: 575,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/nuvens.png'),
          ),
          Container(decoration: const BoxDecoration(color: Color(0x80FFFFFF))),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(flex: 2),
                const Text(
                  'Do Lixo\nAo Luxo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006400),
                    fontFamily: 'LuckiestGuy',
                  ),
                ),
                const Spacer(flex: 3), // Espaçador entre o texto e o botão
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                    padding: const EdgeInsets.fromLTRB(50, 15, 50, 10),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    // Ação do botão Iniciar (ex: navegar para outra tela)
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => OutraTela()));
                  },
                  child: const Text(
                    'Iniciar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 1,
                      color: Colors.white,
                      fontFamily: 'LuckiestGuy',
                    ),
                  ),
                ),
                const Spacer(flex: 1), // Espaçador na parte inferior
              ],
            ),
          ),
        ],
      ),
    );
  }
}
