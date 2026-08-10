import 'dart:async';
import 'package:flutter/material.dart';
import '../config/splash_config.dart';
import '../models/svg_path_data.dart';
import '../utils/svg_parser.dart';
import '../widgets/svg_multi_path_painter.dart';

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
        Navigator.pushReplacementNamed(context, widget.config.nextRoute);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
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
            const SizedBox(height: 40),
            Text(
              widget.config.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.config.subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
