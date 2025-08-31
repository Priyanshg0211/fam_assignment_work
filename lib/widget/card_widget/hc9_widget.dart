// lib/widgets/card_widget/hc9_widget.dart
import 'package:flutter/material.dart';
import '../../models/card_models.dart';
import '../common/card_image_widget.dart';
import '../common/gradient_container.dart';
import '../common/card_tap_handler.dart';
import '../common/color_utils.dart';
import '../common/formatted_text_widget.dart';

class HC9Widget extends StatelessWidget {
  final CardGroup group;

  const HC9Widget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final height = group.height > 0 ? group.height.toDouble() : 195.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4), // Consistent reduced margin
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: group.cards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _buildCard(group.cards[index], height),
      ),
    );
  }

  Widget _buildCard(ContextualCard card, double height) {
    double cardWidth = height * 0.6; // Default aspect ratio
    
    // Calculate width based on aspect ratio if bg_image exists
    if (card.bgImage != null && card.bgImage!.aspectRatio > 0) {
      cardWidth = height * card.bgImage!.aspectRatio;
    }
    
    // Ensure minimum and maximum widths
    cardWidth = cardWidth.clamp(80.0, 200.0);

    return CardTapHandler(
      card: card,
      child: Container(
        width: cardWidth,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background color
              Container(
                color: ColorUtils.parseHexColorWithDefault(card.bgColor, const Color(0xFF6C5CE7)), // Default purple
              ),
              
              // Background image
              if (card.bgImage != null)
                Positioned.fill(
                  child: CardImageWidget(
                    cardImage: card.bgImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              
              // Gradient overlay
              if (card.bgGradient != null)
                Positioned.fill(
                  child: GradientContainer(
                    gradient: card.bgGradient!,
                    child: const SizedBox(),
                  ),
                ),
              
              // Content overlay for text
              if (_hasTextContent(card))
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Prevent overflow
                    children: [
                      // Icon at top if exists
                      if (card.icon != null)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: CardImageWidget(
                            cardImage: card.icon!,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        ),
                      
                      const Spacer(),
                      
                      // Title at bottom with proper constraints
                      if (card.formattedTitle != null)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: height * 0.3, // Max 30% of card height
                          ),
                          child: FormattedTextWidget(
                            formattedText: card.formattedTitle!,
                            maxLines: 2,
                            defaultColor: Colors.white,
                          ),
                        )
                      else if (card.title?.isNotEmpty == true)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: height * 0.3,
                          ),
                          child: Text(
                            card.title!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      
                      // Description with proper constraints
                      if (card.formattedDescription != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: height * 0.15, // Max 15% of card height
                            ),
                            child: FormattedTextWidget(
                              formattedText: card.formattedDescription!,
                              maxLines: 1,
                              defaultColor: Colors.white70,
                            ),
                          ),
                        )
                      else if (card.description?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: height * 0.15,
                            ),
                            child: Text(
                              card.description!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasTextContent(ContextualCard card) {
    return (card.title?.isNotEmpty == true || 
            card.formattedTitle != null ||
            card.description?.isNotEmpty == true ||
            card.formattedDescription != null ||
            card.icon != null);
  }
}