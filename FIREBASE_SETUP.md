# Firebase Configuration Guide

## Quick Setup Steps

### 1. Download Firebase Configuration Files

Visit your Firebase Console: https://console.firebase.google.com/project/nutrition-planner-ec06c/settings/general

#### For Android:
1. Scroll to "Your apps" section
2. Click on the Android app (or add one if not exists)
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

#### For iOS:
1. Scroll to "Your apps" section
2. Click on the iOS app (or add one if not exists)
3. Download `GoogleService-Info.plist`
4. Place it at: `ios/Runner/GoogleService-Info.plist`

### 2. Enable Firebase Services

#### Enable Authentication:
1. Go to: https://console.firebase.google.com/project/nutrition-planner-ec06c/authentication
2. Click "Get Started" (if not already enabled)
3. Go to "Sign-in method" tab
4. Enable "Email/Password"
5. Click "Save"

#### Enable Cloud Firestore:
1. Go to: https://console.firebase.google.com/project/nutrition-planner-ec06c/firestore
2. Click "Create database"
3. Select "Start in test mode" (for development)
4. Choose a location (closest to you)
5. Click "Enable"

### 3. Set Up Firestore Security Rules

Go to Firestore → Rules tab and replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Meal plans collection - users can only access their own meal plans
    match /meal_plans/{planId} {
      allow read, write: if request.auth != null && 
                           resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
                      request.resource.data.userId == request.auth.uid;
    }
  }
}
```

Click "Publish" to save the rules.

### 4. Run the App

```bash
# Get dependencies (if not already done)
flutter pub get

# Run on your device/emulator
flutter run
```

## Troubleshooting

### Issue: "Firebase not initialized"
- Make sure you've placed the config files in the correct locations
- Restart your IDE/editor
- Run `flutter clean` then `flutter pub get`

### Issue: "Authentication failed"
- Verify Email/Password is enabled in Firebase Console
- Check that you're using a valid email format
- Password must be at least 6 characters

### Issue: "Firestore permission denied"
- Make sure you're signed in
- Verify security rules are published
- Check that the rules match the ones above

## Testing Checklist

- [ ] Sign up with a new account
- [ ] Sign in with existing account
- [ ] Create a meal plan
- [ ] Add meals to the plan
- [ ] View nutrition summary
- [ ] Edit a meal
- [ ] Delete a meal
- [ ] Delete a meal plan
- [ ] Sign out

## Production Deployment

Before deploying to production:

1. **Update Firestore Rules** to production mode:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /meal_plans/{planId} {
      allow read: if request.auth != null && 
                    resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
                      request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && 
                              resource.data.userId == request.auth.uid;
    }
  }
}
```

2. **Enable App Check** for additional security
3. **Set up proper error logging** (Firebase Crashlytics)
4. **Add analytics** (Firebase Analytics)
5. **Test thoroughly** on both platforms
