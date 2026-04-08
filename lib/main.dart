import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const PromptApp());

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
      home: const PromptGenerator(),
    );
  }
}

class PromptGenerator extends StatefulWidget {
  const PromptGenerator({super.key});

  @override
  State<PromptGenerator> createState() => _PromptGeneratorState();
}

class _PromptGeneratorState extends State<PromptGenerator> {
  // Maklumat Teks
  String tajuk = "";
  String tarikh = "";
  String masa = "";
  String tempat = "";
  String maklumatTambahan = "";

  // Konfigurasi Visual & Gaya
  String kategori = "Poster";
  String sasaran = "Semua Pelajar";
  String watakUtama = "Pelajar Sekolah Menengah";
  String etnikWatak = "Melayu";
  String karakterAnime = "Tiada / Bukan Anime";
  String gayaDesign = "Sci-Fi Futuristik";
  String gayaArtistik = "Soft Studio Light";
  String gayaLensa = "Wide Angle (4k)";
  String jenisImej = "Foto Realistik";
  
  // Susunan & Tipografi
  String susunanBahasa = "Formal DBP";
  String modeSusunan = "Minimalis Modern";
  String gayaFont = "Modern Sans Serif";
  String posterViral = "Warna Kontras Tinggi";
  String temaWarna = "Vibrant / Bold";

