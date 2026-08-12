# Asma-ul-Husna (99 Names of Allah)

A beautiful, spiritual, and high-performance Flutter application designed to help users explore, listen to, and learn the 99 Names of Allah. This project features a seamless UI with synchronized audio playback and background audio support.

**Note:** This repository was open-sourced following the overwhelming response to the demo video shared on social media. I've decided to share the code to help the developer community learn and build similar spiritual applications.

---

## 🌟 Features

- **99 Names of Allah:** Complete list with Arabic text and Urdu meanings.
- **Synchronized Audio:** High-quality audio playback that syncs with the displayed names.
- **Background Playback:** Audio continues to play even when the app is minimized, thanks to `just_audio_background`.
- **Interactive UI:** Tap the screen to skip to the next name or use the built-in media controls.
- **Staggered Animations:** A beautiful splash screen with custom entrance animations.
- **State Management:** Powered by `provider` for efficient and clean state handling.

---

## 🛠️ Tech Stack & Packages

This project leverages some of the best Flutter packages to ensure a smooth user experience:

- **[just_audio](https://pub.dev/packages/just_audio):** For high-level audio playback.
- **[just_audio_background](https://pub.dev/packages/just_audio_background):** For background audio and lock-screen controls.
- **[provider](https://pub.dev/packages/provider):** For efficient state management.
- **[google_fonts](https://pub.dev/packages/google_fonts):** For beautiful typography (Amiri, Poppins, Noto Nastaliq Urdu).

---

## 📂 Project Structure

The codebase follows a clean and modular structure:

- `lib/main.dart`: Entry point of the app, handles package initialization.
- `lib/ui/screens/`: Contains the UI for the Splash Screen and the main Asma-ul-Husna screen.
- `lib/provider/`: Contains `AudioProvider` which manages the playback logic.
- `lib/model/`: Contains the `AllahName` data model.
- `assets/json/`: Stores `asma-ul-husna.json`, the primary data source for the names and timings.
- `assets/audio/`: Contains the main audio file (`names.mp3`).

---

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/codexahmar/Asma-Ul-Husna
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📱 My Other Projects

If you find this project useful, you might also like my full-scale application **Islam Plus**. It's a comprehensive Islamic companion app available on Google Play.

[**Download Islam Plus on Google Play**](https://play.google.com/store/apps/details?id=com.codexahmar.islamplus)

---

## 🤝 Connect With Me

Let's connect and build something amazing together!

- **Instagram:** [@codexahmar](https://www.instagram.com/codexahmar/)
- **TikTok:** [@codexahmar](https://www.tiktok.com/@codexahmar)
- **LinkedIn:** [Ahmar Yar Khan](https://www.linkedin.com/in/ahmaryarkhan/)

---

## ⭐ Support the Project

If this code helps you or you like the project, please consider giving it a **Star** ⭐️ on GitHub and following my account for more open-source Flutter projects!

---

**License:** MIT
