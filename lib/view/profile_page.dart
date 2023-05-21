import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/shared_preference.dart';
import '../transit/change_page_login.dart';
import 'kesan_dan_pesan.dart';
import 'money_converter_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> listWaktuBagian = <String>['WIB', 'WITA', 'WIT', 'UTC'];
  late String waktuBagian = listWaktuBagian.first;
  late String timeString;
  late Timer timer;
  late String profilImage = '';
  late String nama = 'Masukkan Nama';
  late String nim = 'Masukkan NIM';
  late TextEditingController namaController = TextEditingController(text: nama);
  late TextEditingController nimController = TextEditingController(text: nim);

  @override
  void initState() {
    timeString = _formatDateTime(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        profilImage = value.getString('foto_profil') ?? '';
        nama = value.getString('nama') ?? 'Masukkan Nama';
        nim = value.getString('nim') ?? 'Masukkan NIM';
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future pickImage(ImageSource source) async {
    final image2 = await ImagePicker().pickImage(
        source: source, imageQuality: 50, maxHeight: 600, maxWidth: 900);
    if (image2 == null) return;
    File? img = File(image2.path);
    setState(() {
      profilImage = img.path;
    });
    SharedPreference().setImageProfile(profilImage);
    Navigator.of(context).pop();
  }

  void showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.28,
        maxChildSize: 0.4,
        minChildSize: 0.28,
        expand: false,
        builder: (context, scrollController) {
          return Stack(
            alignment: AlignmentDirectional.topCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -15,
                child: Container(
                  width: 50,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5),
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      child: const Text('Ambil dari galeri'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          profilImage = '';
                        });
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.remove('foto_profil');
                        Navigator.pop(context);
                      },
                      child: const Text('Hapus Foto'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontFamily: 'Koulen', fontSize: 24.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        timeString,
                        style: const TextStyle(
                            fontSize: 25, fontFamily: 'Poppins'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: DropdownButton<String>(
                        underline: Container(),
                        value: waktuBagian,
                        elevation: 16,
                        onChanged: (String? value) {
                          setState(() {
                            waktuBagian = value!;
                          });
                        },
                        items: listWaktuBagian
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontSize: 25, fontFamily: 'Poppins'),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showSelectPhotoOptions(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Image.file(
                            File(profilImage),
                            fit: BoxFit.fill,
                            height: 150,
                            width: 150,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(
                                Icons.person,
                                size: 80,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.teal,
                            ),
                            child: const Icon(
                              Icons.photo,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 40),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nama',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Koulen',
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.only(left: 50, top: 15),
                              height: 200,
                              child: Text(
                                nama,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'NIM',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Koulen',
                            ),
                          ),
                          Text(
                            nim,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Koulen',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 8, 8),
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      title: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Edit Biodata'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Kembali',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  nama = namaController.text;
                                  nim = nimController.text;
                                });
                                SharedPreference().setBiodata(
                                    namaController.text, nimController.text);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                          content: SizedBox(
                            height: 180,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: namaController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    labelStyle:
                                        TextStyle(color: Colors.deepOrange),
                                    labelText: "  Nama",
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: Colors.teal),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: Colors.teal),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? 'Nama cannot be blank'
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: nimController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    labelStyle:
                                        TextStyle(color: Colors.deepOrange),
                                    labelText: "  NIM",
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: Colors.teal),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: Colors.teal),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? 'NIM cannot be blank'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 20),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.fromLTRB(5, 12, 8, 8),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                title: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () async {
                  SharedPreference().setLogout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePageLogin()),
                    (_) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getTime() {
    DateTime waktu;
    if (waktuBagian == 'WITA') {
      waktu = DateTime.now().add(const Duration(hours: 1));
    } else if (waktuBagian == 'WIT') {
      waktu = DateTime.now().add(const Duration(hours: 2));
    } else if (waktuBagian == 'UTC') {
      waktu = DateTime.now().toUtc();
    } else {
      waktu = DateTime.now();
    }

    final String formattedDateTime = _formatDateTime(waktu);
    setState(() {
      timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('kk:mm:ss').format(dateTime);
  }
}
