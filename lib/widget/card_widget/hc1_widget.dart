// lib/widgets/card_widget/hc1_widget.dart
import 'package:flutter/material.dart';
import '../../models/card_models.dart';
import '../common/formatted_text_widget.dart';
import '../common/card_image_widget.dart';
import '../common/card_tap_handler.dart';

class HC1Widget extends StatelessWidget {
  final CardGroup group;

  const HC1Widget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final height = group.height > 0 ? group.height.toDouble() : 64.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4), // Consistent reduced margin
      height: height,
      child: _buildCardContainer(),
    );
  }

  Widget _buildCardContainer() {
    // If only one card, display it without scrolling
    if (group.cards.length == 1) {
      return _buildCard(group.cards.first);
    }
    
    // If multiple cards, check if scrolling is needed
    if (group.isScrollable) {
      // Horizontal scrollable list when is_scrollable = true
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: group.cards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _buildCard(group.cards[index]),
      );
    } else {
      // Row layout when is_scrollable = false (all cards fit)
      return Row(
        children: group.cards
            .asMap()
            .entries
            .map((entry) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: entry.key < group.cards.length - 1 ? 12 : 0
                    ),
                    child: _buildCard(entry.value),
                  ),
                ))
            .toList(),
      );
    }
  }

  Widget _buildCard(ContextualCard card) {
    // Use the background color from JSON, default to #FBAF03 if not specified
    Color backgroundColor = card.bgColor != null 
        ? Color(int.parse(card.bgColor!.replaceFirst('#', '0xFF')))
        : const Color(0xFFFBAF03);

    // Check if card has URL to determine if arrow should be shown
    bool hasUrl = card.url != null && card.url!.isNotEmpty;

    return CardTapHandler(
      card: card,
      child: Container(
        // Increased width for scrollable cards to prevent text overflow
        width: group.isScrollable ? 280 : null,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar/Profile picture on the left
            if (card.icon != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CardImageWidget(
                    cardImage: card.icon!,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            if (card.icon != null) const SizedBox(width: 12),
            
            // Text content in the middle - Title and Subtitle with proper overflow handling
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title from formatted_title entities
                  if (card.formattedTitle != null && 
                      card.formattedTitle!.entities.isNotEmpty &&
                      card.formattedTitle!.entities.first.text.trim().isNotEmpty)
                    FormattedTextWidget(
                      formattedText: card.formattedTitle!,
                      maxLines: 1,
                      defaultColor: Colors.black,
                    ),
                  
                  // Description from formatted_description entities  
                  if (card.formattedDescription != null && 
                      card.formattedDescription!.entities.isNotEmpty &&
                      card.formattedDescription!.entities.first.text.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: FormattedTextWidget(
                        formattedText: card.formattedDescription!,
                        maxLines: 1,
                        defaultColor: Colors.black.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
            
            // Arrow icon on the right - only show if card has URL
            if (hasUrl)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}