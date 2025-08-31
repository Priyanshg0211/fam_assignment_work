import 'package:fam_assignment_work/service/url_launcher_service.dart';
import 'package:flutter/material.dart';
import '../../models/card_models.dart';

class CardTapHandler extends StatelessWidget {
  final ContextualCard card;
  final Widget child;

  const CardTapHandler({
    super.key,
    required this.card,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (card.url?.isNotEmpty == true) {
          UrlLauncherService.launchURL(card.url!);
        }
      },
      child: child,
    );
  }
}