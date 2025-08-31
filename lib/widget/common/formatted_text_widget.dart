// lib/widgets/common/formatted_text_widget.dart
import 'package:fam_assignment_work/service/url_launcher_service.dart';
import 'package:flutter/material.dart';
import '../../models/card_models.dart';

class FormattedTextWidget extends StatelessWidget {
  final FormattedText formattedText;
  final int? maxLines;
  final Color? defaultColor;

  const FormattedTextWidget({
    super.key,
    required this.formattedText,
    this.maxLines,
    this.defaultColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return _buildRichText();
  }

  Widget _buildRichText() {
    // If text is empty but we have entities, display only the entities
    if (formattedText.text.trim().isEmpty && formattedText.entities.isNotEmpty) {
      return _buildEntitiesOnly();
    }
    
    if (formattedText.entities.isEmpty) {
      return Text(
        formattedText.text,
        style: TextStyle(
          color: defaultColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        textAlign: _getTextAlign(),
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
      );
    }

    // Handle text with entities - replace {} with entity text
    List<Widget> widgets = [];
    String remainingText = formattedText.text;
    int entityIndex = 0;

    // Process each {} placeholder
    while (remainingText.contains('{}') && entityIndex < formattedText.entities.length) {
      int placeholderIndex = remainingText.indexOf('{}');
      
      // Add text before the placeholder
      if (placeholderIndex > 0) {
        String textBefore = remainingText.substring(0, placeholderIndex);
        widgets.addAll(_splitTextIntoLines(textBefore));
      }
      
      // Add the entity
      widgets.addAll(_splitEntityIntoLines(formattedText.entities[entityIndex]));
      
      // Remove processed text and placeholder
      remainingText = remainingText.substring(placeholderIndex + 2);
      entityIndex++;
    }
    
    // Add any remaining text
    if (remainingText.isNotEmpty) {
      widgets.addAll(_splitTextIntoLines(remainingText));
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    );
  }

  List<Widget> _splitTextIntoLines(String text) {
    List<String> lines = text.split('\n');
    List<Widget> widgets = [];
    
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].isNotEmpty) {
        // For "with action" text, use white color and 30px font size
        bool isWithAction = lines[i].trim() == 'with action';
        Color textColor = isWithAction 
            ? Colors.white 
            : (defaultColor ?? Colors.white);
        double fontSize = isWithAction ? 30.0 : 16.0;
        FontWeight fontWeight = isWithAction ? FontWeight.w700 : FontWeight.w400;
            
        widgets.add(Container(
          width: double.infinity,
          child: Text(
            lines[i],
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              height: 1.2, // Better line height for larger text
            ),
            textAlign: _getTextAlign(),
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
          ),
        ));

        // Add extra spacing after "with action" text
        if (isWithAction) {
          widgets.add(const SizedBox(height: 12));
        }
      }
      
      // Add spacing between lines (except for the last line and after "with action")
      if (i < lines.length - 1 && lines[i].trim() != 'with action') {
        widgets.add(const SizedBox(height: 4));
      }
    }
    
    return widgets;
  }

  List<Widget> _splitEntityIntoLines(Entity entity) {
    List<String> lines = entity.text.split('\n');
    List<Widget> widgets = [];
    
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].isNotEmpty) {
        if (entity.url != null && entity.url!.isNotEmpty) {
          widgets.add(GestureDetector(
            onTap: () => UrlLauncherService.launchURL(entity.url!),
            child: Text(
              lines[i],
              style: TextStyle(
                color: _parseColor(entity.color),
                fontSize: entity.fontSize.toDouble(),
                fontWeight: _getFontWeight(entity.fontFamily),
                fontStyle: entity.fontStyle == 'italic' 
                    ? FontStyle.italic 
                    : FontStyle.normal,
                decoration: TextDecoration.underline, // Show it's clickable
              ),
            ),
          ));
        } else {
          widgets.add(Container(
            width: double.infinity,
            child: Text(
              lines[i],
              style: TextStyle(
                color: _parseColor(entity.color),
                fontSize: entity.fontSize.toDouble(),
                fontWeight: _getFontWeight(entity.fontFamily),
                fontStyle: entity.fontStyle == 'italic' 
                    ? FontStyle.italic 
                    : FontStyle.normal,
              ),
              textAlign: _getTextAlign(),
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
            ),
          ));
        }
      }
      
      // Add spacing between lines (except for the last line)
      if (i < lines.length - 1) {
        widgets.add(const SizedBox(height: 4));
      }
    }
    
    return widgets;
  }

  Color _parseColor(String? colorString) {
    if (colorString == null) return defaultColor ?? Colors.white;
    
    try {
      String colorStr = colorString;
      if (colorStr.startsWith('#')) {
        colorStr = colorStr.replaceFirst('#', '0xFF');
      }
      return Color(int.parse(colorStr));
    } catch (e) {
      return defaultColor ?? Colors.white;
    }
  }

  Widget _buildEntitiesOnly() {
    List<Widget> widgets = [];
    
    for (int i = 0; i < formattedText.entities.length; i++) {
      widgets.addAll(_splitEntityIntoLines(formattedText.entities[i]));
      
      // Add space between entities if not the last one
      if (i < formattedText.entities.length - 1) {
        widgets.add(const SizedBox(height: 8));
      }
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    );
  }

  FontWeight _getFontWeight(String fontFamily) {
    String lowerFamily = fontFamily.toLowerCase();
    if (lowerFamily.contains('bold') || lowerFamily.contains('semi_bold')) {
      return FontWeight.w600;
    }
    return FontWeight.w400;
  }

  TextAlign _getTextAlign() {
    switch (formattedText.align.toLowerCase()) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }
}