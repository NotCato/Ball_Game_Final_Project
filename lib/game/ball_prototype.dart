import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'components/ball.dart';
import 'components/tiled_map_component.dart'; // Importa o carregador de mapas novo

const double deadzone = 0.7;

class BallPrototype extends Forge2DGame {
  // O StreamSubscription guarda a ligação com os sensores do telemóvel.
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  BallPrototype()
      : super(
          // Gravidade inicial (Vector2(x, y)). Y positivo puxa para baixo.
          gravity: Vector2.zero(),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // O Viewfinder controla o "olho" da câmara.
    // Anchor.center coloca o ponto (0,0) no centro do ecrã do telemóvel.
    camera.viewfinder.anchor = Anchor.center;
    
    // Position define para qual ponto do mundo a câmara está a olhar.
    // Centra no ponto médio do mapa (60.2 horizontal, 28.0 vertical)
    camera.viewfinder.position = Vector2(60.2, 28.0);
    
    // Em vez de um zoom fixo, forçamos a câmara a mostrar a área total do mapa.
    // O Flame vai calcular o zoom ideal para que estes 120.4m x 56m caibam no ecrã.
    camera.viewfinder.visibleGameSize = Vector2(120.4, 56.0);

    // No Flame 1.x, adicionamos objetos físicos ao 'world'.
    // Adicionamos o mapa primeiro para ficar no fundo
    await world.add(TiledMapComponent());
    // Adicionamos a bola depois para ficar por cima
    await world.add(Ball());

    // Escuta o acelerómetro para detetar a inclinação do telemóvel.
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Mapeamos a inclinação do telemóvel para a gravidade do mundo.
      // Em modo Paisagem, os eixos invertem-se:
      // event.y controla o movimento horizontal (esquerda/direita).
      // event.x controla o movimento vertical (cima/baixo).

      double applyDeadzone(double value) {
        if (value.abs() < deadzone) {
          return 0.0;
        } else {
          return value;
        }
      }

      // Ajuste para modo paisagem:
      world.gravity.setValues(
        applyDeadzone(event.y) * 5.0, 
        applyDeadzone(event.x) * 5.0
      );
    });
  }

    @override
    void onRemove() {
      // IMPORTANTE: Cancele sempre o sensor para não gastar bateria/memória!
      _accelerometerSubscription?.cancel();
      super.onRemove();
    }
  }