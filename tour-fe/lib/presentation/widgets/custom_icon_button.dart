import 'package:flutter/material.dart';
import 'package:tour_fe/core/constants/color.dart';

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
  }) : super(key: key);

  final Widget icon;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  //bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // onEnter: (_) => setState(() => _isHovered = true),
      //onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        child: IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 40),
          color: kPrimaryColor,
          iconSize: 40.0,
          icon: widget.icon,
          splashRadius: 22,
        ),
      ),
    );
  }
}
