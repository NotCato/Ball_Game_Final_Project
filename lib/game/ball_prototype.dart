import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'components/ball.dart';
import 'components/boundaries.dart';

const double deadzone = 0.5;

class BallPrototype extends Forge2DGame {
  // O StreamSubscription guarda a conexão com os sensores do celular.
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  BallPrototype()
      : super(
          // Gravidade inicial (Vector2(x, y)). Y positivo puxa para baixo.
          gravity: Vector2(0, 10),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // O Viewfinder controla o "olho" da câmera.
    // Anchor.center coloca o ponto (0,0) no centro da tela do celular.
    camera.viewfinder.anchor = Anchor.center;
    
    // Position define para qual ponto do mundo a câmera está olhando.
    camera.viewfinder.position = Vector2(10, 20);
    
    // Zoom: Como o Forge2D usa metros, precisamos de zoom alto (ex: 20.0)
    // para que os objetos não fiquem minúsculos na tela.
    camera.viewfinder.zoom = 20.0;

    // No Flame 1.x, adicionamos objetos físicos ao 'world'.
    await world.add(Ball());
    await world.add(Boundaries());

    // Escuta o acelerômetro para detectar a inclinação do celular.
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Mapeamos a inclinação do celular para a gravidade do mundo.
      // -event.x: inclinar para a direita faz a bola cair para a direita.
      // event.y: inclinar para frente/trás faz a bola descer/subir na tela.
      // O multiplicador (2.0) deixa o movimento mais ágil e sensível.

      double applyDeadzone(double value) {
        if (value.abs() < deadzone) {
          return 0.0;
        } else {
          return value;
        }
      }
      world.gravity.setValues(-applyDeadzone(event.x) * 5.0, applyDeadzone(event.y) * 5.0);
    });
  }

    @override
    void onRemove() {
      // IMPORTANTE: Sempre cancele o sensor para não gastar bateria/memória!
      _accelerometerSubscription?.cancel();
      super.onRemove();
    }
  }