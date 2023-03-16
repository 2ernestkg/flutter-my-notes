typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

class LoadingScreenController {
  final CloseLoadingScreen closeFn;
  final UpdateLoadingScreen updateFn;

  LoadingScreenController({
    required this.closeFn,
    required this.updateFn,
  });
}
