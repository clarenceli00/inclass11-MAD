import 'package:flutter/material.dart';
import 'success_screen.dart';
void main() {
  runApp(const MyApp());
}

// 🧓 Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupScreen> {
  // 🔑 The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();
  
  // 📝 Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List passwordHelp = ["You should add a symbol for a strong password.",
  "Do not share this password with anyone else.", 
  "Contact Support if you don't know your password"];

  int tipIndex = 0;

  bool _obscurePassword = true;
  DateTime? _birthDate;
  final _dateController = TextEditingController();
  // State field
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);  // potion starts brewing

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;  // user may have left the screen

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
            userName: _nameController.text.trim()),
      ),
    );
  }


  String passwordStrengthIndicator(String value){
    var strength = 0;
    if (value.length > 11){
      strength++;
    }
    if (value.contains(RegExp(r'[^a-zA-Z0-9 ]'))){
      strength++;
    }
    switch (strength){
      case 0:
        return 'Weak \n Try adding symbols.';
      case 1:
        return 'Medium';
      case 2:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 👨 Parent
      appBar: AppBar(
        title: const Text('spooky ahh mansion'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form( // 👶 Child
          key: _formKey,
          child: Column(
            children: [
              
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onChanged: (value){
                  setState(() {});
                },
              ),
              Text('Password Strength: ${passwordStrengthIndicator(_passwordController.text)}'),
              const SizedBox(height: 24),

              TextFormField(
                controller: _dateController,
                readOnly: true,  // taps open the picker, not the keyboard
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (_) => _birthDate == null
                    ? 'Pick your birth date' : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2008),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),  // no future birthdays!
                  );
                  if (picked != null) {
                    setState(() {
                      _birthDate = picked;
                      _dateController.text =
                          '${picked.month}/${picked.day}/${picked.year}';
                    });
                  }
                },
              ),
              // 🚀 Sign Up Button
              // The Sign Up button:
              ElevatedButton(
                onPressed: _submitting ? null : _submit,  // null = disabled
                child: _submitting
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Join the Mansion',
                          style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () {
                  final tip = passwordHelp[tipIndex];
                  tipIndex = (tipIndex + 1) % passwordHelp.length;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Local Password Tip: $tip'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Show Password Tip',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}