// lib/widgets/card_widget/hc6_widget.dart
import 'package:flutter/material.dart';
import '../../models/card_models.dart';
import '../common/card_image_widget.dart';
import '../common/card_tap_handler.dart';

class HC6Widget extends StatelessWidget {
  final CardGroup group;

  const HC6Widget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    if (group.cards.isEmpty) return const SizedBox.shrink();
    
    final card = group.cards.first;
    
    // Extract the actual text from entities if formatted_title exists
    String displayText = '';
    if (card.formattedTitle != null && card.formattedTitle!.entities.isNotEmpty) {
      displayText = card.formattedTitle!.entities.map((e) => e.text).join('');
    } else if (card.title != null && card.title!.trim().isNotEmpty) {
      displayText = card.title!;
    } else {
      displayText = 'No Title Available';
    }
    
    // Fixed height of 60px for HC6 cards
    final cardHeight = 60.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4), // Reduced margin
      height: cardHeight, // Use dynamic height
      child: CardTapHandler(
        card: card,
        child: Container(
          width: card.isFullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced vertical padding
          decoration: BoxDecoration(
            color: card.bgColor != null 
                ? Color(int.parse(card.bgColor!.replaceFirst('#', '0xFF'))) 
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300, 
              width: 1
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon from API
              if (card.icon != null)
                Container(
                  width: card.iconSize.toDouble().clamp(30.0, 40.0), // Clamp icon size
                  height: card.iconSize.toDouble().clamp(30.0, 40.0),
                  child: CardImageWidget(
                    cardImage: card.icon!,
                    width: card.iconSize.toDouble().clamp(30.0, 40.0),
                    height: card.iconSize.toDouble().clamp(30.0, 40.0),
                    fit: BoxFit.contain,
                  ),
                ),
              
              if (card.icon != null) const SizedBox(width: 12),
              
              // Title text - Fixed to show text from entities with proper overflow handling
              Expanded(
                child: Text(
                  displayText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.3, // Better line height
                  ),
                  maxLines: cardHeight > 80 ? 2 : 1, // Allow 2 lines for taller cards
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Arrow icon (show if there's a URL)
              if (card.url != null) const SizedBox(width: 8),
              if (card.url != null)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.black,
                ),
            ],
          ),
        ),
      ),
    );
  }
}