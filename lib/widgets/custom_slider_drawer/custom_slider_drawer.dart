import 'package:flutter/material.dart';

/// Custom Slider Drawer Configuration
class CustomSliderDrawerConfig {
  final Color backgroundColor;
  final Widget? title;
  final Widget? trailing;
  final EdgeInsets? padding;

  const CustomSliderDrawerConfig({
    this.backgroundColor = Colors.blue,
    this.title,
    this.trailing,
    this.padding,
  });
}

/// Custom Slider AppBar
class CustomSliderAppBar extends StatelessWidget {
  final CustomSliderDrawerConfig config;

  const CustomSliderAppBar({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: config.backgroundColor,
      padding: config.padding ?? const EdgeInsets.fromLTRB(20, 35, 22, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          config.title ?? const SizedBox(),
          config.trailing ?? const SizedBox(),
        ],
      ),
    );
  }
}

/// Custom Slider Drawer State
class CustomSliderDrawerState extends State<CustomSliderDrawer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    if (_isDrawerOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void openDrawer() {
    if (!_isDrawerOpen) {
      _animationController.forward();
      setState(() {
        _isDrawerOpen = true;
      });
    }
  }

  void closeDrawer() {
    if (_isDrawerOpen) {
      _animationController.reverse();
      setState(() {
        _isDrawerOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const drawerWidth = 280.0;

    return Scaffold(
      body: Stack(
        children: [
          // Drawer
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: drawerWidth,
            child: widget.slider,
          ),
          // Main content
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              final slideOffset = _slideAnimation.value * drawerWidth;
              final scale = 1.0 - (_slideAnimation.value * 0.15);

              return Transform.translate(
                offset: Offset(slideOffset, 0),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: _isDrawerOpen
                          ? BorderRadius.circular(20)
                          : BorderRadius.zero,
                      boxShadow: _isDrawerOpen
                          ? [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(80),
                        child: Stack(
                          children: [
                            widget.appBar,
                            Positioned(
                              left: 20,
                              top: 45,
                              child: GestureDetector(
                                onTap: toggleDrawer,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    _isDrawerOpen ? Icons.close : Icons.menu,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: widget.child,
                    ),
                  ),
                ),
              );
            },
          ),
          // Overlay to close drawer when tapping outside
          if (_isDrawerOpen)
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  left: drawerWidth * _slideAnimation.value,
                  child: GestureDetector(
                    onTap: closeDrawer,
                    child: Container(
                      color: Colors.black
                          .withValues(alpha: 0.3 * _slideAnimation.value),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Custom Slider Drawer Widget
class CustomSliderDrawer extends StatefulWidget {
  final Widget slider;
  final Widget child;
  final Widget appBar;
  final int animationDuration;

  const CustomSliderDrawer({
    super.key,
    required this.slider,
    required this.child,
    required this.appBar,
    this.animationDuration = 300,
  });

  @override
  CustomSliderDrawerState createState() => CustomSliderDrawerState();
}
