# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Tugas 7

1. Widget tree adalah struktur pohon hierarki yang menyusun semua komponen UI (widget) di dalam aplikasi Flutter. Hubungan parent-child bekerja dengan cara widget induk (parent) membungkus widget anak (child). Parent meneruskan batasan ukuran (constraints), posisi, dan tema ke bawah (downward) ke child, lalu child menghitung ukuran akhirnya dan melaporkannya kembali ke parent untuk ditampilkan di layar.

2. Daftar widget yang digunakan dalam proyek ini beserta fungsinya:
- MyApp: Root widget utama yang membungkus keseluruhan aplikasi.
- MaterialApp: Mengatur konfigurasi dasar aplikasi bergaya Material Design seperti judul, tema warna (ThemeData), dan halaman awal.
- MyHomePage: Halaman beranda utama aplikasi yang menyusun seluruh bagian portofolio (header, hero section, profil, menu, dan footer).
- Scaffold: Menyediakan kerangka halaman dasar layar (backgroundColor dan tempat munculnya SnackBar).
- Stack dan Positioned / Positioned.fill: Menumpuk elemen secara berlapis, seperti menempatkan lukisan lingkaran sihir (MagicBackgroundPainter) di lapisan belakang dan konten utama di atasnya, serta menata ornamen ikon pada kartu.
- CustomPaint: Merender gambar vektor kustom di atas kanvas menggunakan MagicBackgroundPainter untuk membentuk lingkaran sihir dan simbol dekoratif pada latar belakang.
- SafeArea: Memastikan konten aplikasi tidak tertutup oleh area sistem perangkat seperti notch atau status bar.
- SingleChildScrollView: Membuat halaman dapat digulir secara vertikal agar tidak terjadi overflow.
- Center dan ConstrainedBox: Menempatkan konten utama di tengah layar dan membatasi lebar maksimalnya (maxWidth: 1250) agar tetap proporsional di layar lebar.
- Padding: Memberikan jarak ruang kosong di sekeliling widget di dalamnya.
- Column dan Row: Menyusun widget anak secara vertikal (Column) dan horizontal (Row).
- Spacer: Mengisi ruang kosong fleksibel di antara widget di dalam Row (seperti memisahkan logo MyPortfolio dan teks GRIMOIRE ARCHIVE di header).
- Expanded dan Flexible: Mengatur pembagian ruang secara proporsional serta mencegah teks meluap (overflow) di dalam Row atau Column.
- SizedBox: Memberikan jarak spasi kosong antar elemen atau mengatur dimensi tetap pada kartu.
- Container: Pembungkus serbaguna untuk mengatur ukuran, padding, warna latar, gradien, border, sudut membulat, dan bayangan.
- LayoutBuilder: Mendeteksi lebar layar yang tersedia untuk menyesuaikan tata letak secara responsif (seperti menyembunyikan ilustrasi kanan pada hero section dan mengatur jumlah kolom kartu menu).
- Wrap: Menyusun kumpulan kartu secara fleksibel dan otomatis membungkusnya ke baris baru ketika lebar layar menyempit.
- Text: Menampilkan teks judul, subjudul, informasi profil, deskripsi tombol, dan pesan notifikasi.
- Icon: Menampilkan ikon grafis dari Material Icons.
- InfoCard: Custom widget berbentuk kartu bergaya kertas kuno (parchment) dengan gradien dan border emas untuk menampilkan NPM, Name, dan Class.
- ItemCard: Custom widget berbentuk kartu tombol aksi interaktif (Lihat Proyek, Tambah Proyek, Logout) dengan gradien warna berbeda.
- Material, InkWell, dan Ink: Material menyediakan kanvas transparan, Ink merender dekorasi gradien pada permukaan sentuh, dan InkWell mendeteksi ketukan pengguna (onTap) beserta efek riaknya.
- SnackBar (via ScaffoldMessenger): Menampilkan pesan notifikasi melayang di bagian bawah layar saat tombol ditekan.

3. MaterialApp berfungsi membungkus fitur-fitur inti untuk membangun aplikasi berstandar Material Design, seperti pengaturan tema global (ThemeData), navigasi antar halaman (Navigator), judul aplikasi, dan konteks dasar bagi komponen Material seperti Scaffold maupun SnackBar. Widget ini dijadikan root widget karena hampir seluruh widget di bawahnya membutuhkan konfigurasi tema, arah teks, dan sistem navigasi yang disediakan oleh MaterialApp agar tidak terjadi error.

4. StatelessWidget adalah widget yang bersifat statis (immutable) dan tampilannya tidak berubah setelah dibuat karena tidak menyimpan state internal yang dinamis. Widget ini digunakan ketika tampilan hanya menampilkan data tetap tanpa perlu merender ulang dirinya sendiri (seperti MyHomePage, InfoCard, dan ItemCard). Sebaliknya, StatefulWidget bersifat dinamis (mutable) karena memiliki objek State yang bisa berubah selama aplikasi berjalan dan dapat memperbarui tampilan melalui fungsi setState(). Widget ini digunakan ketika UI harus merespons perubahan data atau interaksi pengguna seperti input form, counter, checkbox, atau data dari API.

5. BuildContext adalah objek yang merepresentasikan lokasi spesifik sebuah widget di dalam widget tree. BuildContext penting karena menjadi penghubung bagi sebuah widget untuk mengakses informasi atau layanan dari widget induk/leluhur (ancestor) di atasnya tanpa harus mengoper parameter secara manual. Di dalam metode build(BuildContext context), parameter context dipakai untuk memanggil metode seperti ScaffoldMessenger.of(context) guna mencari Scaffold terdekat untuk menampilkan SnackBar, atau MediaQuery.of(context) untuk membaca ukuran layar perangkat.

6. Hot reload adalah fitur yang menyuntikkan perubahan kode ke dalam Dart VM dan membangun ulang widget tree secara cepat tanpa menghapus state aplikasi yang sedang berjalan. Sedangkan hot restart memuat ulang seluruh kode dari awal (menjalankan ulang fungsi main()) sehingga semua state aplikasi ter-reset ke kondisi awal. Kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart saat mengubah kode di luar metode build(), seperti inisialisasi variabel global/statis, fungsi main(), initState(), atau konstruktor kelas utama. Sementara itu, full restart wajib dilakukan saat menambah paket baru di pubspec.yaml, mendaftarkan aset baru, atau mengubah konfigurasi native (folder android, ios, atau web).