# ✈️ PlaneSpott - Airplane Spotting App

A Flutter mobile app for capturing, tagging, and managing airplane spotting photos with GPS coordinates.

## 📸 Features

✅ **Firebase Authentication** - Secure user signup/login  
✅ **Camera Integration** - Capture photos with flash and zoom controls  
✅ **GPS Tagging** - Automatic location capture with coordinates  
✅ **Base64 Image Storage** - Store photos directly in Firestore  
✅ **Photo Management** - Edit names, favorite, and delete photos  
✅ **Real-time Sync** - Live updates across devices  
✅ **Cloud Notifications** - Firebase Cloud Messaging ready  

---

## 🖼️ Image Storage Method: Base64 in Firestore

This app uses **Base64 encoding** to store images directly in Firestore documents.

### Why Base64?
- ✅ Simpler architecture (no Cloud Storage needed)
- ✅ All data in one place (Firestore documents)
- ✅ Atomic transactions (photo + metadata together)
- ✅ Perfect for small to medium apps

### Size Limits
- **Maximum image size:** ~700 KB (original)
- **After encoding:** ~930 KB (Base64 adds ~33%)
- **Firestore limit:** 1 MB per document
- **Safety margin:** 100 KB buffer for metadata

### Size Checks
Your app automatically:
1. ✅ Checks original file size (< 700 KB required)
2. ✅ Checks encoded size (< 900 KB required)
3. ✅ Shows user-friendly warnings/errors
4. ✅ Prevents saving oversized images

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.11+)
- Android device/emulator or iOS device/simulator
- Firebase project configured

### Installation

```bash
# 1. Clone or navigate to project
cd C:\crud_app\planespott

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Firebase Setup

1. **Create Firebase Project**
   - Visit: https://console.firebase.google.com
   - Create new project: "planespott"

2. **Enable Services**
   - Authentication (Email/Password)
   - Firestore Database
   - Cloud Messaging (for notifications)

3. **Download Credentials**
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → iOS (via Xcode)

4. **Configure Firestore Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth.uid == userId;
       }
       match /photos/{userId}/{photoId} {
         allow read, write: if request.auth.uid == userId;
         allow read: if request.auth != null;
       }
     }
   }
   ```

---

## 📱 App Screens

### 1. Login Screen
- Email/Password authentication
- Sign up link for new users

### 2. Signup Screen  
- Create new account
- Password confirmation
- Email validation

### 3. Home Screen
- **Two tabs:**
  - "All Photos" - All captured photos
  - "Favorites" - Starred photos only
- Floating + button to add photos
- Menu button for logout

### 4. Camera Screen
- Live camera preview
- Flash toggle (torch mode)
- Digital zoom (1x - 5x)
- GPS coordinates display
- Location accuracy indicator

### 5. Photo Details Screen
- Image preview
- GPS metadata (lat, long, altitude, accuracy)
- Photo name input
- Size warning if image too large
- Save to Firestore button

---

## 🎮 How to Use

### Taking a Photo

1. **Open Camera**
   - Tap the floating + button on home screen

2. **Prepare Shot**
   - Wait for GPS coordinates to appear (bottom left)
   - Adjust zoom slider if needed
   - Toggle flash if needed

3. **Capture**
   - Tap blue camera button
   - See photo preview

4. **Save Photo**
   - Enter a name for the photo
   - Review GPS coordinates shown
   - Check file size (warning if > 700 KB)
   - Tap "Save Photo"

### Managing Photos

**Edit Name**
- Tap the photo name in the list
- Edit in dialog box

**Star as Favorite**
- Tap the star icon
- Photo moves to "Favorites" tab

**Delete Photo**
- Tap trash icon
- Confirm deletion

**Switch Tabs**
- "All Photos" - See all photos
- "Favorites" - See only starred photos

---

## 🏗️ Architecture

### Project Structure
```
lib/
├── models/
│   ├── user_model.dart
│   └── photo_model.dart
├── services/
│   ├── auth/firebase_auth_service.dart
│   ├── camera/camera_service.dart
│   ├── location/location_service.dart
│   └── photo/photo_service.dart
├── providers/
│   ├── auth_provider.dart
│   └── photo_provider.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/home_screen.dart
│   ├── camera/camera_capture_screen.dart
│   └── photo/photo_details_screen.dart
├── config/
│   ├── firebase_config.dart
│   └── theme_config.dart
└── utils/
    ├── image_compression_utils.dart
    ├── date_time_utils.dart
    └── constants.dart
```

