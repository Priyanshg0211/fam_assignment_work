// lib/widgets/card_widgets/hc3_widget.dart
import 'package:fam_assignment_work/provider/cards_provider.dart';
import 'package:fam_assignment_work/service/url_launcher_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/card_models.dart';
import '../common/formatted_text_widget.dart';
import '../common/card_image_widget.dart';
import '../common/gradient_container.dart';
import '../common/card_tap_handler.dart';

class HC3Widget extends StatefulWidget {
  final CardGroup group;

  const HC3Widget({super.key, required this.group});

  @override
  State<HC3Widget> createState() => _HC3WidgetState();
}

class _HC3WidgetState extends State<HC3Widget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.55, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLongPress() {
    if (!_isSliding) {
      setState(() => _isSliding = true);
      _animationController.forward();
    }
  }

  void _handleTap() {
    if (_isSliding) {
      setState(() => _isSliding = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.group.cards.isEmpty) return const SizedBox.shrink();

    final card = widget.group.cards.first;
    final cardHeight = 350.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      height: cardHeight,
      child: Stack(
        children: [
          // Action buttons (behind the card) - positioned on the LEFT side
          if (_isSliding)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Container(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      'remind later',
                      Icons.notifications_outlined,
                      () => _remindLater(card.id),
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      'dismiss now',
                      Icons.close,
                      () => _dismissCard(card.id),
                    ),
                  ],
                ),
              ),
            ),
          // Main card
          SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onLongPress: _handleLongPress,
              onTap: () {
                _handleTap();
              },
              child: _isSliding 
                ? _buildMainCard(card, cardHeight)
                : CardTapHandler(
                    card: card,
                    child: _buildMainCard(card, cardHeight),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(ContextualCard card, double cardHeight) {
    Widget cardContent = _buildCardContent(card);

    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: card.bgColor != null
            ? Color(int.parse(card.bgColor!.replaceFirst('#', '0xFF')))
            : Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
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
            // Gradient overlay if exists
            if (card.bgGradient != null)
              Positioned.fill(
                child: GradientContainer(
                  gradient: card.bgGradient!,
                  child: const SizedBox(),
                ),
              ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: cardContent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(ContextualCard card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon at top-left
        if (card.icon != null)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: CardImageWidget(
              cardImage: card.icon!,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),

        // Further reduced space after icon
        if (card.icon != null) const SizedBox(height: 30),

        // Minimal spacer to reduce gap between display text and "with action"
        const Spacer(flex: 7),

        // Title and description section - positioned below the icon
        if (card.formattedTitle != null)
          FormattedTextWidget(
            formattedText: card.formattedTitle!,
            maxLines: null,
          )
        else if (card.title?.isNotEmpty == true) ...[
          Text(
            card.title!,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (card.description?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                card.description!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],

        // Spacer to push CTA to bottom
        const Spacer(flex: 2),

        // CTA button at bottom - fixed width styling
        if (card.cta.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: card.cta
                .map(
                  (cta) => Container(
                    height: 48,
                    width: 128,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                      onPressed: () =>
                          UrlLauncherService.launchURL(cta.url ?? ''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF000000),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        cta.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 59,
          decoration: BoxDecoration(
            color: Color(0xFFF7F6F3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _remindLater(int cardId) {
    final provider = Provider.of<CardsProvider>(context, listen: false);
    
    // Animate card removal
    _animateCardRemoval(() {
      provider.remindLaterCard(cardId);
      // Removed snackbar - card will be shown on next app start
    });
  }

  void _dismissCard(int cardId) {
    final provider = Provider.of<CardsProvider>(context, listen: false);
    
    // Animate card removal
    _animateCardRemoval(() {
      provider.dismissCard(cardId);
      // Removed snackbar - card dismissed permanently
    });
  }

  void _animateCardRemoval(VoidCallback onComplete) {
    setState(() => _isSliding = false);
    _animationController.reverse().then((_) {
      onComplete();
    });
  }
}