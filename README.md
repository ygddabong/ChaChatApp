# Cha Chat

A WhatsApp-style iOS chat app built with Firebase — sign up, see your friends, and chat in real time.

Written in 2020 while learning iOS development; repo cleaned up in 2026.

<p>
  <img width="200" alt="Login" src="https://user-images.githubusercontent.com/39237004/78504028-6372d280-77a5-11ea-9fe1-b9bc0d24f13a.png">
  <img width="200" alt="Sign up" src="https://user-images.githubusercontent.com/39237004/78504053-856c5500-77a5-11ea-8cf1-16a6415f26db.png">
  <img width="200" alt="Friends" src="https://user-images.githubusercontent.com/39237004/78504057-89987280-77a5-11ea-9098-64f5b13f1378.jpeg">
  <img width="200" alt="Chat" src="https://user-images.githubusercontent.com/39237004/78504058-8d2bf980-77a5-11ea-8e54-eb966a5acb85.png">
</p>

## Features

- Email sign-up, login and password reset (Firebase Auth)
- Profile images stored in Firebase Storage and loaded with Kingfisher
- Friend list
- Real-time one-to-one chat (Firebase Realtime Database + MessageKit)

## Tech stack

- Swift 5, UIKit (Storyboard + SnapKit for code layout)
- Firebase Auth, Realtime Database, Storage, FirebaseUI
- MessageKit, Kingfisher, SnapKit (via CocoaPods)

## Running

1. Install [CocoaPods](https://cocoapods.org) and run:

   ```bash
   pod install
   ```

2. Create a Firebase project with Email/Password auth, Realtime Database and Storage enabled. Register an iOS app with bundle ID matching the Xcode project, download its **`GoogleService-Info.plist`**, and put it at `Cha Chat/GoogleService-Info.plist`. (The file is git-ignored — never commit it.)
3. Open **`Cha Chat.xcworkspace`** (not the `.xcodeproj`) in Xcode and run.

The pod versions are pinned in `Podfile.lock` to the 2020 releases the code was written against. Moving to current Firebase / MessageKit versions would need code changes.

## 2026 update

- Removed the committed `Pods/` directory (~6,000 files) — `pod install` recreates it from `Podfile.lock`
- Removed `GoogleService-Info.plist` from the repo and git-ignored it
- `Podfile`: set the iOS platform and added a `post_install` hook that raises old pods' deployment targets so recent Xcode versions can build them
- Removed per-user Xcode files; added `.gitignore`; rewrote README
