/// API response model containing card groups
class ApiResponse {
  final List<CardGroup> hcGroups;

  ApiResponse({required this.hcGroups});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var groupsList = json['hc_groups'] as List? ?? [];
    return ApiResponse(
      hcGroups: groupsList.map((group) => CardGroup.fromJson(group)).toList(),
    );
  }
}

/// Represents a group of contextual cards with common design properties
class CardGroup {
  final int id;
  final String name;
  final String designType;
  final List<ContextualCard> cards;
  final bool isScrollable;
  final int height;
  final bool isFullWidth;

  CardGroup({
    required this.id,
    required this.name,
    required this.designType,
    required this.cards,
    this.isScrollable = false,
    this.height = 0,
    this.isFullWidth = false,
  });

  factory CardGroup.fromJson(Map<String, dynamic> json) {
    var cardsList = json['cards'] as List? ?? [];
    return CardGroup(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      designType: json['design_type'] ?? '',
      cards: cardsList.map((card) => ContextualCard.fromJson(card)).toList(),
      isScrollable: json['is_scrollable'] ?? false,
      height: json['height'] ?? 0,
      isFullWidth: json['is_full_width'] ?? false,
    );
  }
}

/// Individual contextual card with all its properties and styling
class ContextualCard {
  final int id;
  final String name;
  final String slug;
  final String? title;
  final FormattedText? formattedTitle;
  final String? description;
  final FormattedText? formattedDescription;
  final CardImage? icon;
  final String? url;
  final CardImage? bgImage;
  final String? bgColor;
  final Gradient? bgGradient;
  final List<CallToAction> cta;
  final int iconSize;
  final bool isDisabled;
  final bool isShareable;
  final bool isInternal;
  final bool isScrollable;
  final int height;
  final bool isFullWidth;
  final int level;

  ContextualCard({
    required this.id,
    required this.name,
    required this.slug,
    this.title,
    this.formattedTitle,
    this.description,
    this.formattedDescription,
    this.icon,
    this.url,
    this.bgImage,
    this.bgColor,
    this.bgGradient,
    this.cta = const [],
    this.iconSize = 16,
    this.isDisabled = false,
    this.isShareable = false,
    this.isInternal = false,
    this.isScrollable = false,
    this.height = 0,
    this.isFullWidth = false,
    this.level = 0,
  });

  factory ContextualCard.fromJson(Map<String, dynamic> json) {
    var ctaList = json['cta'] as List? ?? [];
    return ContextualCard(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      title: json['title'],
      formattedTitle: json['formatted_title'] != null 
          ? FormattedText.fromJson(json['formatted_title']) 
          : null,
      description: json['description'],
      formattedDescription: json['formatted_description'] != null 
          ? FormattedText.fromJson(json['formatted_description']) 
          : null,
      icon: json['icon'] != null ? CardImage.fromJson(json['icon']) : null,
      url: json['url'],
      bgImage: json['bg_image'] != null ? CardImage.fromJson(json['bg_image']) : null,
      bgColor: json['bg_color'],
      bgGradient: json['bg_gradient'] != null ? Gradient.fromJson(json['bg_gradient']) : null,
      cta: ctaList.map((cta) => CallToAction.fromJson(cta)).toList(),
      iconSize: json['icon_size'] ?? 16,
      isDisabled: json['is_disabled'] ?? false,
      isShareable: json['is_shareable'] ?? false,
      isInternal: json['is_internal'] ?? false,
      isScrollable: json['is_scrollable'] ?? false,
      height: json['height'] ?? 0,
      isFullWidth: json['is_full_width'] ?? false,
      level: json['level'] ?? 0,
    );
  }
}

/// Text with formatting and styling information
class FormattedText {
  final String text;
  final String align;
  final List<Entity> entities;

  FormattedText({
    required this.text,
    this.align = 'left',
    required this.entities,
  });

  factory FormattedText.fromJson(Map<String, dynamic> json) {
    var entitiesList = json['entities'] as List? ?? [];
    return FormattedText(
      text: json['text'] ?? '',
      align: json['align'] ?? 'left',
      entities: entitiesList.map((entity) => Entity.fromJson(entity)).toList(),
    );
  }
}

/// Individual text entity with styling properties
class Entity {
  final String text;
  final String? color;
  final String? url;
  final String? fontStyle;
  final int fontSize;
  final String fontFamily;

  Entity({
    required this.text,
    this.color,
    this.url,
    this.fontStyle,
    this.fontSize = 16,
    this.fontFamily = 'Roboto',
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      text: json['text'] ?? '',
      color: json['color'],
      url: json['url'],
      fontStyle: json['font_style'],
      fontSize: json['font_size'] ?? 16,
      fontFamily: json['font_family'] ?? 'Roboto',
    );
  }
}

/// Call-to-action button configuration
class CallToAction {
  final String text;
  final String? bgColor;
  final String? url;
  final String? textColor;

  CallToAction({
    required this.text,
    this.bgColor,
    this.url,
    this.textColor,
  });

  factory CallToAction.fromJson(Map<String, dynamic> json) {
    return CallToAction(
      text: json['text'] ?? '',
      bgColor: json['bg_color'],
      url: json['url'],
      textColor: json['text_color'],
    );
  }
}

/// Background gradient configuration
class Gradient {
  final List<String> colors;
  final int angle;

  Gradient({required this.colors, this.angle = 0});

  factory Gradient.fromJson(Map<String, dynamic> json) {
    var colorsList = json['colors'] as List? ?? [];
    return Gradient(
      colors: colorsList.map((color) => color.toString()).toList(),
      angle: json['angle'] ?? 0,
    );
  }
}

/// Image configuration for cards
class CardImage {
  final String imageType;
  final String? assetType;
  final String? imageUrl;
  final double aspectRatio;

  CardImage({
    required this.imageType,
    this.assetType,
    this.imageUrl,
    this.aspectRatio = 1.0,
  });

  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      imageType: json['image_type'] ?? '',
      assetType: json['asset_type'],
      imageUrl: json['image_url'],
      aspectRatio: (json['aspect_ratio'] ?? 1.0).toDouble(),
    );
  }
}
