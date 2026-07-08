import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import '/game/components/walls.dart';

class Boundaries extends Component with HasGameReference<Forge2DGame> {
  @override
  Future<void> onLoad() async {
    const worldWidth = 20.0;
    const worldHeight = 40.0;
    const thickness = 1.0;

    // Top
    add(
      Wall(
        Vector2(worldWidth / 2, 0),
        Vector2(worldWidth, thickness),
      ),
    );

    // Bottom
    add(
      Wall(
        Vector2(worldWidth / 2, worldHeight),
        Vector2(worldWidth, thickness),
      ),
    );

    // Left
    add(
      Wall(
        Vector2(0, worldHeight / 2),
        Vector2(thickness, worldHeight),
      ),
    );

    // Right
    add(
      Wall(
        Vector2(worldWidth, worldHeight / 2),
        Vector2(thickness, worldHeight),
      ),
    );
  }
}