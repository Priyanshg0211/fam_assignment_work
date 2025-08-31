import 'package:fam_assignment_work/provider/cards_provider.dart';
import 'package:fam_assignment_work/widget/card_widget/contextual_cards_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreRemindLaterCards();
    });
  }

  void _restoreRemindLaterCards() {
    final provider = context.read<CardsProvider>();
    
    if (provider.isInitialized) {
      provider.restoreRemindLaterCards();
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _restoreRemindLaterCards();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          width: 86,
          height: 23,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fampaylogo.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: const ContextualCardsContainer(),
    );
  }
}
