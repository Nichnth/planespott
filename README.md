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