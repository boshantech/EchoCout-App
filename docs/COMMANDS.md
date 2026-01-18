# 💻 EXACT COMMANDS TO RUN THE APP

## TL;DR - 30 Seconds to App

```bash
cd d:\EchoCout\echo_app\EchoCout-App
flutter pub get
flutter run
```

Then:
- **Login**: Any phone number → OTP `1234` → ✅ App
- **Explore**: 5 tabs with all features ready

---

## STEP-BY-STEP

### Prerequisites Check
```bash
# Verify Flutter is installed
flutter --version

# Verify Dart is installed  
dart --version

# Verify device/emulator running
flutter devices
```

Expected output:
```
Flutter 3.x.x • channel stable
Dart 3.x.x
Found X device(s)
```

---

### Step 1: Navigate to Project
```bash
cd d:\EchoCout\echo_app\EchoCout-App
```

Expected:
```
D:\EchoCout\echo_app\EchoCout-App>
```

### Step 2: Get Dependencies
```bash
flutter pub get
```

Expected (first time):
```
Running "flutter pub get" in EchoCout-App...
Running "flutter pub get" in EchoCout-App...
Resolving dependencies...
Downloading shared_preferences 2.0.x...
Downloading image_picker 0.8.x...
[... more packages ...]
Building Flutter application: EchoCout-App
Running "flutter pub get" in EchoCout-App... 18.2s
```

### Step 3: Clean Build
```bash
flutter clean
flutter pub get
```

Expected:
```
Deleting build...
Deleting .dart_tool...
Running "flutter pub get" in EchoCout-App... 10.5s
```

### Step 4: Run the App
```bash
flutter run
```

Expected (first build):
```
Building flutter app for debug...
Compiling lib\main.dart...
Built build\app\outputs\flutter-apk\app-debug.apk (X MB)
Installing and launching...
I/flutter: Application started
D/flutter: The Dart VM service is listening on http://127.0.0.1:XXXXX/
```

---

## 🎮 AFTER APP STARTS

### Welcome Screen
- **Splash Page** (2 sec)
- Auto-navigates to Onboarding

### Onboarding
- Tap "Get Started" button

### Phone Input
```
Enter phone: +91 98765 43210
Tap: "Send OTP"
```

### OTP Entry
```
Enter code: 1234
Tap: "Verify"
```

### Main App!
You're now in the home screen with **5 bottom navigation tabs**

---

## 🚀 TERMINAL SHORTCUTS (After App Running)

### Hot Reload (Keep State)
```bash
Press: r
```
Effect: Code changes instantly applied, app state preserved

### Hot Restart (Clear State)
```bash
Press: R
```
Effect: Full rebuild, app state reset

### Show Widget Tree
```bash
Press: w
```
Effect: Shows widget hierarchy for debugging

### Exit App
```bash
Press: q
```
Effect: App stops, ready for changes

### Device Selection
```bash
Press: d
```
Effect: Opens device selection menu

---

## ⚠️ COMMON ISSUES & FIXES

### Issue: "dart: command not found"
```bash
# Fix: Add Dart to PATH
flutter doctor
# Follow suggestions
```

### Issue: "No devices found"
```bash
# Fix: Start emulator/connect device
flutter devices
# Then: flutter run
```

### Issue: "Android SDK not found"
```bash
# Fix: Run doctor
flutter doctor --android-licenses
# Accept all licenses
```

