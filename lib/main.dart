import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      ),
      home: const AuthGate(),
    );
  }
}

// --- SISTEM KESELAMATAN (AUTH) ---
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isAuthorized = false;
  bool _isLoading = true;
  final TextEditingController _keyController = TextEditingController();

  // Menjana 200 ID secara automatik: PROMPTVIP001 hingga PROMPTVIP200
  final List<String> _validKeys = List.generate(200, (index) {
    return "PROMPTVIP${(index + 1).toString().padLeft(3, '0')}";
  });

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
    
    if (inputKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sila masukkan kunci lesen!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    if (_validKeys.contains(inputKey)) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthorized', true);
        setState(() {
          _isAuthorized = true;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kunci Lesen Tidak Sah!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
                    const Icon(Icons.security, size: 64, color: Colors.indigoAccent),
                    const SizedBox(height: 16),
                    const Text("Aktifkan Lesen", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("Satu Kunci untuk satu peranti sahaja. Masukkan kod PROMPTVIPxxx anda.", textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _keyController,
                      decoration: const InputDecoration(
                        labelText: "Kunci Lesen",
                        hintText: "Contoh: PROMPTVIP001",
                        prefixIcon: Icon(Icons.key),
                      ),
                      onSubmitted: (_) => _authorize(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
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

// --- DASHBOARD UTAMA ---
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
  String karakterAnime = "Tiada / Bukan Anime";
  String gayaDesign = "Sci-Fi Futuristik";
  String gayaArtistik = "Soft Studio Light";
  String gayaLensa = "Wide Angle (4k)";
  String jenisImej = "Foto Realistik";
  String jenisPakaian = "Pakaian Sekolah";
  String susunanBahasa = "Formal DBP";
  String modeSusunan = "Minimalis Modern";
  String gayaFont = "Modern Sans Serif";
  String posterViral = "Warna Kontras Tinggi";
  String temaWarna = "Vibrant / Bold";
  String bilanganFrame = "4 Panel (Grid)";
  String gayaKotakDialog = "Kotak Dialog Moden (Rounded)";

  final List<String> listWatakUtama = ["Pelajar (Rendah/Tadika)", "Pelajar (Menengah/U)", "Guru / Pensyarah / Pendidik", "Doktor / Jururawat / Petugas Kesihatan", "Polis / Tentera / Bomba / Penyelamat", "Pekerja Pejabat / Eksekutif / Korporat", "Usahawan / Peniaga / Penjaja", "Atlet / Ahli Sukan / Ahli Gim", "Saintis / Penyelidik / Jurutera", "Petani / Nelayan / Pekebun / Buruh", "Kanak-kanak / Bayi", "Warga Emas / Atuk / Nenek", "Ibu Bapa / Suri Rumah", "Karakter Fantasi / Legend / Adiwira", "Tiada Watak"];
  final List<String> listGayaDesign = ["Gaya Epik", "Komedi & Humor", "Aksi & Pengembaraan", "Sci-Fi Futuristik", "Dokumentari & Fakta", "Romantik", "Filem Realistik", "Poster Aksi", "Poster 3D", "Cute 3D Pixar", "Kartun"];
  final List<String> listGayaArtistik = ["Soft Studio Light", "Golden Hour (Senja)", "Neon Glow (Cyberpunk)", "Kesan Kabus / Habuk", "Cahaya Tajam (Rim Lighting)", "Cinematic Shadow"];
  final List<String> listTemaWarna = ["Vibrant / Bold", "Pastel Lembut", "Monokrom", "Earth Tones", "Luxury Gold & Black"];
  final List<String> listGayaFont = ["Modern Sans Serif", "Elegant Serif", "Bold Display", "Handwritten", "Calligraphy", "Cyberpunk Font", "Chalkboard Style"];
  final List<String> listPakaian = ["Casual", "Pakaian Perayaan", "Pakaian Tradisional", "T-Shirt", "Jersey", "OOTD Trend", "Bertudung Shawl", "Bertudung Bawal", "Style Kampung", "Style Bandar", "Style Pejabat", "Pakaian Ikut Pekerjaan", "Pakaian Sekolah"];

  void _applyMagicPreset(String theme) {
    setState(() {
      if (theme == "Pixar") {
        kategori = "Poster"; jenisImej = "3D Render"; gayaDesign = "Cute 3D Pixar"; gayaArtistik = "Soft Studio Light"; temaWarna = "Vibrant / Bold"; gayaFont = "Bold Display"; modeSusunan = "Fokus Watak"; jenisPakaian = "Casual"; watakUtama = "Kanak-kanak / Bayi";
      } else if (theme == "Cyber") {
        kategori = "Poster"; jenisImej = "Ilustrasi Digital"; gayaDesign = "Sci-Fi Futuristik"; gayaArtistik = "Neon Glow (Cyberpunk)"; temaWarna = "Monokrom"; gayaFont = "Cyberpunk Font"; modeSusunan = "Minimalis Modern"; jenisPakaian = "OOTD Trend"; watakUtama = "Pekerja Pejabat / Eksekutif / Korporat";
      } else if (theme == "Cikgu") {
        kategori = "Poster"; jenisImej = "Foto Realistik"; gayaDesign = "Dokumentari & Fakta"; gayaArtistik = "Soft Studio Light"; temaWarna = "Earth Tones"; gayaFont = "Modern Sans Serif"; modeSusunan = "Padat Maklumat"; susunanBahasa = "Formal DBP"; jenisPakaian = "Style Pejabat"; watakUtama = "Guru / Pensyarah / Pendidik";
      } else if (theme == "Ghibli") {
        kategori = "Poster"; jenisImej = "Ilustrasi Digital"; gayaDesign = "Kartun"; karakterAnime = "Shojo (Elegant)"; gayaArtistik = "Golden Hour (Senja)"; temaWarna = "Pastel Lembut"; gayaFont = "Handwritten"; jenisPakaian = "Style Kampung"; watakUtama = "Kanak-kanak / Bayi";
      } else if (theme == "Vintage") {
        kategori = "Poster"; jenisImej = "Lukisan Minyak"; gayaDesign = "Retro"; gayaArtistik = "Cinematic Shadow"; temaWarna = "Earth Tones"; gayaFont = "Calligraphy"; jenisPakaian = "Pakaian Tradisional"; watakUtama = "Warga Emas / Atuk / Nenek";
      } else if (theme == "Corporate") {
        kategori = "Infografik"; jenisImej = "Vektor"; gayaDesign = "Minimalis"; gayaArtistik = "Soft Studio Light"; temaWarna = "Monokrom"; gayaFont = "Modern Sans Serif"; modeSusunan = "Padat Maklumat"; jenisPakaian = "Style Pejabat"; watakUtama = "Usahawan / Peniaga / Penjaja";
      } else if (theme == "Epic") {
        kategori = "Poster"; jenisImej = "3D Render"; gayaDesign = "Gaya Epik"; gayaArtistik = "Cahaya Tajam (Rim Lighting)"; temaWarna = "Luxury Gold & Black"; gayaFont = "Bold Display"; modeSusunan = "Fokus Watak"; jenisPakaian = "Pakaian Ikut Pekerjaan"; watakUtama = "Karakter Fantasi / Legend / Adiwira";
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Tema $theme diaplikasikan!"), duration: const Duration(seconds: 1)));
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilihan rawak dijana! ✨")));
  }

  String generateFinalPrompt() {
    String orientation = "Potret Sosial Media (4:5)";
    String specificDetails = "";
    if (kategori == "Banner") {
      orientation = "Landskap Lebar (16:9)";
      specificDetails = "FORMAT BANNER:\n- Fokus ruang kosong tengah untuk teks.\n- Grafik di sisi.\n- Tajuk: $tajuk\n- Tarikh: $tarikh\n- Masa: $masa\n- Tempat: $tempat";
    } else if (kategori == "Komik") {
      orientation = "Panel Komik (Layout Grid)";
      specificDetails = "FORMAT KOMIK:\n- Struktur: $bilanganFrame\n- Gaya Kotak Dialog: $gayaKotakDialog\n- Tajuk: $tajuk";
    } else if (kategori == "Infografik") {
      orientation = "Potret Panjang (9:16)";
      specificDetails = "FORMAT INFOGRAFIK:\n- Susunan sistematik atas ke bawah.\n- Gunakan ikon/ilustrasi.\n- Tajuk: $tajuk\n- Isi: $maklumatTambahan";
    } else {
      specificDetails = "FORMAT POSTER:\n- Tajuk: $tajuk\n- Tarikh: $tarikh\n- Masa: $masa\n- Tempat: $tempat";
    }

    String closing = kategori == "Komik" && gayaDesign == "Komedi & Humor" 
        ? "Sila hasilkan visual komik yang lucu dan menghiburkan." 
        : "Sila hasilkan visual $kategori bergaya $gayaDesign yang profesional dan estetik.";

    return """
RULES: Standard DBP (Bahasa Melayu). Tiada Inggeris/Indonesia. Orientasi: $orientation.
RUJUKAN: Imej muat naik (jika ada). Persamaan muka & struktur muka 100%. Senyuman lembut.

VISUAL: $jenisImej | $kategori
$specificDetails
WATAK: $watakUtama | Etnik: $etnikWatak | Gaya: $karakterAnime | Pakaian: $jenisPakaian.
ARTISTIK: Gaya: $gayaDesign | Cahaya: $gayaArtistik | Lensa: $gayaLensa | Warna: $temaWarna | Layout: $modeSusunan | Font: $gayaFont.

$closing Pastikan teks jelas.""";
  }

  @override
  Widget build(BuildContext context) {
    IconData step2Icon = kategori == "Komik" ? Icons.auto_stories : (kategori == "Infografik" ? Icons.bar_chart : Icons.description_outlined);
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
              await prefs.clear();
              SystemNavigator.pop();
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
            _buildSectionCard(title: "Langkah 1: Versi Output", icon: Icons.layers_outlined, color: Colors.amberAccent, child: _buildDropdown("Versi Output", kategori, ["Poster", "Banner", "Komik", "Infografik"], (val) => setState(() => kategori = val!))),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: "Langkah 2: Kandungan", icon: step2Icon, color: Colors.blueAccent,
              child: Column(
                children: [
                  TextField(decoration: InputDecoration(labelText: kategori == "Komik" ? "Tajuk Cerita" : "Tajuk Program", prefixIcon: const Icon(Icons.title)), onChanged: (val) => setState(() => tajuk = val)),
                  if (kategori != "Komik" && kategori != "Infografik") ...[
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
                  TextField(maxLines: 3, decoration: InputDecoration(labelText: kategori == "Infografik" ? "Isi Fakta" : "Info Tambahan", prefixIcon: const Icon(Icons.info_outline)), onChanged: (val) => setState(() => maklumatTambahan = val)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(title: "Langkah 3: Visual", icon: Icons.palette_outlined, color: Colors.orangeAccent, child: Column(children: [_buildDropdown("Jenis Imej", jenisImej, ["Foto Realistik", "Ilustrasi Digital", "3D Render", "Vektor"], (val) => setState(() => jenisImej = val!)), _buildDropdown("Gaya Design", gayaDesign, listGayaDesign, (val) => setState(() => gayaDesign = val!)), _buildDropdown("Cahaya", gayaArtistik, listGayaArtistik, (val) => setState(() => gayaArtistik = val!)), _buildDropdown("Warna", temaWarna, listTemaWarna, (val) => setState(() => temaWarna = val!)), _buildDropdown("Lensa", gayaLensa, ["Wide Angle", "Bokeh", "Macro", "Fisheye"], (val) => setState(() => gayaLensa = val!))])),
            const SizedBox(height: 16),
            _buildSectionCard(title: "Langkah 4: Watak", icon: Icons.face_retouching_natural, color: Colors.greenAccent, child: Column(children: [_buildDropdown("Watak Utama", watakUtama, listWatakUtama, (val) => setState(() => watakUtama = val!)), _buildDropdown("Etnik", etnikWatak, ["Melayu", "Cina", "India", "Kadazan", "Iban", "Kaukasia"], (val) => setState(() => etnikWatak = val!)), _buildDropdown("Anime", karakterAnime, ["Tiada", "Shonen", "Shojo", "Seinen", "Chibi", "90s Retro"], (val) => setState(() => karakterAnime = val!)), _buildDropdown("Pakaian", jenisPakaian, listPakaian, (val) => setState(() => jenisPakaian = val!))])),
            const SizedBox(height: 16),
            _buildSectionCard(title: "Langkah 5: Tipografi", icon: Icons.grid_view_outlined, color: Colors.pinkAccent, child: Column(children: [_buildDropdown("Font", gayaFont, listGayaFont, (val) => setState(() => gayaFont = val!)), _buildDropdown("Bahasa", susunanBahasa, ["Formal DBP", "Santai", "Puitis", "Informatif"], (val) => setState(() => susunanBahasa = val!)), _buildDropdown("Layout", modeSusunan, ["Minimalis", "Padat", "Fokus Watak", "Tipografi"], (val) => setState(() => modeSusunan = val!)), _buildDropdown("Viral", posterViral, ["Kontras Tinggi", "Hook Headline", "Trending", "Bold"], (val) => setState(() => posterViral = val!)), _buildDropdown("Sasaran", sasaran, ["Semua Pelajar", "Guru", "Ibu Bapa", "Kanak-kanak", "Awam"], (val) => setState(() => sasaran = val!))])),
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