  // Fungsi untuk menjana prompt akhir
  String generateFinalPrompt() {
    String orientation = "Potret Sosial Media (4:5)";
    String formatRules = "";

    if (kategori == "Banner") {
      orientation = "Landskap Lebar (16:9)";
      formatRules = "- Fokus kepada ruang kosong di tengah untuk teks banner yang besar.\n- Elemen grafik diletakkan di sisi kiri dan kanan.";
    } else if (kategori == "Komik") {
      orientation = "Panel Komik (Layout Grid)";
      formatRules = "- Hasilkan dalam bentuk panel-panel komik (3-4 panel).\n- Sertakan kotak dialog (speech bubbles) jika perlu.\n- Gaya penceritaan visual yang dinamik.";
    } else if (kategori == "Infografik") {
      orientation = "Potret Panjang (9:16)";
      formatRules = "- Susunan maklumat mengikut aliran dari atas ke bawah.\n- Gunakan ikon dan ilustrasi kecil untuk menyokong fakta.";
    }

    return """
IMPORTANT SYSTEM RULES (MUST FOLLOW):
- Output language: Bahasa Melayu standard (Ejaan DBP).
- Paparan visual mesti disesuaikan dengan Tema: $tajuk.
- TIADA perkataan Inggeris atau Indonesia.
- Orientasi: $orientation.
- RUJUKAN IMEJ (jika ada): Gunakan imej yang dimuat naik 100% sebagai rujukan utama.
- KETEPATAN MUKA: Kekalkan persamaan muka, struktur muka, bentuk mata, hidung, dan bibir mengikut imej asal.
- EKSPRESI: Pastikan watak mempunyai ekspresi senyuman lembut (soft smile).

VISUAL & LAYOUT:
- Jenis Imej: $jenisImej
- Format/Versi: $kategori
$formatRules
- Tajuk: ${tajuk.isEmpty ? "[Tajuk]" : tajuk}
- Tarikh: ${tarikh.isEmpty ? "[Tarikh]" : tarikh}
- Masa: ${masa.isEmpty ? "[Masa]" : masa}
- Tempat: ${tempat.isEmpty ? "[Tempat]" : tempat}
- Sasaran: $sasaran
- Maklumat Tambahan: ${maklumatTambahan.isEmpty ? "Tiada" : maklumatTambahan}

CHARACTER DETAILS:
- Watak Utama: $watakUtama
- Etnik: $etnikWatak
- Karakter/Gaya Anime: $karakterAnime
- Pakaian: Memakai seragam sekolah Malaysia yang kemas.

ARTISTIC DETAILS:
- Gaya Design: $gayaDesign
- Pencahayaan (Artistik): $gayaArtistik
- Lensa: $gayaLensa
- Tema Warna: $temaWarna
- Mode Susunan: $modeSusunan
- Gaya Font: $gayaFont
- Elemen Viral: $posterViral
- Nada Bahasa: $susunanBahasa

Sila hasilkan visual yang kemas, profesional dan sesuai untuk tujuan pendidikan. Pastikan maklumat teks dipaparkan dengan jelas pada visual mengikut maklumat di atas.
""";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121F),
      appBar: AppBar(
        title: const Text("Prompt Builder Pro", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF12121F), Colors.indigo.withOpacity(0.1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: "Maklumat Kandungan",
                icon: Icons.edit_document,
                color: Colors.blueAccent,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Tajuk Program / Cerita",
                        prefixIcon: Icon(Icons.title, color: Colors.blueAccent),
                      ),
                      onChanged: (val) => setState(() => tajuk = val),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: "Tarikh",
                              prefixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent),
                            ),
                            onChanged: (val) => setState(() => tarikh = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: "Masa",
                              prefixIcon: Icon(Icons.schedule, color: Colors.blueAccent),
                            ),
                            onChanged: (val) => setState(() => masa = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Tempat",
                        prefixIcon: Icon(Icons.location_on, color: Colors.blueAccent),
                      ),
                      onChanged: (val) => setState(() => tempat = val),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Maklumat Tambahan",
                        hintText: "Contoh: Plot cerita (untuk komik) atau nota kaki...",
                        prefixIcon: Icon(Icons.info_outline, color: Colors.blueAccent),
                      ),
                      onChanged: (val) => setState(() => maklumatTambahan = val),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              _buildSectionCard(
                title: "Format & Gaya Visual",
                icon: Icons.aspect_ratio,
                color: Colors.orangeAccent,
                child: Column(
                  children: [
                    _buildDropdown("Versi Output", kategori, [
                      "Poster", "Banner", "Komik", "Infografik"
                    ], (val) => setState(() => kategori = val!)),
                    
                    _buildDropdown("Jenis Imej", jenisImej, [
                      "Foto Realistik", "Ilustrasi Digital", "Lukisan Minyak", "Lakaran Pensil", "3D Render", "Vektor"
                    ], (val) => setState(() => jenisImej = val!)),

                    _buildDropdown("Gaya Design", gayaDesign, [
                      "Gaya Epik", "Komedi & Humor", "Aksi & Pengembaraan", "Sci-Fi Futuristik",
                      "Dokumentari & Fakta", "Romantik", "Filem Realistik", "Poster Aksi",
                      "Poster 3D", "Cute 3D Pixar", "Kartun"
                    ], (val) => setState(() => gayaDesign = val!)),

                    _buildDropdown("Gaya Artistik / Pencahayaan", gayaArtistik, [
                      "Soft Studio Light", "Golden Hour (Senja)", "Neon Glow (Cyberpunk)", 
                      "Kesan Kabus / Habuk", "Cahaya Tajam (Rim Lighting)", "Cinematic Shadow"
                    ], (val) => setState(() => gayaArtistik = val!)),

                    _buildDropdown("Tema Warna", temaWarna, [
                      "Vibrant / Bold", "Pastel Lembut", "Monokrom", "Earth Tones", "Luxury Gold & Black"
                    ], (val) => setState(() => temaWarna = val!)),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionCard(
                title: "Pilihan Watak & Etnik",
                icon: Icons.person_add,
                color: Colors.greenAccent,
                child: Column(
                  children: [
                    _buildDropdown("Watak Utama", watakUtama, [
                      "Pelajar Sekolah Menengah", "Guru", "Pekerja Pejabat", "Kanak-kanak", "Saintis", "Tiada Watak"
                    ], (val) => setState(() => watakUtama = val!)),

                    _buildDropdown("Etnik Watak", etnikWatak, [
                      "Melayu", "Cina", "India", "Kadazan-Dusun", "Iban", "Pan-Asian", "Kaukasia"
                    ], (val) => setState(() => etnikWatak = val!)),

                    _buildDropdown("Karakter / Gaya Anime", karakterAnime, [
                      "Tiada / Bukan Anime", "Shonen (Action)", "Shojo (Elegant)", "Seinen (Realistic)", "Chibi (Cute)", "90s Retro Anime"
                    ], (val) => setState(() => karakterAnime = val!)),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionCard(
                title: "Susunan & Tipografi",
                icon: Icons.format_paint,
                color: Colors.pinkAccent,
                child: Column(
                  children: [
                    _buildDropdown("Gaya Font", gayaFont, [
                      "Modern Sans Serif", "Elegant Serif", "Bold Display", "Handwritten", "Calligraphy", "Cyberpunk Font", "Chalkboard Style"
                    ], (val) => setState(() => gayaFont = val!)),

                    _buildDropdown("Susunan Bahasa", susunanBahasa, [
                      "Formal DBP", "Santai / Viral", "Puitis / Inspirasi", "Informatif / Padat"
                    ], (val) => setState(() => susunanBahasa = val!)),

                    _buildDropdown("Mode Susunan (Layout)", modeSusunan, [
                      "Minimalis Modern", "Padat Maklumat", "Fokus Watak", "Fokus Teks / Tipografi"
                    ], (val) => setState(() => modeSusunan = val!)),

                    _buildDropdown("Elemen Viral", posterViral, [
                      "Warna Kontras Tinggi", "Headline 'Hook' Menarik", "Elemen Trending", "Tipografi Bold"
                    ], (val) => setState(() => posterViral = val!)),

                    _buildDropdown("Sasaran", sasaran, [
                      "Semua Pelajar", "Guru & Staf", "Ibu Bapa", "Kanak-kanak", "Orang Awam"
                    ], (val) => setState(() => sasaran = val!)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  "Pratonton Prompt:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A2A3D), Color(0xFF1E1E2C)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigoAccent.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SelectableText(
                  generateFinalPrompt(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.4),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.indigoAccent, Colors.deepPurpleAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigoAccent.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: generateFinalPrompt()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text("Prompt berjaya disalin ke Clipboard!"),
                          ],
                        ),
                        backgroundColor: Colors.green.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_all_rounded, size: 28),
                  label: const Text("Jana & Salin Prompt", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Color color, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.indigoAccent),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items.map((String val) {
              return DropdownMenuItem<String>(value: val, child: Text(val));
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
