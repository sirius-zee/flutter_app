// lib/pages/splash_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/config/splash_config.dart';
import 'package:my_app/models/svg_path_data.dart';
import 'package:my_app/utils/svg_parser.dart';
import 'package:my_app/widgets/svg_multi_path_painter.dart';

class SplashPage extends StatefulWidget {
  final SplashConfig config;

  const SplashPage({super.key, this.config = const SplashConfig()});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _strokeAnimation;
  late Animation<double> _fillAnimation;

  List<SvgPathData> _pathList = [];
  Rect _totalBounds = Rect.zero;
  bool _isLoadingSvg = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    _strokeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.config.strokeInterval,
      ),
    );

    _fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.config.fillInterval,
      ),
    );

    _loadSvg();

    Timer(widget.config.navigateDelay, () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(widget.config.nextRoute);
      }
    });
  }

  Future<void> _loadSvg() async {
    try {
      final result = await SvgParser.parseAsset(
        widget.config.svgAssetPath,
        defaultColor: widget.config.defaultFillColor,
      );

      if (mounted) {
        setState(() {
          _pathList = result.pathList;
          _totalBounds = result.totalBounds;
          _isLoadingSvg = false;
        });

        _animationController.forward();
      }
    } catch (e) {
      debugPrint('Error loading SVG: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero disempurnakan dengan flightShuttleBuilder
            Hero(
              tag: widget.config.heroTag,
              flightShuttleBuilder:
                  (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    // Ambil widget tujuan (LoginPage) secara aman
                    final Widget toHeroWidget = toHeroContext.widget;

                    return Material(
                      color: Colors.transparent,
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                        child: toHeroWidget,
                      ),
                    );
                  },
              child: SizedBox(
                width: widget.config.logoWidth,
                height: widget.config.logoHeight,
                child: _isLoadingSvg || _pathList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return CustomPaint(
                            size: Size(
                              widget.config.logoWidth,
                              widget.config.logoHeight,
                            ),
                            painter: SvgMultiPathPainter(
                              pathList: _pathList,
                              totalBounds: _totalBounds,
                              strokeProgress: _strokeAnimation.value,
                              fillProgress: _fillAnimation.value,
                              strokeWidth: widget.config.strokeWidth,
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              widget.config.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.config.subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
