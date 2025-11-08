# 🚖 TaxiCalc — Real-Time Trip Calculator with Interactive Map

![Flutter](https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)

**TaxiCalc** is a Flutter-based mobile application that calculates the real-time cost of a taxi trip using your device's location.  
It integrates **OpenStreetMap**, orientation controls, dynamic distance/time tracking, and configurable pricing per kilometer and per hour.

---

## ✨ Features

- 🗺️ **Interactive Map (OpenStreetMap)**  
  View your real-time location and add custom markers with a long press.

- 🧭 **Map Orientation Modes**  
  - **North Up** — keeps the map fixed to the north.  
  - **Follow Heading** — rotates according to device orientation.  
  - **Free Rotation** — allows manual map rotation.

- 🚗 **Real-Time Location Tracking**  
  The map follows the user’s movement and rotates dynamically with direction.

- ⏱️ **Automatic Fare Calculation**  
  - Calculates cost by **distance (km)**.  
  - Calculates cost by **time (waiting hours)**.

- ⚙️ **Custom Fare Configuration**  
  Save and reload your preferred fare rates using local preferences (`SharedPreferences`).

- 📍 **Manual Markers**  
  Add location markers by long-pressing on the map.

- 🌙 **Always-On Display**  
  Uses `WakelockPlus` to keep the screen awake during trips.

---

## 🚀 Getting Started
1️⃣ Clone the repository
git clone https://github.com/cardentey86/taxi_calc.git
  cd taxi_calc

2️⃣ Install dependencies
flutter pub get

3️⃣ Run the app
flutter run

---

## ⚙️ Configuration

The app uses SharedPreferences to store:

price_hora: price per hour

price_km: price per kilometer

You can adjust these values directly within the app’s configuration dialog.

---

## 🧮 Core Logic

Trip mode: Starts distance-based fare tracking.

Wait mode: Activates time-based fare calculation.

Follow mode: Centers the map on your position.

Orientation control: Adjusts map rotation behavior.

---

## 🧩 Project Structure

```plaintext
lib/
├── modules/
│   └── map/
│       ├── screens/
│       │   └── map_screen.dart        # Main map screen
│       └── widgets/
│           ├── calculate_control_widget.dart
│           ├── configuration_dialog_widget.dart
│           ├── info_widget.dart
│           ├── orientation_control_widget.dart
│           └── zoom_widget.dart

| Package                                                             | Description                                  |
| ------------------------------------------------------------------- | -------------------------------------------- |
| [`flutter_map`](https://pub.dev/packages/flutter_map)               | Displays maps using OpenStreetMap            |
| [`geolocator`](https://pub.dev/packages/geolocator)                 | Accesses device GPS and heading              |
| [`latlong2`](https://pub.dev/packages/latlong2)                     | Handles geographic distance and coordinates  |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Stores fare settings locally                 |
| [`url_launcher`](https://pub.dev/packages/url_launcher)             | Opens external URLs (e.g., map attributions) |
| [`wakelock_plus`](https://pub.dev/packages/wakelock_plus)           | Keeps the device screen on                   |
```
---

🧑‍💻 Author
Adrián Álvarez Cardentey
📧 https://github.com/cardentey86
📧 adrianalvarezcardentey@gmail.com


