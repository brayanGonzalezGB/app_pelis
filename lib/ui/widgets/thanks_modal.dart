import 'package:flutter/material.dart';

class ThanksModal extends StatelessWidget {
  final VoidCallback onClose;

  const ThanksModal({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 280,
        height: 200,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Spacer(),
            const Text(
              'Gracias por\ntu reseña',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                height: 1.2,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
