import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firestore_service.dart';
import '../services/translation_service.dart';
import '../services/pdf_service.dart';
import '../services/app_state.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppState appState = AppState.instance;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    appState.addListener(_onStateChange);
    _loadFirebaseUserData();
  }

  @override
  void dispose() {
    appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  Future<void> _loadFirebaseUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirestoreService().getUserData(user.uid);
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          appState.updateUserProfile(
            name: data['name']?.toString(),
            email: data['email']?.toString() ?? user.email,
            mobile: data['mobile']?.toString(),
            location: data['location']?.toString(),
            photoUrl: data['photoUrl']?.toString(),
          );
        } else if (user.email != null) {
          appState.updateUserProfile(email: user.email);
        }
      }
    } catch (e) {
      debugPrint("Profile load error: $e");
    }
  }

  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Change Profile Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF1E6F3D)),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                    if (image != null) {
                      appState.updateUserProfile(photoUrl: image.path);
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirestoreService().updateUserProfile(uid: user.uid, data: {'photoUrl': image.path});
                      }
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile photo updated successfully!")),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Photo selection note: $e")),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.face, color: Color(0xFF1E6F3D)),
                title: const Text("Select Farmer Avatar Preset 1"),
                onTap: () {
                  Navigator.pop(context);
                  const newUrl = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80";
                  appState.updateUserProfile(photoUrl: newUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.face_retouching_natural, color: Color(0xFF1E6F3D)),
                title: const Text("Select Farmer Avatar Preset 2"),
                onTap: () {
                  Navigator.pop(context);
                  const newUrl = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80";
                  appState.updateUserProfile(photoUrl: newUrl);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: appState.userName);
    final mobileCtrl = TextEditingController(text: appState.userMobile);
    final emailCtrl = TextEditingController(text: appState.userEmail);
    final locCtrl = TextEditingController(text: appState.userLocation);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Edit Profile Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mobileCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Mobile Number", prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email Address", prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locCtrl,
                decoration: const InputDecoration(labelText: "Location", prefixIcon: Icon(Icons.location_on), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F3D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    final mobile = mobileCtrl.text.trim();
                    final email = emailCtrl.text.trim();
                    final loc = locCtrl.text.trim();

                    appState.updateUserProfile(
                      name: name,
                      mobile: mobile,
                      email: email,
                      location: loc,
                    );

                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirestoreService().updateUserProfile(
                        uid: user.uid,
                        data: {
                          'name': name,
                          'mobile': mobile,
                          'email': email,
                          'location': loc,
                        },
                      );
                    }

                    if (context.mounted) Navigator.pop(context);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile details updated successfully!")),
                      );
                    }
                  },
                  child: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> exportPdfReport() async {
    setState(() {
      loading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      List<Map<String, dynamic>> listings = appState.listings;
      List<Map<String, dynamic>> orders = appState.orders;

      await PdfService().generateAndPrintReport(
        userName: appState.userName,
        userEmail: appState.userEmail,
        activeListings: listings,
        orders: orders,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF generation note: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAF8),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1E6F3D)),
        ),
      );
    }

    final photoUrl = appState.userPhotoUrl;
    final isLocalFile = photoUrl.startsWith('/') || photoUrl.contains('data/user') || photoUrl.contains('Storage');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF1E6F3D)),
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Farmer Avatar Container (Clickable to change photo)
            Center(
              child: GestureDetector(
                onTap: _pickProfileImage,
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1E6F3D), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: isLocalFile
                            ? (kIsWeb
                                ? Image.network(photoUrl, fit: BoxFit.cover)
                                : Image.file(File(photoUrl), fit: BoxFit.cover))
                            : Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50, color: Color(0xFF1E6F3D)),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E6F3D),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              appState.userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              appState.userLocation,
              style: const TextStyle(fontSize: 13, color: Color(0xFF757575), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            // Edit Profile Pill Button
            OutlinedButton.icon(
              icon: const Icon(Icons.edit_outlined, size: 14),
              label: const Text("Edit Profile Info"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1E6F3D),
                side: const BorderSide(color: Color(0xFF1E6F3D)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _showEditProfileDialog,
            ),
            const SizedBox(height: 20),

            // Info Cards
            _ProfileOptionCard(
              icon: Icons.person_outline,
              title: "Full Name",
              subtitle: appState.userName,
              onTap: _showEditProfileDialog,
            ),
            const SizedBox(height: 10),

            _ProfileOptionCard(
              icon: Icons.email_outlined,
              title: "Email Address",
              subtitle: appState.userEmail,
              onTap: _showEditProfileDialog,
            ),
            const SizedBox(height: 10),

            _ProfileOptionCard(
              icon: Icons.phone_outlined,
              title: "Mobile Number",
              subtitle: appState.userMobile,
              onTap: _showEditProfileDialog,
            ),
            const SizedBox(height: 10),

            _ProfileOptionCard(
              icon: Icons.location_on_outlined,
              title: "Location",
              subtitle: appState.userLocation,
              onTap: _showEditProfileDialog,
            ),
            const SizedBox(height: 10),

            _ProfileOptionCard(
              icon: Icons.language_outlined,
              title: TranslationService.translate('change_language'),
              subtitle: TranslationService.currentLanguage == 'en' ? 'English' : 'हिन्दी',
              trailing: const Icon(Icons.swap_horiz, color: Color(0xFF1E6F3D)),
              onTap: () {
                TranslationService.toggleLanguage();
                setState(() {});
              },
            ),
            const SizedBox(height: 10),

            _ProfileOptionCard(
              icon: Icons.picture_as_pdf_outlined,
              title: TranslationService.translate('export_report'),
              subtitle: "Download farm activity summary PDF",
              trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
              onTap: exportPdfReport,
            ),

            const SizedBox(height: 28),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, size: 18),
                label: Text(TranslationService.translate('logout')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  foregroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF1E6F3D), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
        ),
        trailing: trailing ?? const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF9E9E9E)),
      ),
    );
  }
}