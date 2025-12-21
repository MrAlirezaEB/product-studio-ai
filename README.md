# Product Studio AI

Transform product photos into professional studio-style marketing images using AI (Nano Banana Pro 3).

## Features

- 📸 **Easy Image Capture** - Take photos or select from gallery
- ✂️ **Smart Cropping** - Crop your product with 4:5 aspect ratio
- 🎨 **Studio Vibes** - Choose from 4 professional styles:
  - Minimalist White
  - Luxury Dark
  - Nature/Outdoor
  - Pastel Pop
- 🤖 **AI Enhancement** - Powered by Google's Gemini AI
- 💾 **Save & Share** - Save to gallery or share directly
- 📱 **Project Gallery** - View all your AI-generated photos

## Setup

### 1. Install Flutter
Make sure you have Flutter installed. Visit [flutter.dev](https://flutter.dev) for installation instructions.

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Configure API Key
1. Get a Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Open `.env` file in the project root
3. Replace `your_api_key_here` with your actual API key:
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

### 4. Run the App
```bash
# For Android
flutter run

# For iOS
flutter run
```

## Architecture

- **State Management**: Riverpod
- **Networking**: Dio
- **Image Handling**: image_picker, image_cropper
- **Storage**: path_provider, image_gallery_saver
- **Sharing**: share_plus

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── project.dart            # Project data model
│   └── studio_vibe.dart        # Studio style definitions
├── providers/
│   └── project_provider.dart   # State management
├── screens/
│   ├── home_screen.dart        # Project gallery
│   ├── image_capture_screen.dart # Camera/Gallery picker
│   ├── studio_setup_screen.dart  # Vibe selection
│   ├── processing_screen.dart    # AI processing UI
│   └── result_screen.dart        # Before/After comparison
└── services/
    └── gemini_service.dart     # Gemini API integration
```

## Notes

- The app requires camera and photo library permissions
- Image generation takes 10-30 seconds depending on connection
- Generated images are stored locally on the device

## License

This is a demonstration project for educational purposes.
