# 🥗 Nutrition Planning Mobile Application 

A Flutter-based mobile application designed to help users **plan, manage, and track their daily meals and nutrition**.  
The app allows users to create meal plans, add meals, view nutrition summaries, and manage their data securely using **Firebase Authentication** and **Cloud Firestore**.

This project was developed as part of a university course and follows the same architectural and technical guidelines used in the *Running Tracker* project.

---

## 📱 Features

### ✅ Authentication
- Sign up with email & password
- Sign in with existing account
- Secure user-based data access
- Sign out functionality

### ✅ Meal Planning (CRUD)
- Create a meal plan
- Add meals to a plan
- View meals and nutrition summary
- Edit meal details
- Delete meals
- Delete meal plans

### ✅ Nutrition Summary
- Overview of meals added
- Organized and user-friendly display

### ✅ UI / UX
- Clean and simple interface
- Light / Dark mode support
- Reusable UI components
- Responsive layouts

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Provider** (State Management)
- **Firebase Authentication**
- **Cloud Firestore**
- **Material Design 3**

---

## 📂 Project Structure (Overview)

```text
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── theme_provider.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── empty_state.dart
│       ├── section_title.dart
│       └── stat_card.dart
│
├── features/
│   ├── auth/
│   │   ├── provider/
│   │   │   └── auth_provider.dart
│   │   └── ui/
│   │       ├── auth_gate.dart
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   │
│   └── meals/
│       ├── models/
│       ├── provider/
│       └── ui/
│
└── main.dart

```

🔐 Firebase Configuration

The application uses Firebase for backend services:
Firebase Authentication for user login and registration
Cloud Firestore for storing meal plans and meals per user

🧪 Testing Checklist

 Sign up with a new account
 Sign in with existing account
 Create a meal plan
 Add meals to the plan
 View nutrition summary
 Edit a meal
 Delete a meal
 Delete a meal plan
 Sign out

🤖 AI Integration

AI tools (such as ChatGPT) were used as development assistants, not as a replacement for understanding or implementation.

Examples of AI Usage:

Generating data models and Provider structure

Helping design UI components

Debugging Firebase and Provider-related issues

All AI-generated code was:

Reviewed manually

Modified when needed

Fully understood by the developer

An AI Integration Log is included as part of the project documentation.

⚠️ **Challenges** & **Solutions**

**Challenges**

Firebase permission-denied errors
Provider scope issues
Authentication state handling
UI rebuild performance

**Solutions**

Proper Firestore security rules
Correct Provider placement in main.dart
Using AuthGate for auth state control
Optimizing widget rebuilds

**👨‍💻 Author **
Developed by: Hakeem
Course: Mobile Application Development
University Project – Educational Use
