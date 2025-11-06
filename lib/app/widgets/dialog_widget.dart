import 'package:flutter/material.dart';
import 'package:naxan_test/core/themes/custom_color.dart';

class DialogWidget extends StatefulWidget {
  final DialogWidgetController controller;
  final double screenHeight;
  final Widget child;

  const DialogWidget({
    super.key,
    required this.controller,
    required this.screenHeight,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DialogWidget> with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late final AnimationController _animCtrl;
  late final Animation<double> _anim;
  void _updateAnim() => setState(() {});

  @override
  void initState() {
    super.initState();

    // * Animation Setup.
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _anim = Tween<double>(
      begin: widget.screenHeight,
      end: 0,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));

    // * Controller setup.
    widget.controller.addListener(_updateAnim);
  }

  @override
  void didUpdateWidget(DialogWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updateAnim);
      widget.controller.addListener(_updateAnim);
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    widget.controller.removeListener(_updateAnim);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.state == DialogWidgetState.hidden) {
      return const SizedBox();
    }

    if (widget.controller.state == DialogWidgetState.open) {
      _animCtrl.forward();
    }

    if (widget.controller.state == DialogWidgetState.close) {
      _animCtrl.reverse();
    }

    return Stack(
      children: [
        if (widget.controller.state == DialogWidgetState.open)
          Container(
            color: const Color.fromARGB(108, 0, 0, 0),
            child: GestureDetector(onTap: () => widget.controller.close()),
          ),

        Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: AnimatedBuilder(
            animation: _animCtrl,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 1 * _anim.value),
                child: Container(
                  key: _key,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsGeometry.all(20),
                          child: Container(
                            width: 80,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: customGrey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        widget.child,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DialogWidgetController extends ChangeNotifier {
  DialogWidgetState state = DialogWidgetState.hidden;

  void open() {
    state = DialogWidgetState.open;
    notifyListeners();
  }

  void close() {
    state = DialogWidgetState.close;
    notifyListeners();
  }
}

enum DialogWidgetState { hidden, open, close }
