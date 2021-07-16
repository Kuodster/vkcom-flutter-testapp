import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:syazanou/modules/vk/widgets/newsfeed/stat_counter.dart';

enum LikeButtonStyle { sparks, fireworks, heart }

class LikeButton extends StatefulWidget {
  final bool liked;
  final int count;
  final LikeButtonStyle style;

  const LikeButton({
    Key? key,
    this.liked = false,
    this.count = 0,
    this.style = LikeButtonStyle.heart,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  late final AnimationController _controller;

  int get count => widget.count;

  bool get liked => widget.liked;

  LikeButtonStyle get style => widget.style;

  /*bool _visible = false;*/

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: _animationDurationMs(),
      ),
      value: _initialAnimationValue(),
    );

    //..addStatusListener(_animationStatusChanged)
  }

  void _animateOnce() {
    if (style == LikeButtonStyle.heart && _controller.value == 1.0) {
      _controller.reverse(from: 1.0);
    } else if (liked) {
      _controller.forward(from: 0.0);
    }
  }

  /*void _animationStatusChanged(AnimationStatus status) {
    bool? visible;
    if (status == AnimationStatus.forward) {
      visible = true;
    } else if (status == AnimationStatus.completed) {
      visible = false;
    }
    if (visible != null) {
      setState(() {
        _visible = visible!;
      });
    }
  }*/

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    if (liked != oldWidget.liked) {
      _animateOnce();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    //_controller.removeStatusListener(_animationStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        StatCounter(
          count: count,
          icon: _buildIcon(),
        ),
        _buildAnimation(),
      ],
    );
  }

  double _initialAnimationValue() {
    switch (style) {
      case LikeButtonStyle.heart:
        return liked ? 1.0 : 0.0;
      default:
        return 0;
    }
  }

  Widget _buildIcon() {
    final baseTextStyle = Theme.of(context).textTheme.bodyText2!;

    switch (style) {
      // We do not need an icon for heart style, just a simple 24x24 placeholder (24 - default icon size)
      case LikeButtonStyle.heart:
        return const SizedBox(
          height: 24.0,
          width: 24.0,
        );
      default:
        return FaIcon(
          liked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          color: liked ? _likedColor() : baseTextStyle.color!.withOpacity(0.7),
        );
    }
  }

  int _animationDurationMs() {
    switch (style) {
      case LikeButtonStyle.heart:
        return 600;
      case LikeButtonStyle.fireworks:
        return 2500;
      default:
        return 1000;
    }
  }

  Color _likedColor() {
    switch (style) {
      case LikeButtonStyle.fireworks:
        return Colors.orange;
      default:
        return const Color(0xffea5398);
    }
  }

  Widget _buildAnimation() {
    switch (style) {
      case LikeButtonStyle.heart:
        return Positioned(
          left: 10.0,
          child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: Lottie.asset(
              'assets/lottie/like-heart.json',
              controller: _controller,
            ),
          ),
        );
      case LikeButtonStyle.fireworks:
        return Positioned(
          left: -40.0,
          top: -100.0,
          child: SizedBox(
            width: 120.0,
            height: 120.0,
            child: Lottie.asset(
              'assets/lottie/like-fireworks.json',
              controller: _controller,
            ),
          ),
        );

      default:
        return Positioned(
          left: -18.0,
          top: -23.0,
          child: SizedBox(
            width: 80.0,
            height: 80.0,
            child: Lottie.asset(
              'assets/lottie/like-sparks.json',
              controller: _controller,
            ),
          ),
        );
    }
  }
}
