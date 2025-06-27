# 🩸 LifeDrop - Blood Donor App (Flutter)

LifeDrop is a user-friendly Flutter application that bridges the gap between blood donors and those in urgent need. It offers a real-time, interactive, and location-based blood donation platform, ensuring that help reaches faster and smarter.

---

## 📱 App Features

### 🚀 Onboarding & Authentication
- **Onboarding Screen**: Introduces users to the app with a welcome message and brief overview.
- **Login/Register**: 
  - Users can log in with existing credentials.
  - New users can sign up by completing a multi-step registration form.

---

### 🏠 Home Page (Main Dashboard)
- **Personal Welcome Message**
- **Main Functional Buttons**:
  1. **Urgent Request** – View and respond to emergency blood requests.
  2. **Find Donor** – Search for donors by district and blood group.
     - 🔍 Floating button to switch between list view and map view.
  3. **Nearby Request** – Shows requests near the user's location.
     - Includes: *View My Request* (editable/deletable) and *Search Nearby*.
  4. **Organizations** – Showcases blood donation-related organizations.

- **Notification Icon**: Shows all urgent request alerts.
  - Users can **accept** a request and receive a thank-you dialogue box.
  - Floating button: **My Responses** – Shows list of all requests the user accepted.

- **Emergency Services Floating Button**:
  - Navigates to a dedicated page with:
    - **Hospitals**
    - **Blood Banks**
    - **Ambulances**
    - **Chatbot**
  - Each service shows nearest options on an interactive map.
  - Chatbot communicates with users via message-based interaction.

---

### 🧑‍🦱 Profile Page
- Displays all user information including:
  - Name
  - Blood Group
  - Contact Info
  - Last Donation Date
  - Location and other profile details

---

### 📝 Make Request Page
- A dynamic form for submitting blood requests.
- Includes **"Urgent" button**:
  - When activated, all app users receive a push notification.

---

## 🔔 Notifications
- Centralized notification screen for all urgent requests.
- Floating action button: **My Responses**
  - Tracks all responses the user has made to requests.

---

## 🗺️ Location-Based Features
- All maps are powered by **Google Maps**.
- Location permission prompts integrated using **Geolocator**.
- Users can:
  - Find donors on map
  - Locate nearby hospitals, blood banks, and ambulances

---

## 🤖 Chatbot
- Interactive chatbot interface for:
  - FAQs
  - Emergency guidance
  - User support

---

## 🛠️ Tech Stack

### ✨ Flutter Packages Used

| Package | Purpose |
|--------|---------|
| **flutter** | Cross-platform app development |
| **firebase_core** | Firebase integration |
| **firebase_auth** | User authentication |
| **cloud_firestore** | Real-time NoSQL database |
| **firebase_storage** | File/image storage |
| **firebase_messaging** | Push notifications |
| **flutter_local_notifications** | Local device notifications |
| **google_maps_flutter** | Interactive map features |
| **geolocator** | Device geolocation |
| **location** | GPS access |
| **permission_handler** | Runtime permission management |
| **flutter_login** | Custom login UI |
| **lottie** | Animated Lottie assets |
| **animate_do** | Smooth UI animations |
| **animated_text_kit** | Animated text widgets |
| **animated_splash_screen** | App splash screen animation |
| **another_flutter_splash_screen** | Alternate splash screen animations |
| **curved_navigation_bar** | Stylish bottom navigation |
| **smooth_page_indicator** | Onboarding dot indicator |
| **carousel_slider** | Carousel UI widgets |
| **awesome_dialog** | Beautiful dialog boxes |
| **awesome_snackbar_content** | Custom snackbar UI |
| **getwidget** | Prebuilt UI components |
| **google_fonts** | Stylish fonts from Google Fonts |
| **cupertino_icons** | iOS-style icons |
| **url_launcher** | Launch maps, calls, emails, URLs |
| **icons_flutter** | Extra icons support |
| **http** | Network requests |
| **googleapis_auth** | Google API authorization |
| **path** | Path utilities |
| **image_picker** | Pick image from camera/gallery |
| **share_plus** | Share app or content |
| **dropdown_search** | Searchable dropdown menus |
| **percent_indicator** | Circular/linear percentage indicators |
| **flutter_native_splash** | Native splash screen generator |
| **flutter_gemini** | Gemini AI chatbot integration |
| **dash_chat_2** | Chat UI interface |
| **device_preview** | Simulate different screen sizes during dev |
| **flutter_rating** | Star rating widget |
| **intl** | Date and number formatting |

---



## 📦 Installation Guide

```bash
git clone https://github.com/shawonkst21/andriod_250_lifedrop.git
cd lifedrop
flutter pub get
flutter run
```
## 👨‍💻 Developer

**👤 MD. SHAWON HOSSAN**  
🎓 *BSc in Software Engineering, Shahjalal University of Science and Technology (SUST)*  
🆔 *Registration No: 2021831007*  
💻 *Building digital tools to save lives.*  
📫 *Feel free to connect for feedback, collaboration, or suggestions.*
