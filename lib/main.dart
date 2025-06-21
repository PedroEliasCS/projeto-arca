import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum TiposDeLixo { plastico, papel, metal, vidro, radioativo, naoReciclavel }

// Inicia o "Do Lixo Ao Luxo"
void main() {
  runApp(const DoLixoAoLuxo());
}

// Define o MaterialApp e escolhe o "TelaInicial" para ser a primeira tela
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

// Esta é a tela inicial do game, que mostra o título e o botão para iniciar
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
                const Spacer(flex: 3),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelaGame()),
                    );
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
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Essa é o Widget da tela do jogo em si, onde ele ocorre
class TelaGame extends StatefulWidget {
  const TelaGame({super.key});

  @override
  State<TelaGame> createState() => _TelaGameState();
}

// E essa classe é a contrução do Widget "TelaGame", ou seja, toda a tela do game está aqui
class _TelaGameState extends State<TelaGame> {
  int _pontos = 0;
  int _vidas = 5;
  int _nivel = 1;
  bool _mostrarTextoNivel = true;
  late PageController _lixeirasPageController;
  int _currentBinIndex = 0;
  final List<String> _lixeiraImagePaths = [
    'assets/images/lixeiras/vermelho.png',
    'assets/images/lixeiras/azul.png',
    'assets/images/lixeiras/amarelo.png',
    'assets/images/lixeiras/verde.png',
  ];
  late List<TiposDeLixo> _lixeiraTipos;
  late int _lixeiraInicialPage;

