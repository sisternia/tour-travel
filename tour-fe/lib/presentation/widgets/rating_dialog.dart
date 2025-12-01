import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../services/review_service.dart';

class RatingDialog extends StatefulWidget {
  final int tourId;
  final VoidCallback? onRated;

  const RatingDialog({
    super.key,
    required this.tourId,
    this.onRated,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int rating = 5;
  final TextEditingController reviewController = TextEditingController();
  bool submitting = false;

  Widget _buildStar(int index) {
    final isSelected = index < rating;

    return GestureDetector(
      onTap: () {
        setState(() => rating = index + 1);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: isSelected ? 1.2 : 1.0,
        child: Icon(
          isSelected ? Ionicons.star : Ionicons.star_outline,
          color: Colors.amber,
          size: 36,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "Đánh giá tour",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, _buildStar),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Chia sẻ cảm nhận của bạn...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                    child: const Text(
                      "Hủy",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: submitting
                        ? null
                        : () async {
                            setState(() => submitting = true);

                            bool success = await ReviewService.submitReview(
                              tourId: widget.tourId,
                              rating: rating,
                              review: reviewController.text.trim(),
                            );

                            setState(() => submitting = false);

                            if (!mounted) return;

                            if (success) {
                              widget.onRated?.call();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Gửi đánh giá thành công!"),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Gửi",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
