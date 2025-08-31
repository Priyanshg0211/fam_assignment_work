// lib/widgets/card_widget/hc5_widget.dart
import 'package:flutter/material.dart';
import '../../models/card_models.dart';
import '../common/card_image_widget.dart';
import '../common/card_tap_handler.dart';
import '../common/color_utils.dart';
import '../common/formatted_text_widget.dart';

class HC5Widget extends StatelessWidget {
  final CardGroup group;

  const HC5Widget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    if (group.cards.isEmpty) return const SizedBox.shrink();
    
    final card = group.cards.first;
    // Fixed height of 129px for HC5 cards
    final height = 129.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4), // Consistent reduced margin
      height: height, // Use dynamic height
      child: CardTapHandler(
        card: card,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorUtils.parseHexColorWithDefault(card.bgColor, const Color(0xFFF8D848)), // Default yellow color
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Background image if exists
                if (card.bgImage != null)
                  Positioned.fill(
                    child: CardImageWidget(
                      cardImage: card.bgImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                
                // Content overlay
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Prevent overflow
                      children: [
                        // Icon at top-left corner
                        if (card.icon != null)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: CardImageWidget(
                              cardImage: card.icon!,
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                        
                        const Spacer(),
                        
                        // Title and description at bottom
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (card.formattedTitle != null)
                              FormattedTextWidget(
                                formattedText: card.formattedTitle!,
                                maxLines: 2,
                                defaultColor: Colors.black,
                              )
                            else if (card.title?.isNotEmpty == true)
                              Text(
                                card.title!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            
                            if (card.formattedDescription != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: FormattedTextWidget(
                                  formattedText: card.formattedDescription!,
                                  maxLines: 1,
                                  defaultColor: Colors.black87,
                                ),
                              )
                            else if (card.description?.isNotEmpty == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  card.description!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
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