import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ══════════════════════════════════════════════════
//  PRESSABLE SCALE — tap-down shrinks, release bounces back
// ══════════════════════════════════════════════════
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.96,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  SHIMMER — animated gradient overlay for skeleton loaders
// ══════════════════════════════════════════════════
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircle;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 6,
    this.isCircle = false,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
    final highlightColor = isDark ? const Color(0xFF374151) : const Color(0xFFF1F5F9);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.isCircle ? null : BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-1.0 + 2.0 * _controller.value + 1.0, 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════
//  FADE PAGE ROUTE — smooth cross-fade transition
// ══════════════════════════════════════════════════
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppDurations.slow,
          reverseTransitionDuration: AppDurations.normal,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        );
}

// ══════════════════════════════════════════════════
//  SLIDE-FADE PAGE ROUTE — slide up + fade in
// ══════════════════════════════════════════════════
class SlideFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideFadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppDurations.slow,
          reverseTransitionDuration: AppDurations.normal,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: child,
              ),
            );
          },
        );
}

// ══════════════════════════════════════════════════
//  ANIMATED CONNECT BUTTON — smooth color + icon morph
// ══════════════════════════════════════════════════
class AnimatedConnectButton extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onPressed;
  final double? height;

  const AnimatedConnectButton({
    super.key,
    required this.isConnected,
    required this.onPressed,
    this.height = 34,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: PressableScale(
        onTap: onPressed,
        scaleFactor: 0.93,
        child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isConnected ? AppColors.success : AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: AppDurations.fast,
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isConnected ? Icons.check_rounded : Icons.person_add_outlined,
                  key: ValueKey(isConnected),
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AnimatedSwitcher(
                duration: AppDurations.fast,
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: Text(
                  isConnected ? 'Connected' : '+ Connect',
                  key: ValueKey(isConnected ? 'y' : 'n'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
