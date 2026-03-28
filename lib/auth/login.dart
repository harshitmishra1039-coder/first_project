import 'package:flutter/material.dart';
import '../home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE), // Cream background
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo from the photo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 64, 136, 67),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.spoke_outlined, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 30),
              const Text(
                'Farmer Buy/Sell\nCrop Prediction App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 50),
              
              // Custom Login Inputs
              _buildInput("Username"),
              const SizedBox(height: 15),
              _buildInput("Password", isObscure: true),
              const SizedBox(height: 30),

              // "Get Started" styled button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D643E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, {bool isObscure = false}) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}// import 'package:flutter/material.dart';
// import '../../home.dart'; // Verify this path: use '../home.dart' if it's just one folder up

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _usernameController = TextEditingConimport 'package:flutter/material.dart';

//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.lock_person_rounded, size: 80, color: Color(0xFF3B62FF)),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Welcome',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
//                 ),
//                 const SizedBox(height: 40),
                
//                 TextField(
//                   controller: _usernameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Username',
//                     prefixIcon: Icon(Icons.person_outline),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
                
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock_outline),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
                
//                 // --- THE FIXED LOGIN BUTTON ---
//                 SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       final name = _usernameController.text.trim();
//                       final pass = _passwordController.text.trim();

//                       print("Attempting login for: $name");

//                       if (name.isNotEmpty && pass.isNotEmpty) {
//                         // This command replaces the Login page with Home page
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const HomePage()),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Please fill in both fields')),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF3B62FF),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
                
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     "Don't have an account? Sign Up",
//                     style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF3B62FF)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }// import 'package:flutter/material.dart';
// import '../../home.dart'; // Ensure this points to your home.dart file

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var sizedBox =SizedBox(
//   width: double.infinity,
//   height: 54,
//   child: ElevatedButton(
//     onPressed: () {
//       // 1. Capture the input
//       String username = _usernameController.text.trim();
//       String password = _passwordController.text.trim();

//       // 2. Validate: Are the fields filled?
//       if (username.isNotEmpty && password.isNotEmpty) {
//         print("Login Successful for: $username");

//         // 3. THE NAVIGATION COMMAND
//         // This is what actually opens the Home Page
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const HomePage(),
//           ),
//         );
//       } else {
//         // 4. Show error if user left fields blank
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please enter both Username and Password'),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//       }
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: const Color(0xFF3B62FF),
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     ),
//     child: const Text(
//       'Login',
//       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     ),
//   ),
//                 );
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.lock_person_rounded, size: 80, color: Color(0xFF3B62FF)),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Welcome',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
//                 ),
//                 const SizedBox(height: 40),
                
//                 // Username Input
//                 TextField(
//                   controller: _usernameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Username',
//                     prefixIcon: Icon(Icons.person_outline),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
                
//                 // Password Input
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock_outline),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
                
//                 // --- THE LOGIN BUTTON ---
//                 // ... inside your Column children ...

// SizedBox(
//   width: double.infinity,
//   height: 54,
//   child: ElevatedButton(
//     onPressed: () {
//       // 1. This is what you see in the console
//       print("Login Clicked: ${_usernameController.text}");

//       // 2. CHECK: Only navigate if the user typed something
//       if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
        
//         // 3. THE COMMAND THAT OPENS HOME PAGE
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
        
//       } else {
//         // Show an error if they didn't fill the fields
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please fill in both fields')),
//         );
//       }
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: const Color(0xFF3B62FF),
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     ),
//     child: const Text(
//       'Login',
//       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     ),
//   ),
// ),

                
//                 // Sign Up Link
//                 TextButton(
//                   onPressed: () {
//                     // Navigate to Register if you have it
//                   },
//                   child: const Text(
//                     "Don't have an account? Sign Up",
//                     style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF3B62FF)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }// // import 'package:flutter/material.dart';
// import '../../home.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginPageState createState() {
//     return _LoginPageState();
//   }
// }

// class _LoginPageState extends State<LoginPage> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var textButton3 = TextButton(
//                   // Inside 
//                   //your login.dart file
//   // ... inside your ElevatedButton ...
// onPressed: () {
//   // 1. Capture the input for debugging
//   print("Attempting login for: ${_usernameController.text}");

//   // 2. Navigation Logic
//   // We use pushReplacement so the user can't "Go Back" to the login screen
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(builder: (context) => const HomePage()),
//   );
// },
//                   child: const Text(
//                     "Don't have an account? Sign Up",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF3B62FF),
//                     ),
//                   ),
//                 );
//     var textButton2 = textButton3;
//     var textButton = textButton2;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           // Constrains the width so it looks good on wide web screens
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Placeholder for your Logo
//                 const Icon(Icons.lock_person_rounded, size: 80, color: Color(0xFF3B62FF)),
                
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Welcome',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 32,
//                     color: Color(0xFF1C1C1C),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Sign In to continue',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xFF87879D),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
                
//                 TextField(
//                   controller: _usernameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Username',
//                     prefixIcon: Icon(Icons.person_outline),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
                
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock_outline),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 32),
                
//                 SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: ElevatedButton(
//                     onPressed: () {
//   // 1. Validate inputs (Optional but recommended)
//   if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
    
//     // 2. Perform Navigation
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const HomePage(), // Ensure HomePage is imported
//       ),
//     );
    
//   } else {
//     // Show a quick error if fields are empty
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please enter username and password')),
//     );
//   }
// },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF3B62FF),
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: const Text(
//                       'Login',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
                
                
//                 textButton,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// // }