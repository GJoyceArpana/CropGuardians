import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomLogo extends StatelessWidget {
  final double size;

  const CustomLogo({
    super.key,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.circleBackground.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circle with green tint
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.circleBackground.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
          // Plant icon
          Center(
            child: CustomPaint(
              size: Size(size * 0.5, size * 0.5),
              painter: PlantIconPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class PlantIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.primaryGreen
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.fill;

    // Main stem
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.3),
      paint,
    );

    // Main leaves (center)
    final Path mainLeaf = Path();
    mainLeaf.moveTo(size.width * 0.5, size.height * 0.4);
    mainLeaf.quadraticBezierTo(
      size.width * 0.35, size.height * 0.3,
      size.width * 0.4, size.height * 0.2,
    );
    mainLeaf.quadraticBezierTo(
      size.width * 0.5, size.height * 0.25,
      size.width * 0.6, size.height * 0.2,
    );
    mainLeaf.quadraticBezierTo(
      size.width * 0.65, size.height * 0.3,
      size.width * 0.5, size.height * 0.4,
    );
    canvas.drawPath(mainLeaf, fillPaint);

    // Left floating leaf
    final Path leftLeaf = Path();
    leftLeaf.moveTo(size.width * 0.2, size.height * 0.3);
    leftLeaf.quadraticBezierTo(
      size.width * 0.1, size.height * 0.25,
      size.width * 0.15, size.height * 0.15,
    );
    leftLeaf.quadraticBezierTo(
      size.width * 0.25, size.height * 0.2,
      size.width * 0.3, size.height * 0.15,
    );
    leftLeaf.quadraticBezierTo(
      size.width * 0.3, size.height * 0.25,
      size.width * 0.2, size.height * 0.3,
    );
    canvas.drawPath(leftLeaf, fillPaint);

    // Right floating leaf
    final Path rightLeaf = Path();
    rightLeaf.moveTo(size.width * 0.8, size.height * 0.5);
    rightLeaf.quadraticBezierTo(
      size.width * 0.9, size.height * 0.45,
      size.width * 0.85, size.height * 0.35,
    );
    rightLeaf.quadraticBezierTo(
      size.width * 0.75, size.height * 0.4,
      size.width * 0.7, size.height * 0.35,
    );
    rightLeaf.quadraticBezierTo(
      size.width * 0.7, size.height * 0.45,
      size.width * 0.8, size.height * 0.5,
    );
    canvas.drawPath(rightLeaf, fillPaint);

    // Top floating leaf
    final Path topLeaf = Path();
    topLeaf.moveTo(size.width * 0.3, size.height * 0.1);
    topLeaf.quadraticBezierTo(
      size.width * 0.25, size.height * 0.05,
      size.width * 0.35, size.height * 0.02,
    );
    topLeaf.quadraticBezierTo(
      size.width * 0.4, size.height * 0.05,
      size.width * 0.45, size.height * 0.02,
    );
    topLeaf.quadraticBezierTo(
      size.width * 0.4, size.height * 0.08,
      size.width * 0.3, size.height * 0.1,
    );
    canvas.drawPath(topLeaf, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}