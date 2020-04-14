import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

const double _kFlingVelocity = 2.0; //动画速度

class Backdrop extends StatefulWidget {
  final currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({
    @required this.currentCategory,
    @required this.frontLayer,
    @required this.backLayer,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(frontLayer != null),
        assert(backLayer != null),
        assert(frontTitle != null),
        assert(backTitle != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  // Add AnimationController widget (104)
  AnimationController _controller;

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);

    if (widget.currentCategory.name != old.currentCategory.name) {
      _toggleBackdropLayerVisibility();
    } else
      if (!_frontLayerVisible) {
      _controller.fling(velocity: _kFlingVelocity);
    }
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;
    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);
    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
            rect: layerAnimation,
            child: _FrontLayer(
              child: widget.frontLayer,
              onTap: _toggleBackdropLayerVisibility,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = CupertinoNavigationBar(
      brightness: Brightness.light,
      leading: FlatButton(
        child: Row(
          children: <Widget>[Icon(Icons.keyboard_arrow_down,color: CupertinoColors.activeBlue,), Text('题库',style: TextStyle(color: CupertinoColors.activeBlue,fontSize: 15),)],
        ),
        onPressed: _toggleBackdropLayerVisibility,
      ),
      middle:GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleBackdropLayerVisibility,
        child: Text('离散数学')
        ),
      trailing: FlatButton(
        child: Icon(
          Icons.search,
          semanticLabel: 'search',
        ),
        onPressed: () {
          // TODO: Add open login (104)
        },
      ),
    );
    return CupertinoPageScaffold(
      navigationBar: appBar,
      // TODO: Return a LayoutBuilder widget (104)
      child: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}

class _FrontLayer extends StatelessWidget {
  // TODO: Add on-tap callback (104)
  const _FrontLayer({Key key, this.child, this.onTap}) : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: Material(
        elevation: 16.0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                // TODO front page style
                decoration: null,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
