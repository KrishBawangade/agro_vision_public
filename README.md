# 🌾 AgroVision: Data-Driven AI Solution for Precision Farming

AgroVision is a smart farming assistant designed to empower farmers with AI-driven recommendations, real-time data, and multi-language support. It integrates precision farming techniques to improve crop planning, increase productivity, and optimize resources.

---

## 🚀 Features

- **📍 Multi Farm-Plot Management**  
  Organize and manage multiple plots with detailed data per location.

- **🌤️ Weather Forecast (2-Day)**  
  Get accurate, location-based weather predictions to plan ahead.

- **📈 Real-Time Market Prices**  
  Daily updated crop market rates from local mandis using a reliable government API.

- **🤖 AI Chatbot (Gemini AI)**  
  Get instant answers to common agricultural queries.

- **📅 AI-Generated Crop Calendar**  
  Intelligent planting-to-harvest calendar tailored to your selected crop and location.

- **🌱 Data-Driven Crop Recommendation System**  
  Recommends the most suitable crops based on soil, temperature, rainfall, and other environmental factors using a deep learning model with ~97% accuracy.

- **🗣️ Multi-Language Support**  
  Available in 9 Indian languages: English, Hindi, Marathi, Telugu, Tamil, Gujarati, Bengali, Punjabi, and Kannada.

---

## 📦 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform mobile development |
| **Firebase Firestore** | Real-time database |
| **TensorFlow / Custom Deep Learning Model** | Crop recommendation logic |
| **Google Cloud / Gemini AI** | AI chatbot integration |
| **REST APIs** | Real-time crop market prices |
| **Easy Localization** | Multi-language support |

---

## 🛠️ Installation & Setup

Follow these steps to run AgroVision locally on your machine:

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/KrishBawangade/agro_vision_public.git
cd agrovision
```

### 2️⃣ Install Flutter Dependencies
Ensure you have Flutter installed.
```bash
flutter pub get
```

### 3️⃣ Add .env File for API Keys
Create a `.env` file in the root of your project and add your API keys:
```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
OPEN_WEATHER_API_KEY=your_open_weather_api_key
# Add other environment variables here
```

> ⚠️ **Security Warning:** Never commit your .env file to version control.

### 4️⃣ Run the App
```bash
flutter run
```

You can specify the device as needed:
```bash
flutter run -d chrome    # for web
flutter run -d android   # for Android
flutter run -d ios       # for iOS (Mac only)
```

---

## 📂 Folder Structure

```
lib/
├── 📁 models/               # Data models
├── 📁 providers/            # State management
├── 📁 services/             # API calls, AI integrations
├── 📁 pages/                # UI pages
├── 📁 widgets/              # Reusable components
└── 📁 utils/                # Helper functions, enums, strings
```

---

## 🔒 Privacy & Security

- ✅ No personal data is shared externally
- 🔐 All API keys are securely managed via .env and are not exposed in the public code
- 🕵️ AI queries are anonymized to maintain user privacy

---

## 👨‍💻 Author

<div align="center">

**Krish Bawangade**

[![email](https://img.shields.io/badge/email-krishbawangade08@gmail.com-red?style=flat&logo=gmail&logoColor=white)](mailto:krishbawangade08@gmail.com)
[![portfolio](https://img.shields.io/badge/portfolio-krishbawangade.vercel.app-blue?style=flat&logo=vercel&logoColor=white)](https://krishbawangade.vercel.app)

</div>

---

<div align="center">

**⭐ If you found this project helpful, please give it a star! ⭐**

</div>
