# Flutter AI App - Real-time Object Detection

A powerful Flutter application that leverages TensorFlow Lite to perform real-time object detection using your device's camera or photo gallery. This project demonstrates the integration of machine learning capabilities into a mobile application, making it accessible and user-friendly.

## 🌟 Features

- **Real-time Object Detection**: Detect objects in real-time using your device's camera
- **Gallery Analysis**: Analyze images from your photo gallery
- **Bounding Boxes**: Visual representation of detected objects with confidence scores
- **Firebase Integration**: Store detection history and images in the cloud
- **Cross-platform**: Works on both iOS and Android devices
- **Lightweight Model**: Uses MobileNetV2 + SSD for efficient performance

## 🎯 Use Cases

- **Security & Surveillance**: Monitor and detect objects in real-time
- **Inventory Management**: Quick scanning and counting of items
- **Accessibility**: Help visually impaired users identify objects
- **Education**: Learn about object detection and machine learning
- **Smart Home**: Integration with home automation systems

## 🛠️ Technical Stack

- **Flutter**: UI framework for cross-platform development
- **TensorFlow Lite**: Lightweight ML framework for mobile devices
- **MobileNetV2 + SSD**: Efficient object detection model
- **Firebase**: Backend services for data storage
- **Camera Plugin**: Native camera integration
- **Image Picker**: Gallery access and image selection

## 📋 Prerequisites

- Flutter SDK (>=3.0.0)
- Xcode (for iOS development)
- Android Studio (for Android development)
- Firebase account
- Physical device for testing (recommended)

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/flutter_ai_app.git
   cd flutter_ai_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Create a new Firebase project
   - Add iOS and Android apps to your project
   - Download and add configuration files:
     - `GoogleService-Info.plist` for iOS
     - `google-services.json` for Android
   - Update Firebase configuration in `lib/firebase_options.dart`

4. Run the app:
   ```bash
   flutter run
   ```

## 📱 Usage

### Real-time Detection
1. Launch the app
2. Grant camera permissions
3. Point the camera at objects
4. View real-time detection results

### Gallery Analysis
1. Tap the gallery icon
2. Select an image
3. View detection results

## 🏗️ Project Structure

```
lib/
  ├── main.dart                 # Application entry point
  ├── firebase_options.dart     # Firebase configuration
  ├── screens/
  │   └── object_detection_screen.dart  # Main detection screen
  └── services/
      └── detection_service.dart        # Detection and storage logic
```

## 🤖 Model Information

The application uses MobileNetV2 + SSD (Single Shot Detector), which offers:
- Fast inference time
- Good accuracy
- Small model size
- Support for 90+ object classes

## 🔧 Configuration

### iOS Setup
Add the following to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app uses the camera for real-time object detection</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app accesses your photo library to analyze images</string>
```

### Android Setup
Add the following to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## 📈 Performance

- Average inference time: <100ms
- Model size: ~4MB
- Memory usage: ~50MB
- Supported devices: iOS 12.0+, Android 5.0+

## 🔮 Future Enhancements

- [ ] Add support for custom models
- [ ] Implement object tracking
- [ ] Add multi-object detection
- [ ] Support for video analysis
- [ ] Integration with AR features
- [ ] Offline mode support

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- TensorFlow team for the amazing ML framework
- Flutter team for the cross-platform framework
- Firebase team for the backend services
- The open-source community for various tools and libraries

## 📧 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter) - email@example.com

Project Link: [https://github.com/yourusername/flutter_ai_app](https://github.com/yourusername/flutter_ai_app) 