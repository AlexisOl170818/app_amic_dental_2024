import 'package:app_amic_dental_2024/models/item_option.dart';
import 'package:app_amic_dental_2024/widgets/icon_label.dart';
import 'package:flutter/material.dart';

class OptionItem extends StatefulWidget {
  const OptionItem({
    super.key,
    required this.item,
  });

  final ItemOption item;

  @override
  State<OptionItem> createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _scaleAnimation = Tween(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Color bgCard = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          color: bgCard,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          elevation: 5,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.black12,
            onTap: () {
              if (widget.item.function != null) widget.item.function!();
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/noimage.gif'),
                    image: NetworkImage(widget.item.urlImage),
                    fit: BoxFit.fill,
                    height: 200,
                    width: double.infinity,
                    imageErrorBuilder: ((context, error, stackTrace) =>
                        const Image(
                          image: AssetImage('assets/noimage.gif'),
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        )),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.item.name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        /*  IconLabel(icon: item.icon, label: "Ingresar") */
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
