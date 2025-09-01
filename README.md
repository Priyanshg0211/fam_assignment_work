# FamPay Flutter Assignment - Contextual Cards

A Flutter application that displays dynamic contextual cards based on API responses. This is a plug-and-play component that can be integrated into any screen/widget.

## 🚀 Features

### ✅ Implemented Features
- **Dynamic Card Rendering**: Renders 5 different card types (HC1, HC3, HC5, HC6, HC9) based on API response
- **Formatted Text Support**: Handles text with entities, colors, fonts, and deep links
- **Deep Link Handling**: All card URLs, CTA URLs, and entity URLs are properly handled
- **Long Press Actions**: HC3 cards slide to reveal "remind later" and "dismiss now" actions
- **Card Persistence**: 
  - "Remind later" cards are hidden until next app start
  - "Dismiss now" cards are permanently hidden
- **Swipe to Refresh**: Pull down to refresh the card list
- **Loading States**: Beautiful shimmer loading animations
- **Error Handling**: Proper error states with retry functionality
- **Responsive Design**: Handles both scrollable and non-scrollable card groups
- **Image Support**: External images with caching and fallbacks
- **Gradient Support**: Dynamic gradient backgrounds based on API data

### 🎨 Card Types Supported
- **HC1 (Small Display Card)**: Profile cards with avatar and text
- **HC3 (Big Display Card)**: Large cards with background images and CTAs
- **HC5 (Image Card)**: Cards with background images and overlay text
- **HC6 (Small Card with Arrow)**: Compact cards with icons and arrows
- **HC9 (Dynamic Width Card)**: Variable width cards with gradients

## 🛠️ Technical Implementation

### Architecture
- **Provider Pattern**: State management using Provider
- **Service Layer**: API service and URL launcher service
- **Model Classes**: Complete data models matching API schema
- **Widget Composition**: Reusable components for each card type
- **Local Storage**: SharedPreferences for card persistence

### Key Components
- `CardsProvider`: Manages card state and persistence
- `ApiService`: Fetches data from the mock API
- `ContextualCardsContainer`: Main container widget
- `FormattedTextWidget`: Handles formatted text with entities
- `CardImageWidget`: Manages image loading and caching
- `GradientContainer`: Renders dynamic gradients

## 📱 API Integration

The app integrates with the FamPay mock API:
```
https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage
```

### Schema Support
- **Formatted Text**: Text with entity substitution using `{}` placeholders
- **Entities**: Text with custom colors, fonts, and URLs
- **Card Groups**: Collections of cards with design types and scroll behavior
- **Images**: Both asset and external image support
- **Gradients**: Dynamic gradient backgrounds with custom angles
- **CTAs**: Call-to-action buttons with custom styling

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Building APK
```bash
flutter build apk --release
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── card_models.dart     # API response models
├── provider/                 # State management
│   └── cards_provider.dart  # Cards state provider
├── screens/                  # App screens
│   └── home_screen.dart     # Main screen with logo
├── service/                  # External services
│   ├── api_service.dart     # API integration
│   └── url_launcher_service.dart # Deep link handling
└── widget/                   # UI components
    ├── card_widget/         # Card type implementations
    │   ├── hc1_widget.dart  # Small display cards
    │   ├── hc3_widget.dart  # Big display cards
    │   ├── hc5_widget.dart  # Image cards
    │   ├── hc6_widget.dart  # Small cards with arrows
    │   └── hc9_widget.dart  # Dynamic width cards
    ├── common/               # Shared components
    │   ├── card_image_widget.dart    # Image handling
    │   ├── formatted_text_widget.dart # Text formatting
    │   ├── gradient_container.dart   # Gradient backgrounds
    │   ├── card_tap_handler.dart    # Card interactions
    │   └── shimmer_loading.dart     # Loading animations
    └── contextual_cards_container.dart # Main container
```

## 🔧 Dependencies

- `provider`: State management
- `http`: API communication
- `shared_preferences`: Local storage
- `url_launcher`: Deep link handling
- `cached_network_image`: Image caching
- `shimmer`: Loading animations

## 🎯 Assignment Requirements Status

| Requirement | Status | Notes |
|-------------|--------|-------|
| Standalone container | ✅ | Fully implemented |
| API integration | ✅ | Complete with error handling |
| All card types | ✅ | HC1, HC3, HC5, HC6, HC9 implemented |
| Deep link handling | ✅ | All URLs properly handled |
| Long press actions | ✅ | HC3 slide animation working |
| Card persistence | ✅ | Dismiss/remind functionality |
| Swipe to refresh | ✅ | Pull down to refresh |
| Loading states | ✅ | Shimmer loading implemented |
| Error handling | ✅ | Error states with retry |
| Code structure | ✅ | Clean, modular architecture |
| Design matching | ✅ | Follows Figma specifications |

## 🎥 Demo Recording

### App Demo Video
- **Demo Recording**: [Watch Demo Video](https://drive.google.com/drive/folders/1vFmp_zszK58ariuv5kPZtxPbIYC6TuSq?usp=sharing) 


## 🤝 Contributing

This is an assignment submission for FamPay. The code is structured for easy understanding and modification.

