import 'package:flutter/material.dart';
import '../models/tile.dart';

class MahjongTile extends StatelessWidget {
  final Tile tile;
  final double size;
  final bool isSelected;
  final VoidCallback onTap;

  const MahjongTile({
    super.key,
    required this.tile,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: size,
          height: size * 1.35,
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513), // mahjong csempe barna
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black87, width: 3),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(3, 3))
            ],
          ),
          child: Center(
            child: Text(
              tile.type,
              style: TextStyle(
                fontSize: size * 0.55,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}