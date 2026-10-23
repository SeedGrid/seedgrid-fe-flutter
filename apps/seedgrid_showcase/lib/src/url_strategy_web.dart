// Web: URL por caminho (/sg-button#exemplo-3). Com a estrategia padrao (hash) o fragmento da ancora
// colidiria com a rota (#/sg-button).
import 'package:flutter_web_plugins/url_strategy.dart';

void configureUrlStrategy() => usePathUrlStrategy();