### State Management
- **Riverpod** for reactive state
- **StreamProvider** for real-time Firestore
- **FutureProvider** for async operations

### Database Schema
```
Firestore:
├── users/{userId}
│   ├── email
│   ├── displayName
│   ├── createdAt
│   └── updatedAt
└── photos/{userId}/{photoId}
    ├── name
    ├── imageBase64 ← Base64 encoded JPEG
    ├── latitude
    ├── longitude
    ├── dateTaken
    ├── isFavorite
    └── createdAt
```

---

## ⚙️ Configuration

### Image Size Limits

Edit `lib/utils/image_compression_utils.dart`:

```dart
// Line 58: Recommended max size (KB)
const maxRecommendedSizeKB = 700;

// Line 65: Absolute max size after encoding (KB)
if (base64SizeKB > 900) { // ← Change if needed
```

### Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`)
- `android.permission.CAMERA`
- `android.permission.ACCESS_FINE_LOCATION`
- `android.permission.ACCESS_COARSE_LOCATION`
- `android.permission.POST_NOTIFICATIONS`

**iOS** (`ios/Runner/Info.plist`)
- `NSCameraUsageDescription`
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`

---

## 🧪 Testing

### Test Checklist

- [x] Sign up with email/password
- [x] Login with credentials  
- [x] Home screen shows empty photo list
- [x] Open camera and see GPS coordinates
- [x] Take a photo
- [x] Photo saves successfully
- [x] Photo appears in "All Photos"
- [x] Edit photo name
- [x] Star photo as favorite
- [x] Photo appears in "Favorites"
- [x] Delete photo
- [x] Logout and login again

### Known Behaviors

⚠️ **GPS takes 5-10 seconds** to acquire initial lock  
⚠️ **First app launch might be slow** (Firebase initialization)  
⚠️ **Large photos (> 700 KB) will be rejected** (intentional)  
⚠️ **Photos reload on app restart** (Firestore sync)  

---

## 🐛 Troubleshooting

### "Image too large (XXX KB)"
- **Cause:** Original image > 700 KB
- **Solution:** Take another photo or crop current one

### "Encoded image too large"
- **Cause:** Base64 encoded size > 900 KB
- **Solution:** Use smaller/lower resolution image

### GPS shows "Not available"
- **Cause:** Location permission denied or GPS disabled
- **Solution:** 
  - Enable location permission in app settings
  - Enable device GPS globally
  - Wait 10 seconds for GPS lock

### Camera won't open
- **Cause:** Camera permission denied
- **Solution:** Enable camera permission in app settings

### Photos not appearing
- **Cause:** Firestore sync delay
- **Solution:** Pull to refresh or restart app

---

## 📊 Storage Usage

### Example: 100 Photos
| Metric | Value |
|--------|-------|
| Avg photo size | 600 KB |
| After Base64 | 798 KB |
| Total stored | 79.8 MB |
| Firestore cost | ~$0.15/month |

---

## 🔒 Security

### Firestore Rules
- Users can only read/write their own photos
- Other users can read (view) but not modify
- All access requires authentication

### Best Practices
- Never expose user IDs in client code ✅
- Use Firestore rules for access control ✅
- Validate image sizes before upload ✅
- Use HTTPS for all communication ✅

---

## 🚀 Future Enhancements

Possible additions:
- Airplane type classification (ML)
- Sharing photos to social media
- Map view of sighting locations
- Statistics dashboard
- Cloud backup of photos
- Dark theme support
- Offline mode with sync
- Comments/ratings system

---

## 📄 License

This project is for educational purposes.

---

## 📞 Support

For issues or questions:
1. Check Flutter/Firebase documentation
2. Review error messages in console
3. Check Firebase Console for data
4. Ensure permissions are granted
5. Try restarting the app

---

## 🎓 Learning Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod State Management](https://riverpod.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Firestore Best Practices](https://cloud.google.com/firestore/docs/best-practices)

---

**Happy spotting!** ✈️✈️✈️

Built with ❤️ using Flutter & Firebase

