# 🎵 Real-Time Synchronized Music Streaming Web Application

Visit The Website: https://syncmusicstream.netlify.app/

How to use:
Step 1: Open the link: https://syncmusicstream.netlify.app/
        A new room created automatically. 
Step 2: Copy the link and share to the other users.
        Now all the users are in the same room ready to stream the YouTube Music synchronised in all the devices.
Step 3: Search a video in the searchbox and play it.
        The video starts playing in all the devices in sync.

A real-time collaborative music streaming web application built with **Flutter Web**, **Node.js**, **Express**, and **Socket.IO**. The application allows multiple users to join a shared room and watch or listen to the same YouTube video in perfect synchronization.

## ✨ Features

* 🎧 Create or join a room using a unique room code.
* ▶️ Real-time synchronized play and pause controls.
* ⏩ Synchronized seeking across all connected users.
* 🔍 Search YouTube videos directly from the application.
* 🌐 Cross-platform Flutter Web frontend.
* ⚡ Low-latency communication using Socket.IO.

## 🛠️ Tech Stack

### Frontend

* Flutter Web
* Dart
* youtube_player_iframe
* socket_io_client

### Backend

* Node.js
* Express.js
* Socket.IO

### Deployment

* Frontend: Netlify
* Backend: Render

---

## 📂 Project Structure

```text
Real-Time_SynchronizedMusicStreamingWebApplication/
│
├── sync_music_web/        # Flutter Web frontend
│   ├── lib/
│   ├── assets/
│   ├── web/
│   └── pubspec.yaml
│
├── sync_music_server/     # Node.js backend
│   ├── server.js
│   ├── package.json
│   └── ...
│
└── README.md
```

---

## 🚀 Getting Started

### Clone the Repository

```bash
git clone https://github.com/Einsteinium01/Real-Time_SynchronizedMusicStreamingWebApplication.git
cd Real-Time_SynchronizedMusicStreamingWebApplication
```

---

## Frontend Setup

Navigate to the Flutter project:

```bash
cd sync_music_web
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run -d chrome
```

Build for production:

```bash
flutter build web
```

---

## Backend Setup

Navigate to the backend folder:

```bash
cd sync_music_server
```

Install dependencies:

```bash
npm install
```

Start the server:

```bash
node server.js
```

---

## 🔄 How It Works

1. A user creates or joins a room.
2. The backend maintains the current room state, including:

   * Current YouTube Video ID
   * Playback timestamp
   * Play/Pause status
3. Whenever a user performs an action (play, pause, seek, or change video), the backend broadcasts the update to every participant in the room using Socket.IO.
4. Every connected client updates its player, ensuring all users stay synchronized.

---

## 📸 Screenshots

<img width="1918" height="872" alt="image" src="https://github.com/user-attachments/assets/06936dd4-5032-4b5f-bcea-4c0502e6fd8c" />

---

## 🔮 Future Improvements

* User authentication
* Playlist support
* Chat system
* Volume synchronization
* Admin controls
* Playback queue
* Recently played songs
* Room history
* Better synchronization algorithms
* Progressive Web App (PWA) support

---

## 👨‍💻 Author

**Ankit Goswami**

GitHub: https://github.com/Einsteinium01

---

## 📄 License

This project is intended for educational and learning purposes.
