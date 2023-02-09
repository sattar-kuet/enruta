import 'package:flutter/material.dart';



class LoadingIndicator extends StatelessWidget {
  final Widget? child;
  final LoadingIndicatorType indicatorType;

  final ValueNotifier<LoadingStatus>? loadingStatusNotifier;

  const LoadingIndicator({
   
 this.child,
    this.indicatorType = LoadingIndicatorType.Overlay,
     this.loadingStatusNotifier,
  }) ;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LoadingStatus>(
      valueListenable: loadingStatusNotifier!,
      child: child,
      builder: (_, LoadingStatus value, Widget? builderChild) {
        late Widget content;

        switch (indicatorType) {
          // Overlay...
          case LoadingIndicatorType.Overlay:
            List<Widget> children = [
              builderChild ?? const SizedBox.shrink(),
            ];

            if (value == LoadingStatus.Show) {
              children.add(loadingIndicator(context));
            }

            content = Stack(children: children);
            break;

          // Normal spinner...
          case LoadingIndicatorType.Spinner:
            content = value == LoadingStatus.Show
                ?  Center(
                    child: CircularProgressIndicator(
                   
                  ))
                : (builderChild ?? const SizedBox.shrink());
            break;
        }

        return content;
      },
    );
  }

  // Loading Indicator...
  Widget loadingIndicator(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black54,
      body: Center(
          child: CircularProgressIndicator(
        
      )),
    );
  }
}

//------ Loading Status Notifier ----//
class LoadingIndicatorNotifier extends ChangeNotifier {
  final ValueNotifier<LoadingStatus> _loadingStatus =
      ValueNotifier<LoadingStatus>(LoadingStatus.Hide);

  ValueNotifier<LoadingStatus> get statusNotifier => _loadingStatus;

  LoadingStatus get loadingStatus => _loadingStatus.value;

  void show() {
    _loadingStatus.value = LoadingStatus.Show;
    notifyListeners();
  }

  void hide() {
    _loadingStatus.value = LoadingStatus.Hide;
    notifyListeners();
  }

  void disposeNotifier() {
    _loadingStatus.dispose();
  }
}

enum LoadingIndicatorType {
  Overlay,
  Spinner,
}
enum LoadingStatus {
  Show,
  Hide,
}
