# Scanner Feature - User Flow Diagram

## Visual Flow

```
┌─────────────────────────────────────────────────────────────┐
│                   TAP SCANNER TAB                           │
│              (MainPageMock._currentIndex = 2)               │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│          STEP 1: PHOTO CAPTURE (ScannerScreenMock)          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📸 Capture Waste Photo                                     │
│  Take a clear photo of the waste you want to sell          │
│                                                             │
│  [📷 Open Camera]  [📷 Choose from Gallery]                │
│                                                             │
│  If image selected:                                        │
│  ┌─────────────────────────────────┐                       │
│  │      [Photo Preview Image]       │                       │
│  │                                 │                       │
│  │ Does this photo look good?      │                       │
│  │                                 │                       │
│  │ [✓ Yes, Use This Photo]         │                       │
│  │ [↻ Take Another Photo]          │                       │
│  └─────────────────────────────────┘                       │
│                                                             │
└────────────────┬──────────────────────────────────────────┘
                 │ (Confirmed)
                 ▼
┌─────────────────────────────────────────────────────────────┐
│   STEP 2: CATEGORY SELECTION (WasteCategorySelectionScreen) │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  What type of waste are you selling?                       │
│                                                             │
│  ┌────────────────────────────┐                            │
│  │ 🛍️  Plastic                │ ✅ Selected              │
│  │ Select to continue...      │                            │
│  └────────────────────────────┘                            │
│  ┌────────────────────────────┐                            │
│  │ 📰 Paper                   │                            │
│  │ Select to continue...      │                            │
│  └────────────────────────────┘                            │
│  ┌────────────────────────────┐                            │
│  │ 🔧 Metal                   │                            │
│  │ Select to continue...      │                            │
│  └────────────────────────────┘                            │
│  ┌────────────────────────────┐                            │
│  │ 🍷 Glass                   │                            │
│  │ Select to continue...      │                            │
│  └────────────────────────────┘                            │
│  ┌────────────────────────────┐                            │
│  │ 💻 E-Waste                │                            │
│  │ Select to continue...      │                            │
│  └────────────────────────────┘                            │
│                                                             │
│              [CONTINUE] (enabled)                           │
│                                                             │
└────────────────┬──────────────────────────────────────────┘
                 │ (Category: "Plastic" selected)
                 ▼
┌─────────────────────────────────────────────────────────────┐
│     STEP 3: TYPE SELECTION (WasteTypeSelectionScreen)       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  What type of plastic are you selling?                     │
│                                                             │
│  ┌────────────────────────────┐                            │
│  │ PET Bottles      ✅         │                            │
│  │ ₹2.50 per unit             │                            │
│  └────────────────────────────┘                            │
│  ┌────────────────────────────┐                            │
│  │ Hard Plastic               │                            │
│  │ ₹2.00 per unit             │                            │
│  └────────────────────────────┘                            │
│  ┌────────────────────────────┐                            │
│  │ Plastic Bags               │                            │
│  │ ₹1.00 per unit             │                            │
│  └────────────────────────────┘                            │
│                                                             │
│              [CONTINUE] (enabled)                           │
│                                                             │
└────────────────┬──────────────────────────────────────────┘
                 │ (Type: "PET Bottles", Price: ₹2.50)
                 ▼
┌─────────────────────────────────────────────────────────────┐
│      STEP 4: ESTIMATED INVOICE (EstimatedInvoiceScreen)     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│          [Photo Preview Image]                             │
│                                                             │
│  ┌─────────────────────────────┐                           │
│  │ Category      │  Plastic    │                           │
│  │────────────────────────────│                            │
│  │ Type          │  PET Bottles│                           │
│  │────────────────────────────│                            │
│  │                            │                            │
│  │ ℹ️  Estimated Price         │                            │
│  │                            │                            │
│  │ Estimated Total │ ₹2.50    │                            │
│  │                            │                            │
│  │ Final price may vary after │                            │
│  │ pickup                     │                            │
│  └─────────────────────────────┘                           │
│                                                             │
│           [SELL WASTE]                                      │
│           [CANCEL]                                          │
│                                                             │
└────────────────┬──────────────────────────────────────────┘
                 │ (Sell clicked)
                 ▼
┌─────────────────────────────────────────────────────────────┐
│    STEP 5: SUCCESS POPUP (WasteSubmissionSuccessDialog)     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                    ✅                                       │
│                                                             │
│  Waste Submitted                                           │
│  Successfully!                                             │
│                                                             │
│  Pickup will be scheduled soon                             │
│                                                             │
│  ⏱️  Status: Pending Pickup                                │
│                                                             │
│           [CONTINUE]                                        │
│                                                             │
└────────────────┬──────────────────────────────────────────┘
                 │ (Continue clicked)
                 ▼
        ┌────────────────┐
        │   HOME TAB     │
        │ (Navigator.pop │
        │  to first)     │
        └────────────────┘
```

## Data Flow

### Photo Capture Phase
```
ImageSource.camera ─┐
                    ├─► ImagePicker.pickImage()
ImageSource.gallery┘          ↓
                         Check null
                              ↓
                         Update UI
                         (show preview)
```