  @override
  void initState() {
    super.initState();
    _lixeiraTipos = [
      TiposDeLixo.plastico,
      TiposDeLixo.papel,
      TiposDeLixo.metal,
      TiposDeLixo.vidro,
    ];
    // se iniciar em nível ≥11, já adiciona lixeira roxa
    if (_nivel >= 11 && !_lixeiraTipos.contains(TiposDeLixo.radioativo)) {
      _lixeiraImagePaths.add('assets/images/lixeiras/roxo.png');
      _lixeiraTipos.add(TiposDeLixo.radioativo);
    }
    // se iniciar em nível ≥21, já adiciona lixeira cinza
    if (_nivel >= 21 && !_lixeiraTipos.contains(TiposDeLixo.naoReciclavel)) {
      _lixeiraImagePaths.add('assets/images/lixeiras/cinza.png');
      _lixeiraTipos.add(TiposDeLixo.naoReciclavel);
    }

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) setState(() => _mostrarTextoNivel = false);
    });
    // recalcula página inicial e cria controller considerando lixeiras adicionais pra sobrarem mesmo
    _lixeiraInicialPage = _lixeiraImagePaths.length * 50;
    _lixeirasPageController = PageController(
      viewportFraction: 1 / _lixeiraImagePaths.length,
      initialPage: _lixeiraInicialPage,
    );
    // inicializa a lixeira selecionado corretamente antes de qualquer swipe
    _currentBinIndex = _lixeiraInicialPage % _lixeiraImagePaths.length;
  }

  // Executado quando o usuário acerta o lixo: soma pontos, sobe de nível e libera novas lixeiras
  // Bascimente, aqui fica toda a lógica de progressão do game
  void _aumentarPontuacao(TiposDeLixo type) {
    setState(() {
      _pontos++;
      if (_pontos >= 10 * _nivel) {
        _nivel++;
        if (_nivel == 11) {
          _lixeiraImagePaths.add('assets/images/lixeiras/roxo.png');
          _lixeiraTipos.add(TiposDeLixo.radioativo);
          _lixeirasPageController.dispose();
          _lixeirasPageController = PageController(
            viewportFraction: 1 / _lixeiraImagePaths.length,
            initialPage: _lixeiraImagePaths.length * 50,
          );
        }
        if (_nivel == 21) {
          _lixeiraImagePaths.add('assets/images/lixeiras/cinza.png');
          _lixeiraTipos.add(TiposDeLixo.naoReciclavel);
          _lixeirasPageController.dispose();
          _lixeirasPageController = PageController(
            viewportFraction: 1 / _lixeiraImagePaths.length,
            initialPage: _lixeiraImagePaths.length * 50,
          );
        }
        if (_nivel == 26) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TelaVitoria()),
          );
        } else {
          _vidas = 5;
        }
        _mostrarTextoNivel = true;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _mostrarTextoNivel = false);
        });
      }
    });
  }

  // Executa quando o usuário erra: perde vida. Inclusive, se zerar, vai para a tela de Game Over
  void _perderVida(TiposDeLixo type) {
    setState(() {
      _vidas--;
      if (_vidas <= 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TelaGameOver()),
        );
      }
    });
  }

  @override
  void dispose() {
    _lixeirasPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Monta na tela: fundo, pontuação, nível, chuva de lixos e controles de lixeira
    // Ou seja, é a tela que vemos quando damos o "play" e os lixos começam a cair
    // A tela do jogo em si 🤓
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 87, 165, 255),
            ),
          ),
          Positioned(
            bottom: 755,
            left: 0,
            right: 0,
            child: Text(
              'Nível $_nivel',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Nunito',
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.black.withValues(alpha: 10),
                    offset: const Offset(1.5, 1.5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 735,
            left: 0,
            right: 0,
            child: Text(
              '❤️ Vidas: $_vidas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Nunito',
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.black.withValues(alpha: 10),
                    offset: const Offset(1.5, 1.5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 715,
            left: 0,
            right: 0,
            child: Text(
              '✨Pontos: $_pontos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Nunito',
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.black.withValues(alpha: 10),
                    offset: const Offset(1.5, 1.5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/montanhas.png', fit: BoxFit.fill),
          ),
          Positioned(
            bottom: 525,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/nuvens.png'),
          ),
          ChuvaDeLixos(
            lixeirasController: _lixeirasPageController,
            qtdLixeiras: _lixeiraImagePaths.length,
            lixeiraTipos: _lixeiraTipos,
            currentBinIndex: _currentBinIndex,
            noAcerto: _aumentarPontuacao,
            noErro: _perderVida,
            nivel: _nivel,
          ),
          if (_mostrarTextoNivel)
            Center(
              child: Text(
                'Nível $_nivel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'LuckiestGuy',
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withValues(alpha: 50),
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            height: 80,
            child: PageView.builder(
              controller: _lixeirasPageController,
              onPageChanged: (page) {
                setState(() {
                  _currentBinIndex = page % _lixeiraImagePaths.length;
                });
              },
              itemCount: _lixeiraImagePaths.length * 100,
              itemBuilder: (context, index) {
                final actual = index % _lixeiraImagePaths.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Image.asset(
                    _lixeiraImagePaths[actual],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Aqui temos a tela de game over, que é exibida quando o player perde
class TelaGameOver extends StatefulWidget {
  const TelaGameOver({super.key});

  @override
  State<TelaGameOver> createState() => _TelaGameOverState();
}

// E aqui está a construção dessa tela de game over em si
class _TelaGameOverState extends State<TelaGameOver> {
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
                  'Fim de\nJogo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF2D2D),
                    fontFamily: 'LuckiestGuy',
                  ),
                ),
                const Spacer(flex: 3), // Espaçador entre o texto e o botão
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2D2D),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelaGame()),
                    );
                  },
                  child: const Text(
                    'Reiniciar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 1,
                      color: Colors.white,
                      fontFamily: 'LuckiestGuy',
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Já essa é a tela de vitória, que é exibida quando o jogador chega no nível 26 (Fim do jogo)
class TelaVitoria extends StatefulWidget {
  const TelaVitoria({super.key});

  @override
  State<TelaVitoria> createState() => _TelaVitoriaState();
}

// E assim como as demais telas, aqui está a construção da tela de vitória em si
// separada de sua estanciação
class _TelaVitoriaState extends State<TelaVitoria> {
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
                  'Você\nGanhou!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC400),
                    fontFamily: 'LuckiestGuy',
                  ),
                ),
                const Spacer(flex: 3), // Espaçador entre o texto e o botão
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC400),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelaGame()),
                    );
                  },
                  child: const Text(
                    'Jogar Novamente',
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

// Esse é o Widget que gera a chuva de lixos
class ChuvaDeLixos extends StatefulWidget {
  final PageController lixeirasController;
  final int qtdLixeiras;
  final List<TiposDeLixo> lixeiraTipos;
  final void Function(TiposDeLixo) noAcerto;
  final void Function(TiposDeLixo) noErro;
  final int nivel;
  final int currentBinIndex;
  const ChuvaDeLixos({
    super.key,
    required this.lixeirasController,
    required this.qtdLixeiras,
    required this.lixeiraTipos,
    required this.noAcerto,
    required this.noErro,
    required this.nivel,
    required this.currentBinIndex,
  });

  @override
  _ChuvaDeLixosState createState() => _ChuvaDeLixosState();
}

class _ChuvaDeLixosState extends State<ChuvaDeLixos>
    with TickerProviderStateMixin {
  // Lista de lixos disponíveis (vai crescendo conforme níveis são atingidos)
  late List<Map<String, Object>> _lixosDisponiveis;

  static const List<Map<String, Object>> _lixosRadioativos = [
    {
      'caminho': 'assets/images/lixos/barril.png',
      'tipo': TiposDeLixo.radioativo,
    },
    {
      'caminho': 'assets/images/lixos/pilha.png',
      'tipo': TiposDeLixo.radioativo,
    },
  ];

  static const List<Map<String, Object>> _lixosNaoReciclaveis = [
    {
      'caminho': 'assets/images/lixos/fralda.png',
      'tipo': TiposDeLixo.naoReciclavel,
    },
    {
      'caminho': 'assets/images/lixos/esponja.png',
      'tipo': TiposDeLixo.naoReciclavel,
    },
    {
      'caminho': 'assets/images/lixos/cachimbo.png',
      'tipo': TiposDeLixo.naoReciclavel,
    },
    {
      'caminho': 'assets/images/lixos/camisinha.png',
      'tipo': TiposDeLixo.naoReciclavel,
    },
  ];
  int _tempoParaSurgirLixos = 4;
  int _velocidadeDoLixo = 5;
  final List<_Lixo> _lixos = [];
  Timer? _timer;
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    // Prepara os tipos de lixo iniciais e adiciona extras se já
    // estiver em nível mais alto (No caso de testes)
    // inicia apenas com lixos recicláveis básicos (sem itens que serão desbloqueados depois)
    _lixosDisponiveis = [
      // Plástico
      {
        'caminho': 'assets/images/lixos/canudo.png',
        'tipo': TiposDeLixo.plastico,
      },
      {
        'caminho': 'assets/images/lixos/manteiga.png',
        'tipo': TiposDeLixo.plastico,
      },
      {
        'caminho': 'assets/images/lixos/garrafa.png',
        'tipo': TiposDeLixo.plastico,
      },
      {
        'caminho': 'assets/images/lixos/shampoo.png',
        'tipo': TiposDeLixo.plastico,
      },
      {'caminho': 'assets/images/lixos/jornal.png', 'tipo': TiposDeLixo.papel},
      {
        'caminho': 'assets/images/lixos/lanche-feliz.png',
        'tipo': TiposDeLixo.papel,
      },
      {'caminho': 'assets/images/lixos/papel.png', 'tipo': TiposDeLixo.papel},
      {'caminho': 'assets/images/lixos/papelao.png', 'tipo': TiposDeLixo.papel},
      {'caminho': 'assets/images/lixos/atum.png', 'tipo': TiposDeLixo.metal},
      {'caminho': 'assets/images/lixos/clips.png', 'tipo': TiposDeLixo.metal},
      {'caminho': 'assets/images/lixos/cerveja.png', 'tipo': TiposDeLixo.vidro},
      {'caminho': 'assets/images/lixos/jarro.png', 'tipo': TiposDeLixo.vidro},
      {'caminho': 'assets/images/lixos/perfume.png', 'tipo': TiposDeLixo.vidro},
      {
        'caminho': 'assets/images/lixos/copo-quebrado.png',
        'tipo': TiposDeLixo.vidro,
      },
    ];
    // Se iniciar em nível ≥ 11, já inclui lixos radioativos
    if (widget.nivel >= 11) {
      _lixosDisponiveis.addAll(_lixosRadioativos);
    }
    // Se iniciar em nível ≥ 21, já inclui lixos não recicláveis
    if (widget.nivel >= 21) {
      _lixosDisponiveis.addAll(_lixosNaoReciclaveis);
    }
    _timer = Timer.periodic(
      Duration(seconds: _tempoParaSurgirLixos),
      (_) => _spawnLixo(),
    );
  }

  // Cria um objeto de lixo no centro e inicia animação de queda
  void _spawnLixo() {
    final lixos = _lixosDisponiveis;
    final selection = lixos[_rnd.nextInt(lixos.length)];
    final caminho = selection['caminho'] as String;
    final tipo = selection['tipo'] as TiposDeLixo;
    final comecoX = 0.5;
    final duracao = Duration(seconds: _velocidadeDoLixo);

    late _Lixo lixo;
    lixo = _Lixo(
      caminho: caminho,
      comecoX: comecoX,
      tipo: tipo,
      duracao: duracao,
      vsync: this,
      onComplete: () {
        setState(() => _lixos.remove(lixo));
        lixo.controller.dispose();
      },
    );

    setState(() => _lixos.add(lixo));
    lixo.controller.forward();
  }

  @override
  void didUpdateWidget(covariant ChuvaDeLixos oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Atualiza a frequência de queda e liberação de novos tipos de lixo conforme o nível
    if (widget.nivel >= 6 && oldWidget.nivel < 6) {
      _timer?.cancel();
      _tempoParaSurgirLixos = 3;
      _timer = Timer.periodic(
        Duration(seconds: _tempoParaSurgirLixos),
        (_) => _spawnLixo(),
      );
    }
    if (widget.nivel >= 16 && oldWidget.nivel < 16) {
      _timer?.cancel();
      _tempoParaSurgirLixos = 2;
      _timer = Timer.periodic(
        Duration(seconds: _tempoParaSurgirLixos),
        (_) => _spawnLixo(),
      );
    }
    // Ao atingir nível 21, reduz duração de queda (animação) para 2 segundos
    // (Pode parecer 4 por conta do valor, mas esse "4" resulta em 2 segundos no game)
    if (widget.nivel >= 21 && oldWidget.nivel < 21) {
      _velocidadeDoLixo = 4;
    }
    // Ao desbloquear a lixeira roxa (niv 11), adiciona lixos radioativos
    if (widget.nivel >= 11 && oldWidget.nivel < 11) {
      setState(() {
        _lixosDisponiveis.addAll(_lixosRadioativos);
      });
    }
    // Ao desbloquear a lixeira cinza (niv 21), adiciona lixos não recicláveis
    if (widget.nivel >= 21 && oldWidget.nivel < 21) {
      setState(() {
        _lixosDisponiveis.addAll(_lixosNaoReciclaveis);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var l in _lixos) l.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Desenha cada objeto de lixo em queda e verifica se acertou a lixeira certa
    final size = MediaQuery.of(context).size;
    final topoDaLixeiraY = size.height - 100;

    return Stack(
      children:
          _lixos.map((lixo) {
            return AnimatedBuilder(
              animation: lixo.animacao,
              builder: (_, __) {
                final y = lixo.animacao.value * (size.height + 100) - 100;
                // Se o lixo chegou na altura das lixeiras:
                if (y >= topoDaLixeiraY && !lixo.jaPontuado) {
                  // Marca pontuação como computada para evitar duplicação
                  lixo.jaPontuado = true;
                  // Verifica se a lixeira central combina com o tipo do lixo
                  // calcula índice da lixeira centrada dinamicamente
                  final double pagePos =
                      widget.lixeirasController.page ??
                      widget.lixeirasController.initialPage.toDouble();
                  final int binIndex =
                      pagePos.round() % widget.lixeiraTipos.length;
                  final TiposDeLixo binTipo = widget.lixeiraTipos[binIndex];
                  debugPrint(
                    'Lixo tipo: ${lixo.tipo}, Bin tipo: $binTipo (idx $binIndex)',
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (binTipo == lixo.tipo) {
                      widget.noAcerto(lixo.tipo);
                    } else {
                      widget.noErro(lixo.tipo);
                    }
                  });
                }
                return Positioned(
                  left: (size.width - 40) / 2,
                  top: y,
                  child: Image.asset(lixo.caminho, width: 40, height: 40),
                );
              },
            );
          }).toList(),
    );
  }
}

// E por fim, essa é a classe onde criamos o objeto "Lixo"
class _Lixo {
  final String caminho;
  final double comecoX;
  final TiposDeLixo tipo;
  final AnimationController controller;
  late final Animation<double> animacao;
  bool jaPontuado = false;

  _Lixo({
    required this.caminho,
    required this.comecoX,
    required this.tipo,
    required Duration duracao,
    required TickerProvider vsync,
    required void Function() onComplete,
  }) : controller = AnimationController(vsync: vsync, duration: duracao) {
    animacao = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) onComplete();
      });
  }
}
