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
    // Centra num mapa em modo paisagem (aprox. 120m x 56m)
    camera.viewfinder.position = Vector2(28, 60);
    
    // Zoom: Como o Forge2D usa metros, precisamos de zoom alto (ex: 20.0)
    // para que os objetos não fiquem minúsculos no ecrã.
    camera.viewfinder.zoom = 12.0; // Zoom ajustado para a vista em modo paisagem

    // No Flame 1.x, adicionamos objetos físicos ao 'world'.
    await world.add(Ball());
    await world.add(TiledMapComponent()); // Adiciona o mapa Tiled em vez das fronteiras manuais

    // Escuta o acelerómetro para detetar a inclinação do telemóvel.
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Mapeamos a inclinação do telemóvel para a gravidade do mundo.
      // -event.x: inclinar para a direita faz a bola cair para a direita.
      // event.y: inclinar para frente/trás faz a bola descer/subir na tela.
      // O multiplicador (2.0) deixa o movimento mais ágil e sensível.

      print(
        'x: ${event.x.toStringAsFixed(2)} '
        'y: ${event.y.toStringAsFixed(2)} '
        'z: ${event.x.toStringAsFixed(2)} '
      );

      double applyDeadzone(double value) {
        if (value.abs() < deadzone) {
          return 0.0;
        } else {
          return value;
        }
      }
      world.gravity.setValues(-applyDeadzone(event.x) * 5.0, applyDeadzone(event.y) * 5.0);
      print(world.gravity);
    });
  }

    @override
    void onRemove() {
      // IMPORTANTE: Cancele sempre o sensor para não gastar bateria/memória!
      _accelerometerSubscription?.cancel();
      super.onRemove();
    }
  }