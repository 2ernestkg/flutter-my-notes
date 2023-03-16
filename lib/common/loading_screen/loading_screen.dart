import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/common/loading_screen/loading_screen_controller.dart';

class LoadingScreen {
  factory LoadingScreen() => _instance;
  static final LoadingScreen _instance = LoadingScreen._privateContructor();
  LoadingScreen._privateContructor();

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller == null) {
      _controller = showOverlay(
        context: context,
        text: text,
      );
    } else {
      _controller?.updateFn(text);
    }
  }

  void hide() {
    _controller?.closeFn();
    _controller == null;
  }

  LoadingScreenController showOverlay(
      {required BuildContext context, required String text}) {
    final textController = StreamController<String>();
    textController.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    OverlayEntry? overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder(
                        stream: textController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      closeFn: () {
        textController.close();
        if (overlay != null) {
          overlay?.remove();
          overlay = null;
        }
        return true;
      },
      updateFn: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
