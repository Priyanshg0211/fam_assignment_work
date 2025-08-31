import 'package:fam_assignment_work/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_models.dart';

/// Manages the state of contextual cards including fetching, filtering, and persistence
class CardsProvider extends ChangeNotifier {
  List<CardGroup> _cardGroups = [];
  List<CardGroup> _originalCardGroups = [];
  bool _isLoading = false;
  String? _error;
  Set<int> _dismissedCards = {};
  Set<int> _remindLaterCards = {};
  bool _isInitialized = false;

  List<CardGroup> get cardGroups => _cardGroups;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  CardsProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadDismissedCards();
    await fetchCards();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getStringList('dismissed_cards') ?? [];
    final remindLater = prefs.getStringList('remind_later_cards') ?? [];
    
    _dismissedCards = dismissed.map((id) => int.parse(id)).toSet();
    _remindLaterCards = remindLater.map((id) => int.parse(id)).toSet();
  }

  Future<void> _saveDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('dismissed_cards', 
        _dismissedCards.map((id) => id.toString()).toList());
    await prefs.setStringList('remind_later_cards', 
        _remindLaterCards.map((id) => id.toString()).toList());
  }

  Future<void> fetchCards() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.fetchCards();
      _originalCardGroups = response.hcGroups;
      _cardGroups = _filterCards(_originalCardGroups);
      _error = null;
    } catch (e) {
      _error = 'Failed to load cards: ${e.toString()}';
      _cardGroups = [];
      _originalCardGroups = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  List<CardGroup> _filterCards(List<CardGroup> groups) {
    return groups.map((group) {
      final filteredCards = group.cards.where((card) {
        return !_dismissedCards.contains(card.id) && 
               !_remindLaterCards.contains(card.id);
      }).toList();
      
      return CardGroup(
        id: group.id,
        name: group.name,
        designType: group.designType,
        cards: filteredCards,
        isScrollable: group.isScrollable,
        height: group.height,
        isFullWidth: group.isFullWidth,
      );
    }).where((group) => group.cards.isNotEmpty).toList();
  }

  void dismissCard(int cardId) {
    _dismissedCards.add(cardId);
    _saveDismissedCards();
    _updateCardGroups();
  }

  void remindLaterCard(int cardId) {
    _remindLaterCards.add(cardId);
    _saveDismissedCards();
    _updateCardGroups();
  }

  void _updateCardGroups() {
    if (_originalCardGroups.isNotEmpty) {
      _cardGroups = _filterCards(_originalCardGroups);
      notifyListeners();
    }
  }

  void restoreRemindLaterCards() {
    if (!_isInitialized || _originalCardGroups.isEmpty) return;
    
    _remindLaterCards.clear();
    _saveDismissedCards();
    _cardGroups = _filterCards(_originalCardGroups);
    notifyListeners();
  }
}