# Wedding Invitation Website

A beautiful, interactive wedding invitation website built with [Jaspr](https://github.com/schultek/jaspr) - a modern Dart web framework. Features elegant animations, real-time blessing messages, and a responsive mobile-first design.

## Features

### Core Features
- **Elegant Scroll Animations** - Smooth reveal animations as content enters the viewport
- **Auto-playing Background Music** - Creates an immersive atmosphere with music controls
- **Real-time Blessing Messages** - Guests can leave blessings that appear in real-time
- **Interactive Calendar** - Beautiful calendar view highlighting the wedding date
- **Gift Information** - QR codes for digital gift transfers
- **Mobile-First Design** - Optimized for mobile devices with responsive desktop view
- **Floating Blessing Messages** - Auto-scrolling blessing messages with smooth animations

### Wedding Sections
1. **Header** - Hero section with couple names and wedding date
2. **Story Introduction** - Brief introduction to the couple's love story
3. **Love Story Timeline** - Photo gallery with meaningful moments
4. **Calendar** - Interactive calendar showing the wedding date
5. **Address & Venue** - Location details with map integration
6. **Closing** - Thank you message to guests

## Tech Stack

- **Framework**: [Jaspr](https://jaspr.dev) ^0.21.6 - Modern Dart web framework
- **Backend**: Firebase Cloud Firestore - Real-time database for blessings
- **Authentication**: Firebase Core ^3.10.0
- **Language**: Dart ^3.8.0
- **Styling**: CSS3 with custom animations + Inline Jaspr Styles
- **Build Tool**: jaspr_web_compilers ^4.2.3

## Project Structure

```
wedding/
├── lib/
│   ├── app.dart                      # Main app configuration
│   ├── pages/
│   │   └── wedding_page.dart         # Main wedding page
│   ├── components/
│   │   ├── wedding_sections/         # Section components
│   │   │   ├── header_section.dart
│   │   │   ├── story_intro_section.dart
│   │   │   ├── love_story_section.dart
│   │   │   ├── calendar_section.dart
│   │   │   ├── address_section.dart
│   │   │   └── closing_section.dart
│   │   ├── flex/                     # Flexible layout components
│   │   │   ├── flex_section.dart
│   │   │   ├── flex_text.dart
│   │   │   ├── flex_photo.dart
│   │   │   ├── flex_box.dart
│   │   │   └── flex_date_header.dart
│   │   ├── audio_control.dart        # Background music player
│   │   ├── scroll_animated.dart      # Scroll reveal animations
│   │   ├── blessing_list.dart        # Floating blessings display
│   │   ├── blessing_popup_container.dart  # Blessing form popup
│   │   ├── gift_popup_container.dart      # Gift info popup
│   │   ├── toolbar.dart              # Bottom toolbar
│   │   ├── toolbar_toggle_button.dart
│   │   ├── base_popup.dart           # Reusable popup component
│   │   └── mobile_frame.dart         # Mobile device frame
│   ├── models/
│   │   └── blessing.dart             # Blessing data model
│   ├── services/
│   │   └── blessing_service.dart     # Firestore service
│   ├── helper/
│   │   └── calendar_helper.dart      # Calendar utilities
│   ├── consts/
│   │   └── enums.dart                # Enums & constants
│   └── firebase_options.dart         # Firebase configuration
├── web/
│   ├── css/
│   │   ├── styles.css                # Global styles & animations
│   │   └── fonts.css                 # Custom font definitions
│   ├── js/
│   │   ├── scroll_observer.js        # Intersection Observer for animations
│   │   └── wedding_audio.js          # Audio player logic
│   ├── images/                       # Image assets
│   └── main.dart                     # Web entry point
└── pubspec.yaml                      # Dependencies
```

## Getting Started

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) (>=3.8.0 <4.0.0)
- [Jaspr CLI](https://jaspr.dev/docs/getting-started)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd iwedding
```

2. Install dependencies:
```bash
dart pub get
```

3. Configure Firebase:
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Cloud Firestore
   - Update `lib/firebase_options.dart` with your Firebase configuration
   - Create a `blessings` collection in Firestore

### Development

Run the development server:
```bash
jaspr serve
```

The site will be available at `http://localhost:8080`

### Building for Production

Build the optimized production bundle:
```bash
jaspr build
```

The output will be in `build/jaspr/` directory. Deploy this folder to your hosting service.

## Configuration

### Customizing Content

Edit the section files in `lib/components/wedding_sections/` to customize:
- Couple names
- Wedding date and time
- Venue address
- Love story photos and quotes
- Background music

### Styling

- **Global CSS**: Edit `web/css/styles.css`
- **Component Styles**: Most components use inline Jaspr `Styles()` for better encapsulation
- **Animations**: Scroll animations defined in `styles.css` (`.scroll-animated`)

### Firebase Setup

#### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" and follow the setup wizard
3. Enable Cloud Firestore in "Firestore Database"
4. Choose "Start in production mode"

#### Step 2: Configure Firebase in Your App

1. In Firebase Console, click the Web icon (</>) to add a web app
2. Register your app and copy the Firebase configuration
3. Update `lib/firebase_options.dart` with your credentials:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  authDomain: 'YOUR_PROJECT.firebaseapp.com',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT.appspot.com',
  messagingSenderId: 'YOUR_SENDER_ID',
  appId: 'YOUR_APP_ID',
);
```

#### Step 3: Deploy Firestore Rules and Indexes

1. Install Firebase CLI if you haven't:
```bash
npm install -g firebase-tools
```

2. Login to Firebase:
```bash
firebase login
```

3. Initialize Firebase in your project (if not already done):
```bash
firebase init firestore
```

4. Deploy Firestore rules and indexes using the provided script:
```bash
chmod +x deploy_firestore.sh
./deploy_firestore.sh
```

Or manually deploy:
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

#### Firestore Structure

**Collection**: `blessings`

**Document Fields**:
```json
{
  "name": "Guest Name",        // string, 3-25 characters
  "message": "Blessing text",  // string, 1-500 characters
  "timestamp": "2025-01-01..."  // timestamp, auto-set on create
}
```

**Security Rules** (see `firestore.rules`):
- ✅ Anyone can read blessings
- ✅ Anyone can create blessings (with validation)
- ❌ Only admins can update/delete (currently disabled)
- Validates name length (3-25 chars) and message length (1-500 chars)

**Query Optimization**:
The app queries blessings ordered by timestamp. No special indexes required for basic functionality, but you can add them in `firestore.indexes.json` if needed.

## Key Components

### Scroll Animations
Components wrapped with `ScrollAnimated` widget will fade in and slide when they enter the viewport. Supports 4 directions: `up`, `down`, `left`, `right`.

```dart
ScrollAnimated(
  direction: AnimationDirection.up,
  delay: 0,
  child: YourWidget(),
)
```

### Audio Control
Auto-playing background music with toggle control. Positioned at top-right corner with rotation animation when playing.

### Blessing System
- **Real-time streaming** from Firestore
- **Auto-scrolling animation** with infinite loop effect
- **Popup form** for guests to submit blessings

## Performance Optimizations

- Lazy-loaded images with background-image approach
- CSS animations using `transform` and `opacity` for GPU acceleration
- Efficient Firestore queries with `orderBy` and `limit`
- Inline styles for component encapsulation
- Removed ~28% unused CSS rules for faster load times

## Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Responsive Design

- **Mobile**: Full viewport, optimized for 320px-648px screens
- **Desktop**: Centered mobile frame (385px-500px width) on gray background

## License

MIT License - Feel free to use this for your own wedding!

## Credits

Built with love using [Jaspr](https://jaspr.dev) - A modern web framework for Dart.

---

Made with ❤️ for a special day
