# 🌤️ Cuaca Kalimantan Tengah

Aplikasi berbasis **Flutter** untuk melihat prakiraan cuaca saat ini di beberapa kabupaten dan kota yang terletak di Provinsi Kalimantan Tengah. Proyek ini dibuat untuk memenuhi tugas dokumentasi fungsionalitas aplikasi.

---

## 📌 Deskripsi & Fungsi Aplikasi

Aplikasi ini dirancang untuk memberikan informasi cuaca yang ringkas, cepat, dan akurat secara real-time. Pengguna dapat memilih lokasi kabupaten/kota yang diinginkan, lalu aplikasi secara otomatis menarik data cuaca terkini menggunakan layanan pihak ketiga.

### 🔹 Fitur Utama
* **Pilihan Lokasi Kalteng:** Mendukung pengecekan lokasi untuk Palangkaraya, Sampit, Pangkalan Bun, Muara Teweh, Kuala Kapuas, Buntok, dan Puruk Cahu.
* **Default Load:** Memuat data cuaca kota Palangkaraya secara otomatis saat aplikasi pertama kali dibuka.
* **Informasi Cuaca Real-Time:** Menampilkan info suhu saat ini, kecepatan angin, dan kode status kondisi cuaca.
* **State Indicator:** Menampilkan indikator loading saat data sedang dimuat serta pesan error yang jelas ketika permintaan data ke API gagal.

---

## 🏗️ Arsitektur & Alur Kerja Sistem

Sistem berjalan dengan memanfaatkan koordinat lintang (*latitude*) dan bujur (*longitude*) dari masing-masing kota untuk meminta data cuaca dari server eksternal:

```text
Aplikasi Flutter │ permintaan HTTP 
                 ▼ 
       Open-Meteo Forecast API 
                 │ respons JSON 
                 ▼ 
      CurrentWeather.fromJson() 
                 │ 
                 ▼ 
     Tampilan cuaca di aplikasi
```

* **KaltengCity:** Berfungsi menyimpan data nama kota beserta koordinat geografisnya.
* **CurrentWeather:** Berfungsi melakukan *parsing* atau mengubah respons format JSON dari API menjadi objek data yang siap ditampilkan pada antarmuka (UI) aplikasi.

---

## 📂 Struktur Folder Proyek

```text
weather_kalteng/
├── android/          # Konfigurasi aplikasi untuk platform Android
├── ios/              # Konfigurasi aplikasi untuk platform iOS
├── lib/
│   ├── main.dart         # Aplikasi utama, daftar kota, dan kode UI
│   └── weather_model.dart # Model data untuk objek kota dan cuaca
├── pubspec.yaml      # Dependensi library dan konfigurasi Flutter
└── README.md         # Dokumentasi proyek
```

---

## 💻 Panduan Menjalankan Aplikasi

Pastikan laptop Anda sudah terinstal **Flutter SDK** dan perangkat (emulator/HP fisik) terhubung ke internet untuk mengambil data dari Open-Meteo. Jalankan perintah berikut di terminal:

```bash
# Mengambil semua dependensi/library yang diperlukan
flutter pub get

# Menjalankan aplikasi ke perangkat atau emulator Anda
flutter run
```

---

