import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'walls.dart';
import 'spike.dart';

class TiledMapComponent extends Component with HasGameReference<Forge2DGame> {
  static const double scale = 0.05; // Fator de escala de píxeis para metros

  @override
  Future<void> onLoad() async {
    // Carrega o mapa Tiled a partir dos recursos (assets)
    final tiledMap = await TiledComponent.load('Test_level.tmx', Vector2.all(56) * scale);
    add(tiledMap); // Adiciona o mapa visual ao jogo

    // Obtém a camada de objetos 'walls'
    final wallLayer = tiledMap.tileMap.getLayer<ObjectGroup>('walls');
    final spikeLayer = tiledMap.tileMap.getLayer<ObjectGroup>('spikes');

    if (wallLayer != null && wallLayer.objects.isNotEmpty) {
      for (final obj in wallLayer.objects) {
        // Converte coordenadas Tiled (canto superior esquerdo) para coordenadas Forge2D (centro)
        final position = Vector2(obj.x * scale, obj.y * scale) + (Vector2(obj.width * scale, obj.height * scale) / 2);
        final size = Vector2(obj.width * scale, obj.height * scale);

        // Adiciona uma parede física para cada objeto
        game.world.add(Wall(position, size));
      }
    }

    if (spikeLayer != null && spikeLayer.objects.isNotEmpty) {
      for (final obj in spikeLayer.objects) {
        // Converte coordenadas Tiled (canto superior esquerdo) para coordenadas Forge2D (centro)
        final position = Vector2(obj.x * scale, obj.y * scale) + (Vector2(obj.width * scale, obj.height * scale) / 2);
        final size = Vector2(obj.width * scale, obj.height * scale);

        // Adiciona um spike para cada objeto
        game.world.add(Spike(position, size));
      }
    }
  }
}