### Issue: App crashes on start
```bash
# Fix: Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Issue: Hot reload not working
```bash
# Fix: Use hot restart instead
# Press R (capital) in terminal
```

### Issue: OTP screen stuck
```bash
# Fix: Make sure OTP is exactly "1234"
# (no spaces, just the 4 numbers)
```

### Issue: Image picker not opening
```bash
# Fix: Try on real device (emulator can be limited)
# Or grant permissions manually in settings
```

---

## 📊 WHAT TO EXPECT

### Build Time
- **First build**: 3-5 minutes
- **Subsequent builds**: 30-60 seconds
- **Hot reload**: 1-2 seconds

### App Size
- **APK**: ~50-80 MB
- **Memory**: ~100 MB at runtime
- **Performance**: Smooth 60 FPS

### Load Times
- **Splash**: 2 seconds
- **Onboarding**: < 1 second
- **Login**: 2 seconds
- **Home**: < 800ms
- **Tab switches**: < 200ms
- **Image pick**: 1-3 seconds

---

## ✅ VERIFICATION CHECKLIST

After app launches, verify:

```
☐ Splash screen shows (2 sec)
☐ Onboarding screen appears
☐ Phone input screen works
☐ Phone accepts input
☐ OTP screen appears after sending
☐ OTP "1234" accepted
☐ Home screen loads
☐ Bottom navigation visible (5 tabs)
☐ All tabs clickable
☐ Tab icons show correctly
☐ Content switches when tapping tabs
☐ Images load properly
☐ Text is readable
☐ Colors match design
☐ Buttons respond to taps
☐ Animations are smooth
```

---

## 🎯 FEATURE TESTING

### Home Tab
```
1. Tap category chips
2. Items filter correctly
3. Tap "Select" on item
4. Modal popup appears
5. Close modal
6. Scroll list smoothly
```

### Echo Tab
```
1. Three cards visible (Sold, Earnings, Pending)
2. Pickup list below
3. Pull down to refresh
4. Snackbar shows "Refreshing..."
5. New data appears
```

### Scanner Tab
```
1. Two buttons visible (Camera, Gallery)
2. Tap "Choose from Gallery"
3. Image picker opens
4. Select any image
5. App shows detection result
6. Price displays
7. Tap "Upload" button
8. Snackbar confirms upload
```

### Rank Tab
```
1. Leaderboard list visible
2. 10 users showing
3. Your name highlighted (Rank 4)
4. Medal icons for top 3
5. Points sorted descending
```

### Profile Tab
```
1. Profile photo shows
2. Name: "Raj Kumar"
3. Phone: "+91 98765 43210"
4. Stats visible
5. Logout button works
6. After logout: returns to phone input
```

---

## 📱 TESTING ON DEVICE

### Android
```bash
# Connect Android device
adb devices

# Run on specific device
flutter run -d <device_id>
```

### iOS
```bash
# Connect iPhone
open -a Simulator

# Run on iOS
flutter run -d ios
```

### Web (Bonus!)
```bash
# Run on Chrome
flutter run -d chrome

# Run on Safari
flutter run -d safari
```

---

## 🔄 DEVELOPMENT WORKFLOW

### Make Code Change
1. Edit file (e.g., `main_page_mock.dart`)
2. Save file
3. Press `r` in terminal
4. See change instantly

### Keep Testing, Don't Restart
- Use `r` for quick changes
- Use `R` only when state breaks
- Use `q` to stop app

### When Stuck
```bash
# Kill app
Press: q

# Clean everything
flutter clean

# Start fresh
flutter pub get
flutter run
```

---

## 📚 DOCUMENTATION REFERENCE

Open these for reference while testing:

1. **RUN_NOW.md** - This file (quick reference)
2. **MOCK_MODE_GUIDE.md** - Detailed testing guide  
3. **MOCK_IMPLEMENTATION_SUMMARY.md** - Architecture overview
4. **FILE_STRUCTURE.md** - Code organization

---

## 🎉 YOU'RE READY!

### Final Command:
```bash
cd d:\EchoCout\echo_app\EchoCout-App && flutter run
```

### Expected Flow:
```
✅ Build starts
   ↓
✅ Dependencies resolve
   ↓  
✅ App compiles
   ↓
✅ APK installs
   ↓
✅ App launches
   ↓
✅ Splash screen (2s)
   ↓
✅ Onboarding screen
   ↓
✅ Phone input screen
   ↓
✅ OTP screen (enter: 1234)
   ↓
✅ 🎉 HOME SCREEN WITH 5 TABS
```

---

## 🆘 NEED HELP?

### Check Terminal for Errors
```
Look for "E/" or "error" in output
Most Flutter errors are self-explanatory
```

### Run Doctor
```bash
flutter doctor -v
```
Shows system setup issues

### Check Pub Cache
```bash
flutter pub cache repair
flutter pub get
```

### Nuclear Option (Last Resort)
```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
flutter run
```

---

**Total Time**: ⏱️ 5-10 minutes from start to running app  
**Difficulty**: ⭐ (Very Easy - Just 3 commands!)  
**Status**: ✅ Ready to Go!

---

# Let's Go! 🚀

```bash
flutter run
```
