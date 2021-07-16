import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:syazanou/modules/vk/widgets/newsfeed/stat_counter.dart';

enum LikeButtonStyle { sparks, fireworks }

class LikeButton extends StatefulWidget {
  final bool liked;
  final int count;
  final LikeButtonStyle style;

  const LikeButton({
    Key? key,
    this.liked = false,
    this.count = 0,
    this.style = LikeButtonStyle.sparks,
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
    );

    //..addStatusListener(_animationStatusChanged)
  }

  void _animateOnce() {
    _controller.forward(from: 0.0);
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
    if (liked && liked != oldWidget.liked) {
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
    final baseTextStyle = Theme.of(context).textTheme.bodyText2!;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        StatCounter(
          count: count,
          icon: FaIcon(
            liked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
            color:
                liked ? _likedColor() : baseTextStyle.color!.withOpacity(0.7),
          ),
        ),
        _buildAnimation(),
      ],
    );
  }

  int _animationDurationMs() {
    switch (style) {
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
