import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'spike.dart';
import 'walls.dart';
import 'goal.dart';

class TiledMapComponent extends Component
    with HasGameReference<Forge2DGame> {
  static const double scale = 0.05;

  // Guarda o ponto de spawn lido do mapa
  Vector2? spawnPoint;

  @override
  Future<void> onLoad() async {
    final tiledMap = await TiledComponent.load(
      'Test_level.tmx',
      Vector2.all(56) * scale,
    );

    add(tiledMap);

    final wallLayer = tiledMap.tileMap.getLayer<ObjectGroup>('walls');
    final spikeLayer = tiledMap.tileMap.getLayer<ObjectGroup>('spikes');
    final goalLayer = tiledMap.tileMap.getLayer<ObjectGroup>('goal');
    final spawnLayer = tiledMap.tileMap.getLayer<ObjectGroup>('spawn');

    // Spawn
    if (spawnLayer != null && spawnLayer.objects.isNotEmpty) {
      final obj = spawnLayer.objects.first;

      spawnPoint = Vector2(
        obj.x * scale,
        obj.y * scale,
      );
    }

    // Paredes
    if (wallLayer != null && wallLayer.objects.isNotEmpty) {
      for (final obj in wallLayer.objects) {
        final position =
            Vector2(obj.x * scale, obj.y * scale) +
            (Vector2(obj.width * scale, obj.height * scale) / 2);

        final size = Vector2(
          obj.width * scale,
          obj.height * scale,
        );

        game.world.add(
          Wall(position, size),
        );
      }
    }

    // Espinhos
    if (spikeLayer != null && spikeLayer.objects.isNotEmpty) {
      for (final obj in spikeLayer.objects) {
        final position =
            Vector2(obj.x * scale, obj.y * scale) +
            (Vector2(obj.width * scale, obj.height * scale) / 2);

        final size = Vector2(
          obj.width * scale,
          obj.height * scale,
        );

        game.world.add(
          Spike(position, size),
        );
      }
    }
    
    // Goal
    if (goalLayer != null && goalLayer.objects.isNotEmpty) {
      for (final obj in goalLayer.objects) {
        final position =
            Vector2(obj.x * scale, obj.y * scale) +
            (Vector2(obj.width * scale, obj.height * scale) / 2);

        final size = Vector2(
          obj.width * scale,
          obj.height * scale,
        );

        game.world.add(
          Goal(position, size),
        );
      }
}
  }
}