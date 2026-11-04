// Fora do navegador nao ha backend web: o padrao usa o pacote `camera`.
import 'sg_camera_capture.dart';

SgCameraBackend? createWebCameraBackend() => null;
