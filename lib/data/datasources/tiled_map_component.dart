import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../../domain/entities/goal.dart';
import '../../domain/entities/spike.dart';
import '../../domain/entities/wall.dart';

class TiledMapComponent extends Component with HasGameReference<Forge2DGame> {
  static const double scale = 0.05;
  final String mapName; // Nome do ficheiro .tmx

  Vector2? spawnPoint;
  Vector2? goalPoint;

  TiledMapComponent(this.mapName); // Construtor que recebe o nome do mapa

  @override
  Future<void> onLoad() async {
    final tiledMap = await TiledComponent.load(
      mapName, // Usa o nome passado no construtor
      Vector2.all(56) * scale,
    );

    add(tiledMap);

    final wallLayer = tiledMap.tileMap.getLayer<ObjectGroup>('walls');
    final spikeLayer = tiledMap.tileMap.getLayer<ObjectGroup>('spikes');
    final goalLayer = tiledMap.tileMap.getLayer<ObjectGroup>('goal');
    final spawnLayer = tiledMap.tileMap.getLayer<ObjectGroup>('spawn');

    if (spawnLayer != null && spawnLayer.objects.isNotEmpty) {
      final obj = spawnLayer.objects.first;

      spawnPoint = Vector2(
        obj.x * scale,
        obj.y * scale,
      );
    }

    if (goalLayer != null && goalLayer.objects.isNotEmpty) {
      final obj = goalLayer.objects.first;

      goalPoint = Vector2(
        obj.x * scale + (obj.width * scale) / 2,
        obj.y * scale + (obj.height * scale) / 2,
      );

      game.world.add(
        Goal(
          goalPoint!,
          Vector2(obj.width * scale, obj.height * scale),
        ),
      );
    }

    if (wallLayer != null) {
      for (final obj in wallLayer.objects) {
        final position =
            Vector2(obj.x * scale, obj.y * scale) + (Vector2(obj.width * scale, obj.height * scale) / 2);

        final size = Vector2(
          obj.width * scale,
          obj.height * scale,
        );

        game.world.add(Wall(position, size));
      }
    }

    if (spikeLayer != null) {
      for (final obj in spikeLayer.objects) {
        final position =
            Vector2(obj.x * scale, obj.y * scale) + (Vector2(obj.width * scale, obj.height * scale) / 2);

        final size = Vector2(
          obj.width * scale,
          obj.height * scale,
        );

        game.world.add(Spike(position, size));
      }
    }
  }
}