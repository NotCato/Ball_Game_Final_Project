import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'ball.dart';

/// Um obstáculo triangular estático que reinicia a bola quando colide com ela.
class Spike extends BodyComponent with CollisionCallbacks {
  @override
  /// A posição no mundo do centro do espinho.
  final Vector2 position;

  /// O tamanho do corpo do espinho em unidades do mundo.
  final Vector2 size;

  /// Cria um novo corpo de espinho em [position] com [size].
  Spike(this.position, this.size) {
    debugMode = true;
  }

  @override
  /// Chamado quando outro componente de colisão toca o espinho.
  ///
  /// Reinicia a bola para a sua posição de spawn quando ocorre colisão com [Ball].
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ball) {
      (other as Ball).reset();
    }
  }

  @override
  /// Cria o corpo Forge2D estático para o obstáculo espinho.
  Body createBody() {
    // Corpos estáticos (Static) não se movem e não sofrem gravidade.
    // São ideais para chão, paredes e obstáculos fixos.
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: position,
    );

    final body = world.createBody(bodyDef);

    // setAsBox recebe METADE da largura e METADE da altura.
    // O ponto de origem (centro) fica no meio do retângulo.
    final shape = PolygonShape()
      ..setAsBox(
        size.x / 2,
        size.y / 2,
        Vector2.zero(),
        0,
      );

    body.createFixtureFromShape(shape);

    return body;
  }
}