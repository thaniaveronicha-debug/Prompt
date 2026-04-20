import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
  runApp(const PromptApp());
}

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prompt Builder Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
          secondary: Colors.amber,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigoAccent, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          color: const Color(0xFF1E1E2C),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

// --- SISTEM KESELAMATAN (AUTH + DEVICE LOCK) ---
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isAuthorized = false;
  bool _isLoading = true;
  final TextEditingController _keyController = TextEditingController();

  final List<String> _validKeys = [
    "PROMPT-ADMIN-MASTER-99",
    "VIP-A7B9-XQ22", "VIP-K8L1-WP09", "VIP-Z2M4-RT88", "VIP-P9Q3-BJ11",
    "VIP-C5D2-KL66", "VIP-E8F9-TR44", "VIP-G1H3-NM55", "VIP-J7K4-OP22",
    "VIP-X0Y1-QW33", "VIP-V2B8-AS99", "VIP-N4M6-ER77", "VIP-U1I2-OP00",
    "VIP-Y9X8-GH55", "VIP-T2R3-WE11", "VIP-S4A5-DF22", "VIP-L7K8-JM09",
    "VIP-H2N8-XW11", "VIP-M5P9-LV44", "VIP-R1S6-KT77", "VIP-D3G4-QB22",
    "VIP-F9J2-PR55", "VIP-C7W1-NM88", "VIP-B4H9-XY33", "VIP-K2L6-VT00",
    "VIP-Q8R5-MD11", "VIP-Z1X3-CF44", "VIP-T6N2-GH99", "VIP-Y5V7-BK22",
    "VIP-P3S8-WR66", "VIP-E4F1-JT55", "VIP-A9M0-LQ88", "VIP-G2K5-NV33",
    "VIP-J4H7-RX11", "VIP-S9W2-TY44", "VIP-X3B6-PL77", "VIP-U8N1-VC22",
    "VIP-I5M4-KD55", "VIP-O2P9-XW88", "VIP-L6R3-ZM33", "VIP-V1C7-QT00",
    "VIP-N8B4-YG11", "VIP-M2W9-RF44", "VIP-D5K1-HJ77", "VIP-T7S3-PL22",
    "VIP-F4X8-NV55", "VIP-G9L2-WR88", "VIP-Q3C6-BM33", "VIP-E1N7-YX00",
    "VIP-Z4P5-HT11", "VIP-K9J3-SR44", "VIP-B2V1-LQ77", "VIP-A8M6-KW22",
    "VIP-H5R9-XN55", "VIP-W3G1-PF88", "VIP-S6B4-MT33", "VIP-Y2C8-RD00",
    "VIP-L9K5-VJ11", "VIP-X4N7-BW44", "VIP-U1M3-FP77", "VIP-P8S2-GQ22",
    "VIP-O5H9-LT55", "VIP-J3W1-RX88", "VIP-I7B6-KV33", "VIP-E2D4-MY00",
    "VIP-R9F5-TN11", "VIP-C3G8-LW44", "VIP-M6K2-VP77", "VIP-V4S1-HX22",
    "VIP-N7P9-RD55", "VIP-T2B3-KC88", "VIP-Q5L8-XF33", "VIP-Z1M4-WG00",
    "VIP-D9W2-TV11", "VIP-K4B7-RS44", "VIP-A3N6-PL77", "VIP-G8X1-KV22",
    "VIP-H2S5-MC55", "VIP-F7J9-WR88", "VIP-Y4P1-QT33", "VIP-S3M6-NY00",
    "VIP-L1V8-KF11", "VIP-X9B2-HJ44", "VIP-U5R7-XW77", "VIP-P2N4-MD22",
    "VIP-O8K1-TR55", "VIP-J6S3-VY88", "VIP-I2W9-LM33", "VIP-E7P4-XG00",
    "VIP-R3G1-KV11", "VIP-C8M5-PT44", "VIP-M1F9-YW77", "VIP-V5B2-NR22",
    "VIP-N9S6-XJ55", "VIP-T4L1-WH88", "VIP-Q2X8-BK33", "VIP-Z7N3-RT00",
    "VIP-D5H9-LP11", "VIP-K1P2-VX44", "VIP-A6W7-MY77", "VIP-G3S4-RD22",
    "VIP-H9F1-TW55", "VIP-F2B8-NK88", "VIP-Y7M3-XQ33", "VIP-S4K5-PL00",
    "VIP-L2N1-VH11", "VIP-X8J9-RT44", "VIP-U3P6-LW77", "VIP-P1R4-XC22",
    "VIP-O7G2-MF55", "VIP-J9D5-KV88", "VIP-I4B1-SY33", "VIP-E6M8-TW00",
    "VIP-R2S7-NX11", "VIP-C9W3-PL44", "VIP-M5L1-YK77", "VIP-V8X4-HD22",
    "VIP-N2P6-RV55", "VIP-T1S9-XW88", "VIP-Q7B2-MK33", "VIP-Z4G8-LT00",
    "VIP-D3K5-NF11", "VIP-K8W1-RP44", "VIP-A2P9-VX77", "VIP-G7J4-ML22",
    "VIP-H1X3-SY55", "VIP-F6S2-KW88", "VIP-Y9X6-BT33", "VIP-S2M7-RX00",
    "VIP-L4P1-VG11", "VIP-X7W8-NK44", "VIP-U2B3-PL77", "VIP-P9S6-RD22",
    "VIP-O1K4-MW55", "VIP-J8N2-XY88", "VIP-I5M9-FT33", "VIP-E3V7-LP00",
    "VIP-R6X1-NJ11", "VIP-C4S5-WQ44", "VIP-M9P2-BK77", "VIP-V3H8-RT22",
    "VIP-N1L7-MV55", "VIP-T8K4-XY88", "VIP-Q5G1-TW33", "VIP-Z2R9-PF00",
    "VIP-D7M3-NX11", "VIP-K1B6-WS44", "VIP-A9V2-RD77", "VIP-G4P8-LT22",
    "VIP-H6W1-MK55", "VIP-F3N7-XY88", "VIP-Y2S5-BR33", "VIP-S8X9-KV00",
    "VIP-L5M2-PL11", "VIP-X1G4-TW44", "VIP-U9P3-RD77", "VIP-P4B7-NX22",
    "VIP-O6S1-MK55", "VIP-J2W8-XY88", "VIP-I8R5-BT33", "VIP-E4N2-PF00",
    "VIP-R1K7-WQ11", "VIP-C5P9-MV44", "VIP-M2B4-RT77", "VIP-V7X1-NH22",
    "VIP-N8S3-BK55", "VIP-T3L6-XY88", "VIP-Q9W2-RD33", "VIP-Z5M4-TW00",
    "VIP-D1B8-PF11", "VIP-K6P1-NX44", "VIP-A4S7-MK77", "VIP-G9N2-XY22",
    "VIP-H3X5-RT55", "VIP-F8W1-MV88", "VIP-Y1P4-BT33", "VIP-S7G9-WQ00",
    "VIP-L3N2-PF11", "VIP-X6K8-NX44", "VIP-U1M5-MK77", "VIP-P7S3-XY22",
    "VIP-O4B9-RT55", "VIP-J1W4-MV88", "VIP-I9X2-BT33", "VIP-E5P7-WQ00",
    "VIP-R8G1-PF11", "VIP-C2N4-NX44", "VIP-M7S8-MK77", "VIP-V1W3-XY22",
    "VIP-N4X9-RT55", "VIP-T9B2-MV88", "VIP-Q3P6-BT33", "VIP-Z8M1-WQ00",
    "VIP-D4S7-PF11", "VIP-K2G9-NX44", "VIP-A1W4-MK77", "VIP-G7P3-XY22",
    "VIP-H5N8-RT55", "VIP-F1B2-MV88", "VIP-Y9X6-BT33", "VIP-S2S5-WQ00"
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isAuthorized = prefs.getBool('isAuthorized') ?? false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _authorize() async {
    String inputKey = _keyController.text.trim().toUpperCase();
    if (inputKey.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      String? myDeviceId = prefs.getString('device_fingerprint');
      if (myDeviceId == null) {
        myDeviceId = "WEB-${Random().nextInt(999999)}-${DateTime.now().millisecondsSinceEpoch}";
        await prefs.setString('device_fingerprint', myDeviceId);
      }

      if (!_validKeys.contains(inputKey)) {
        _showError("Kunci Lesen tidak sah atau salah taip!");
        return;
      }

      if (inputKey != "PROMPT-ADMIN-MASTER-99") {
        final docRef = FirebaseFirestore.instance.collection('licenses').doc(inputKey);
        final doc = await docRef.get();
        if (doc.exists) {
          String? registeredDevice = doc.data()?['deviceId'];
          if (registeredDevice != null && registeredDevice != myDeviceId) {
            _showError("MAAF! Kunci ini sudah didaftarkan pada peranti lain.");
            return;
          }
        } else {
          await docRef.set({
            'deviceId': myDeviceId,
            'activatedAt': FieldValue.serverTimestamp(),
            'status': 'active'
          });
        }
      }

      await prefs.setBool('isAuthorized', true);
      setState(() {
        _isAuthorized = true;
        _isLoading = false;
      });
    } catch (e) {
      _showError("Ralat Cloud: Sila pastikan anda mempunyai internet.");
    }
  }

  void _showError(String msg) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_isAuthorized) return const PromptGenerator();

    return Scaffold(
      backgroundColor: const Color(0xFF12121F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phonelink_lock, size: 64, color: Colors.indigoAccent),
                    const SizedBox(height: 16),
                    const Text("Aktivasi Peranti", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text(
                      "Kod lesen anda akan diikat (locked) pada peranti ini secara kekal untuk mengelakkan perkongsian haram.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.white60),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _keyController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Kunci Lesen",
                        prefixIcon: Icon(Icons.key, color: Colors.indigoAccent),
                      ),
                      onSubmitted: (_) => _authorize(),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _authorize,
                        child: const Text("Aktifkan Sekarang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- DASHBOARD UTAMA (PROMPT GENERATOR) ---
class PromptGenerator extends StatefulWidget {
  const PromptGenerator({super.key});
  @override
  State<PromptGenerator> createState() => _PromptGeneratorState();
}

class _PromptGeneratorState extends State<PromptGenerator> {
  String tajuk = "";
  String tarikh = "";
  String masa = "";
  String tempat = "";
  String maklumatTambahan = "";
  String kategori = "Poster";
  String sasaran = "Semua Pelajar";
  String watakUtama = "Pelajar (Menengah/U)";
  String etnikWatak = "Melayu";
  String karakterAnime = "Tiada";
  String gayaDesign = "Sci-Fi Futuristik";
  String gayaArtistik = "Soft Studio Light";
  String gayaLensa = "Wide Angle";
  String jenisImej = "Foto Realistik";
  String jenisPakaian = "Pakaian Sekolah";
  String susunanBahasa = "Formal DBP";
  String modeSusunan = "Minimalis";
  String gayaFont = "Modern Sans Serif";
  String posterViral = "Kontras Tinggi";
  String temaWarna = "Vibrant / Bold";
  String bilanganFrame = "4 Panel";
  String gayaKotakDialog = "Rounded";

  // OOTD Specific Fields
  String ootdSubjek = "";
  String ootdEmosi = "";
  String ootdPersekitaran = "";
  String ootdGaya = "";
  String ootdPencahayaan = "";
  String teksUcapan = "";

  final List<String> listWatakUtama = ["Pelajar (Rendah/Tadika)", "Pelajar (Menengah/U)", "Guru / Pensyarah / Pendidik", "Doktor / Jururawat / Petugas Kesihatan", "Polis / Tentera / Bomba / Penyelamat", "Pekerja Pejabat / Eksekutif / Korporat", "Usahawan / Peniaga / Penjaja", "Atlet / Ahli Sukan / Ahli Gim", "Saintis / Penyelidik / Jurutera", "Petani / Nelayan / Pekebun / Buruh", "Kanak-kanak / Bayi", "Warga Emas / Atuk / Nenek", "Ibu Bapa / Suri Rumah", "Karakter Fantasi / Legend / Adiwira", "Tiada Watak"];
  final List<String> listGayaDesign = ["Gaya Epik", "Komedi & Humor", "Aksi & Pengembaraan", "Sci-Fi Futuristik", "Dokumentari & Fakta", "Romantik", "Filem Realistik", "Poster Aksi", "Poster 3D", "Cute 3D Pixar", "Kartun", "Retro", "Minimalis"];
  final List<String> listGayaArtistik = ["Soft Studio Light", "Golden Hour (Senja)", "Neon Glow (Cyberpunk)", "Kesan Kabus / Habuk", "Cahaya Tajam (Rim Lighting)", "Cinematic Shadow"];
  final List<String> listTemaWarna = ["Vibrant / Bold", "Pastel Lembut", "Monokrom", "Earth Tones", "Luxury Gold & Black"];
  final List<String> listGayaFont = ["Modern Sans Serif", "Elegant Serif", "Bold Display", "Handwritten", "Calligraphy", "Cyberpunk Font", "Chalkboard Style"];
  final List<String> listPakaian = ["Casual", "Pakaian Perayaan", "Pakaian Tradisional", "T-Shirt", "Jersey", "OOTD Trend", "Bertudung Shawl", "Bertudung Bawal", "Style Kampung", "Style Bandar", "Style Pejabat", "Pakaian Ikut Pekerjaan", "Pakaian Sekolah"];

  void _applyMagicPreset(String theme) {
    setState(() {
      if (theme == "Pixar") {
        kategori = "Poster"; jenisImej = "3D Render"; gayaDesign = "Cute 3D Pixar"; gayaArtistik = "Soft Studio Light"; temaWarna = "Vibrant / Bold"; gayaFont = "Bold Display"; modeSusunan = "Fokus Watak"; jenisPakaian = "Casual"; watakUtama = "Kanak-kanak / Bayi";
      } else if (theme == "Cyber") {
        kategori = "Poster"; jenisImej = "Ilustrasi Digital"; gayaDesign = "Sci-Fi Futuristik"; gayaArtistik = "Neon Glow (Cyberpunk)"; temaWarna = "Monokrom"; gayaFont = "Cyberpunk Font"; modeSusunan = "Minimalis"; jenisPakaian = "OOTD Trend"; watakUtama = "Pekerja Pejabat / Eksekutif / Korporat";
      } else if (theme == "Cikgu") {
        kategori = "Poster"; jenisImej = "Foto Realistik"; gayaDesign = "Dokumentari & Fakta"; gayaArtistik = "Soft Studio Light"; temaWarna = "Earth Tones"; gayaFont = "Modern Sans Serif"; modeSusunan = "Padat"; susunanBahasa = "Formal DBP"; jenisPakaian = "Style Pejabat"; watakUtama = "Guru / Pensyarah / Pendidik";
      } else if (theme == "Ghibli") {
        kategori = "Poster"; jenisImej = "Ilustrasi Digital"; gayaDesign = "Kartun"; karakterAnime = "Tiada"; gayaArtistik = "Golden Hour (Senja)"; temaWarna = "Pastel Lembut"; gayaFont = "Handwritten"; jenisPakaian = "Style Kampung"; watakUtama = "Kanak-kanak / Bayi";
      } else if (theme == "Vintage") {
        kategori = "Poster"; jenisImej = "Foto Realistik"; gayaDesign = "Retro"; gayaArtistik = "Cinematic Shadow"; temaWarna = "Earth Tones"; gayaFont = "Calligraphy"; jenisPakaian = "Pakaian Tradisional"; watakUtama = "Warga Emas / Atuk / Nenek";
      } else if (theme == "Corporate") {
        kategori = "Infografik"; jenisImej = "Vektor"; gayaDesign = "Minimalis"; gayaArtistik = "Soft Studio Light"; temaWarna = "Monokrom"; gayaFont = "Modern Sans Serif"; modeSusunan = "Padat"; jenisPakaian = "Style Pejabat"; watakUtama = "Usahawan / Peniaga / Penjaja";
      } else if (theme == "Epic") {
        kategori = "Poster"; jenisImej = "3D Render"; gayaDesign = "Gaya Epik"; gayaArtistik = "Cahaya Tajam (Rim Lighting)"; temaWarna = "Luxury Gold & Black"; gayaFont = "Bold Display"; modeSusunan = "Fokus Watak"; jenisPakaian = "Pakaian Ikut Pekerjaan"; watakUtama = "Karakter Fantasi / Legend / Adiwira";
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Tema $theme diaplikasikan! ✨"), duration: const Duration(seconds: 1)));
  }

  void _randomizeAll() {
    final random = Random();
    setState(() {
      watakUtama = listWatakUtama[random.nextInt(listWatakUtama.length)];
      gayaDesign = listGayaDesign[random.nextInt(listGayaDesign.length)];
      gayaArtistik = listGayaArtistik[random.nextInt(listGayaArtistik.length)];
      temaWarna = listTemaWarna[random.nextInt(listTemaWarna.length)];
      gayaFont = listGayaFont[random.nextInt(listGayaFont.length)];
      jenisImej = ["Foto Realistik", "Ilustrasi Digital", "3D Render", "Vektor"][random.nextInt(4)];
      jenisPakaian = listPakaian[random.nextInt(listPakaian.length)];
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilihan rawak dijana! 🎲")));
  }

  String generateFinalPrompt() {
    String orientation = kategori == "Banner" ? "Landskap Lebar (16:9)" : (kategori == "Infografik" ? "Potret Panjang (9:16)" : "Potret Sosial Media (4:5)");
    String specificDetails = "";
    String rujukImej = "RUJUKAN: Imej muat naik 100% (jika ada). Persamaan muka & struktur asal. Senyuman lembut.";

    if (kategori == "Banner") {
      specificDetails = "FORMAT BANNER:\n- Fokus ruang kosong tengah untuk teks.\n- Grafik di sisi.\n- Tajuk: $tajuk\n- Tarikh: $tarikh\n- Masa: $masa\n- Tempat: $tempat";
    } else if (kategori == "Komik") {
      specificDetails = "FORMAT KOMIK:\n- Struktur: $bilanganFrame\n- Gaya Kotak Dialog: $gayaKotakDialog\n- Tajuk Cerita: $tajuk";
    } else if (kategori == "Infografik") {
      specificDetails = "FORMAT INFOGRAFIK:\n- Susunan sistematik atas ke bawah.\n- Gunakan ikon/simbol.\n- Topik: $tajuk\n- Isi Kandungan: $maklumatTambahan";
    } else if (kategori == "OOTD") {
      String textInImage = teksUcapan.isNotEmpty ? "Sila taipkan teks berikut pada imej dengan gaya tipografi yang cantik: \"$teksUcapan\"." : "JANGAN masukkan sebarang teks, label, atau tulisan dalam imej. Kosongkan daripada sebarang teks.";
      specificDetails = "PENERANGAN VISUAL OOTD: $ootdSubjek sedang $ootdEmosi di $ootdPersekitaran. Gaya visual adalah $ootdGaya dengan pencahayaan $ootdPencahayaan. $textInImage";
      rujukImej = "RUJUKAN OOTD: Jika ada gambar dilampirkan, Gunakan imej asal sebagai asas utama. Kekalkan wajah, struktur muka, mata, hidung, mulut dan ekspresi 100% tanpa sebarang perubahan. Jangan ubah identiti wajah walaupun sedikit.";
    } else {
      specificDetails = "FORMAT POSTER:\n- Tajuk: $tajuk\n- Tarikh: $tarikh\n- Masa: $masa\n- Tempat: $tempat";
    }

    String closingSentence = kategori == "Komik" && gayaDesign == "Komedi & Humor" 
        ? "Sila hasilkan visual komik yang lucu dan menghiburkan." 
        : (kategori == "OOTD" ? "Sila hasilkan visual OOTD yang estetik dan trendy." : "Sila hasilkan visual $kategori bergaya $gayaDesign yang profesional.");

    String textRule = (kategori == "OOTD" && teksUcapan.isEmpty) ? "PENTING: JANGAN MASUKKAN SEBARANG TEKS PADA IMEJ. BIARKAN IMEJ BERSIH TANPA TULISAN." : "Pastikan maklumat teks dipaparkan dengan jelas dan estetik.";

    return """
RULES: Standard DBP (Bahasa Melayu). Tiada Inggeris/Indonesia. Orientasi: $orientation.
$rujukImej

VISUAL & LAYOUT: $jenisImej | $kategori. $specificDetails
WATAK: $watakUtama | Etnik: $etnikWatak | Gaya: $karakterAnime | Pakaian: $jenisPakaian.
ARTISTIC: Gaya: $gayaDesign | Cahaya: $gayaArtistik | Lensa: $gayaLensa | Warna: $temaWarna | Layout: $modeSusunan | Font: $gayaFont.

$closingSentence $textRule""";
  }

  @override
  Widget build(BuildContext context) {
    IconData step2Icon = kategori == "Komik" ? Icons.auto_stories : (kategori == "Infografik" ? Icons.bar_chart : (kategori == "OOTD" ? Icons.checkroom : Icons.description_outlined));
    return Scaffold(
      backgroundColor: const Color(0xFF12121F),
      appBar: AppBar(
        title: const Text("Prompt Builder Pro", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('isAuthorized');
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                );
              }
            },
          )
        ],
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.indigo, Colors.deepPurple]))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionCard(
              title: "Pilihan Pantas & Ajaib",
              icon: Icons.auto_awesome,
              color: Colors.pinkAccent,
              child: GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 3.2,
                children: [
                  _buildMagicButton("✨ Surprise Me", Icons.casino, Colors.purple, _randomizeAll),
                  _buildMagicButton("🎬 Pixar Style", Icons.movie_filter, Colors.orange, () => _applyMagicPreset("Pixar")),
                  _buildMagicButton("🌌 Cyberpunk", Icons.rocket_launch, Colors.blue, () => _applyMagicPreset("Cyber")),
                  _buildMagicButton("📚 Mood Cikgu", Icons.school, Colors.green, () => _applyMagicPreset("Cikgu")),
                  _buildMagicButton("🍃 Ghibli", Icons.eco, Colors.teal, () => _applyMagicPreset("Ghibli")),
                  _buildMagicButton("🎞️ Vintage", Icons.camera_roll, Colors.brown, () => _applyMagicPreset("Vintage")),
                  _buildMagicButton("🏢 Corporate", Icons.business, Colors.blueGrey, () => _applyMagicPreset("Corporate")),
                  _buildMagicButton("🔥 Epic Movie", Icons.local_fire_department, Colors.redAccent, () => _applyMagicPreset("Epic")),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(title: "Langkah 1: Versi Output", icon: Icons.layers_outlined, color: Colors.amberAccent, child: _buildDropdown("Versi Output", kategori, ["Poster", "Banner", "Komik", "Infografik", "OOTD"], (val) => setState(() => kategori = val!))),
            if (kategori == "OOTD") ...[
              const SizedBox(height: 16),
              _buildSectionCard(
                title: "Konfigurasi OOTD (5 Elemen)",
                icon: Icons.style,
                color: Colors.purpleAccent,
                child: Column(
                  children: [
                    TextField(decoration: const InputDecoration(labelText: "1. Subjek", hintText: "Cth: Wanita Melayu bertudung"), onChanged: (val) => setState(() => ootdSubjek = val)),
                    const SizedBox(height: 12),
                    TextField(decoration: const InputDecoration(labelText: "2. Emosi", hintText: "Cth: Sedih,gembira,marah,takut"), onChanged: (val) => setState(() => ootdEmosi = val)),
                    const SizedBox(height: 12),
                    TextField(decoration: const InputDecoration(labelText: "3. Persekitaran", hintText: "Contoh: Kafe moden di KLCC"), onChanged: (val) => setState(() => ootdPersekitaran = val)),
                    const SizedBox(height: 12),
                    TextField(decoration: const InputDecoration(labelText: "4. Gaya", hintText: "Cth: sedang menaiki motosikal"), onChanged: (val) => setState(() => ootdGaya = val)),
                    const SizedBox(height: 12),
                    TextField(decoration: const InputDecoration(labelText: "5. Pencahayaan", hintText: "Cth: Cahaya matahari waktu senja"), onChanged: (val) => setState(() => ootdPencahayaan = val)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            _buildSectionCard(
              title: "Langkah 2: Kandungan & Teks", icon: step2Icon, color: Colors.blueAccent,
              child: Column(
                children: [
                  TextField(decoration: InputDecoration(labelText: kategori == "Komik" ? "Tajuk Cerita" : (kategori == "OOTD" ? "Tema OOTD" : "Tajuk Program"), hintText: kategori == "OOTD" ? "Cth: Moden, Klasik, Alam sekitar, Korporat" : null, prefixIcon: const Icon(Icons.title)), onChanged: (val) => setState(() => tajuk = val)),
                  const SizedBox(height: 12),
                  TextField(decoration: const InputDecoration(labelText: "Ucapan / Teks pada Imej", hintText: "Teks yang akan ditaip terus pada gambar", prefixIcon: Icon(Icons.text_fields_rounded)), onChanged: (val) => setState(() => teksUcapan = val)),
                  if (kategori != "Komik" && kategori != "Infografik" && kategori != "OOTD") ...[
                    const SizedBox(height: 12),
                    Row(children: [Expanded(child: TextField(decoration: const InputDecoration(labelText: "Tarikh", prefixIcon: Icon(Icons.calendar_month)), onChanged: (val) => setState(() => tarikh = val))), const SizedBox(width: 8), Expanded(child: TextField(decoration: const InputDecoration(labelText: "Masa", prefixIcon: Icon(Icons.schedule)), onChanged: (val) => setState(() => masa = val)))]),
                    const SizedBox(height: 12),
                    TextField(decoration: const InputDecoration(labelText: "Tempat", prefixIcon: Icon(Icons.location_on)), onChanged: (val) => setState(() => tempat = val)),
                  ],
                  if (kategori == "Komik") ...[
                    const SizedBox(height: 12),
                    _buildDropdown("Panel", bilanganFrame, ["1 Panel", "3 Panel", "4 Panel", "6 Panel"], (val) => setState(() => bilanganFrame = val!)),
                    _buildDropdown("Kotak Dialog", gayaKotakDialog, ["Rounded", "Sharp Edge", "Dotted", "Retro"], (val) => setState(() => gayaKotakDialog = val!)),
                  ],
                  const SizedBox(height: 12),
                  TextField(maxLines: 3, decoration: InputDecoration(labelText: kategori == "Infografik" ? "Isi Kandungan" : "Info Tambahan", prefixIcon: const Icon(Icons.info_outline)), onChanged: (val) => setState(() => maklumatTambahan = val)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(title: "Langkah 3: Visual", icon: Icons.palette_outlined, color: Colors.orangeAccent, child: Column(children: [_buildDropdown("Jenis Imej", jenisImej, ["Foto Realistik", "Ilustrasi Digital", "3D Render", "Vektor"], (val) => setState(() => jenisImej = val!)), _buildDropdown("Gaya Design", gayaDesign, listGayaDesign, (val) => setState(() => gayaDesign = val!)), _buildDropdown("Cahaya", gayaArtistik, listGayaArtistik, (val) => setState(() => gayaArtistik = val!)), _buildDropdown("Warna", temaWarna, listTemaWarna, (val) => setState(() => temaWarna = val!)), _buildDropdown("Lensa", gayaLensa, ["Wide Angle", "Bokeh", "Macro", "Fisheye"], (val) => setState(() => gayaLensa = val!))])),
            if (kategori != "OOTD") ...[
              const SizedBox(height: 16),
              _buildSectionCard(title: "Langkah 4: Watak", icon: Icons.face_retouching_natural, color: Colors.greenAccent, child: Column(children: [_buildDropdown("Watak Utama", watakUtama, listWatakUtama, (val) => setState(() => watakUtama = val!)), _buildDropdown("Etnik", etnikWatak, ["Melayu", "Cina", "India", "Kadazan", "Iban", "Kaukasia"], (val) => setState(() => etnikWatak = val!)), _buildDropdown("Anime", karakterAnime, ["Tiada", "Shonen", "Shojo", "Seinen", "Chibi", "90s Retro"], (val) => setState(() => karakterAnime = val!)), _buildDropdown("Pakaian", jenisPakaian, listPakaian, (val) => setState(() => jenisPakaian = val!))])),
              const SizedBox(height: 16),
              _buildSectionCard(title: "Langkah 5: Tipografi", icon: Icons.grid_view_outlined, color: Colors.pinkAccent, child: Column(children: [_buildDropdown("Font", gayaFont, listGayaFont, (val) => setState(() => gayaFont = val!)), _buildDropdown("Bahasa", susunanBahasa, ["Formal DBP", "Santai", "Puitis", "Informatif"], (val) => setState(() => susunanBahasa = val!)), _buildDropdown("Layout", modeSusunan, ["Minimalis", "Padat", "Fokus Watak", "Tipografi"], (val) => setState(() => modeSusunan = val!)), _buildDropdown("Viral", posterViral, ["Kontras Tinggi", "Hook Headline", "Trending", "Bold"], (val) => setState(() => posterViral = val!)), _buildDropdown("Sasaran", sasaran, ["Semua Pelajar", "Guru", "Ibu Bapa", "Kanak-kanak", "Awam"], (val) => setState(() => sasaran = val!))])),
            ],
            const SizedBox(height: 24),
            Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2A2A3D), Color(0xFF1E1E2C)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.indigoAccent.withOpacity(0.3))), child: SelectableText(generateFinalPrompt(), style: const TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.4))),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 60, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () { Clipboard.setData(ClipboardData(text: generateFinalPrompt())); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Prompt berjaya disalin!"))); }, icon: const Icon(Icons.copy_all_rounded), label: const Text("Jana & Salin Prompt", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMagicButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.5), width: 1.5)),
          child: Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 8), Expanded(child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis))]),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Color color, required Widget child}) {
    return Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: color, size: 28), const SizedBox(width: 12), Expanded(child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color), overflow: TextOverflow.ellipsis))]), const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(height: 1)), child])));
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white70)), const SizedBox(height: 8), DropdownButtonFormField<String>(value: value, isExpanded: true, icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.indigoAccent), items: items.map((String val) => DropdownMenuItem<String>(value: val, child: Text(val))).toList(), onChanged: onChanged)]));
  }
}