### Category Selection Phase
```
Static Category List
     │
     ├─► Plastic (teal #6EC6C2)
     ├─► Paper (mint #7CBF9E)
     ├─► Metal (blue #5B9AA0)
     ├─► Glass (navy #4A90A4)
     └─► E-Waste (dark blue #3D7CA3)
             │
             └─► Single Selection
                      ↓
                   Navigate
```

### Type Selection Phase
```
Static Type-Price Mapping
{
  'Plastic': [
    ('PET Bottles', 2.50),
    ('Hard Plastic', 2.00),
    ('Plastic Bags', 1.00),
  ],
  'Paper': [
    ('Newspaper', 0.50),
    ('Cardboard', 1.20),
    ('Mixed Paper', 0.75),
  ],
  'Metal': [
    ('Aluminum Cans', 5.00),
    ('Scrap Iron', 3.50),
    ('Copper Wire', 15.00),
  ],
  'Glass': [
    ('Glass Bottles', 5.00),
    ('Jars', 4.50),
    ('Broken Glass', 3.00),
  ],
  'E-Waste': [
    ('Mobile Phones', 50.00),
    ('Copper Wire', 15.00),
    ('Circuit Boards', 25.00),
  ],
}
      │
      ├─► Filter by Category
      │
      └─► Single Selection
           ↓
       Get Price from Map
           ↓
       Navigate with Data
```

### Invoice Phase
```
Invoice Data:
┌─────────────────────────────┐
│ Photo: imagePath            │
│ Category: "Plastic"         │
│ Type: "PET Bottles"         │
│ Estimated Price: ₹2.50      │
│ Status: Draft               │
└─────────────────────────────┘
           │
           ├─► Display all fields
           │
           ├─► Show "Final price may vary" warning
           │
           └─► Enable "Sell Waste" button
                   ↓
               Show Success Dialog
```

### Success Phase
```
Dialog State:
┌─────────────────────────────┐
│ Animation: ScaleTransition  │
│ Curve: elasticOut           │
│ Duration: 600ms             │
│ Scale: 0.0 → 1.0            │
│                             │
│ Message: Success            │
│ Status: Pending Pickup      │
│ Action: Continue → Home     │
└─────────────────────────────┘
```

## State Management Pattern

### ScannerScreenMock (Step 1)
```dart
State Variables:
- _selectedImage: XFile?

Transitions:
- null → image (after pickImage)
- image → null (reset button)
- image → WasteCategorySelectionScreen (confirm button)
```

### WasteCategorySelectionScreen (Step 2)
```dart
State Variables:
- _selectedCategory: String?

Transitions:
- null → category (on tap)
- category → category (change selection)
- category → WasteTypeSelectionScreen (continue)
```

### WasteTypeSelectionScreen (Step 3)
```dart
State Variables:
- _selectedType: String?

Transitions:
- null → type (on tap)
- type → type (change selection)
- type → EstimatedInvoiceScreen (continue with data)
```

### EstimatedInvoiceScreen (Step 4)
```dart
State Variables: NONE (StatelessWidget)
- Receives all data via constructor
- Immutable display

Transitions:
- Sell → WasteSubmissionSuccessDialog
- Cancel → Pop to previous
```

### WasteSubmissionSuccessDialog (Step 5)
```dart
State Variables:
- _animationController (for scale animation)

Transitions:
- Continue → Navigator.pop until first (Home Tab)
```

## Error Handling

```
Photo Selection:
├─ Try-Catch wrapper
├─ Show SnackBar on error
└─ Silent ignore on cancel

Image Loading:
├─ Platform-aware (kIsWeb)
├─ File validation
└─ No throw errors

Navigation:
├─ All pushes use Navigator.push
├─ Pop uses Navigator.pop/popUntil
└─ Home return: popUntil(route.isFirst)
```

## Color Palette

### Categories
- Plastic: Teal #6EC6C2 (primary)
- Paper: Mint #7CBF9E
- Metal: Blue #5B9AA0
- Glass: Navy #4A90A4
- E-Waste: Dark Blue #3D7CA3

### UI Elements
- Primary: #6EC6C2 (teal)
- Background: #FFFFFF (white)
- Text Primary: #1F2D2B
- Text Secondary: #999999
- Success: Green (colors.green[600])
- Warning: Amber
- Info: Blue

## Performance Notes

✅ No rebuilds on navigation (proper widget hierarchy)
✅ Image quality optimized (85%, max 1024x1024)
✅ No excessive state updates
✅ Animation runs on GPU (scaleTransition)
✅ List building uses indexed builders (efficient)
✅ Lazy evaluation of conditional widgets

## Responsive Design

- ✅ Works on mobile (portrait/landscape)
- ✅ Works on tablet
- ✅ Works on web (via kIsWeb checks)
- ✅ Proper spacing and padding
- ✅ Text scales appropriately
- ✅ Buttons have minimum hit targets

---

**Navigation Method**: Navigator.push (not named routes)  
**Data Passing**: Constructor parameters  
**State Sharing**: None (each screen independent)  
**Pop Behavior**: PopUntil(route.isFirst) for final step
