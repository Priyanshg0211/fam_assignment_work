
import 'package:fam_assignment_work/provider/cards_provider.dart';
import 'package:fam_assignment_work/widget/card_widget/hc1_widget.dart';
import 'package:fam_assignment_work/widget/card_widget/hc3_widget.dart';
import 'package:fam_assignment_work/widget/card_widget/hc5_widget.dart';
import 'package:fam_assignment_work/widget/card_widget/hc6_widget.dart';
import 'package:fam_assignment_work/widget/card_widget/hc9_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Main container that renders different types of contextual cards
class ContextualCardsContainer extends StatelessWidget {
  const ContextualCardsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CardsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const ShimmerLoading();
        }

        if (provider.error != null) {
          return _buildErrorView(provider, context);
        }

        if (provider.cardGroups.isEmpty) {
          return _buildEmptyView(provider, context);
        }

        return _buildCardsList(provider);
      },
    );
  }

  Widget _buildErrorView(CardsProvider provider, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchCards(),
      color: Colors.blue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pull down to refresh',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => provider.fetchCards(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(CardsProvider provider, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchCards(),
      color: Colors.blue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No cards available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for new content',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardsList(CardsProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchCards(),
      color: Colors.blue,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.cardGroups.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final group = provider.cardGroups[index];
          return _buildCardGroup(group);
        },
      ),
    );
  }

  Widget _buildCardGroup(CardGroup group) {
    if (group.cards.isEmpty) {
      return const SizedBox.shrink();
    }

    switch (group.designType.toUpperCase()) {
      case 'HC1':
        return HC1Widget(group: group);
      case 'HC3':
        return HC3Widget(group: group);
      case 'HC5':
        return HC5Widget(group: group);
      case 'HC6':
        return HC6Widget(group: group);
      case 'HC9':
        return HC9Widget(group: group);
      default:
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            'Unknown card type: ${group.designType}',
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        );
    }
  }
}