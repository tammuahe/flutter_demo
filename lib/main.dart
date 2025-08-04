import 'package:flutter/material.dart';
import 'package:flutter_demo/auth_layout.dart';
import 'package:flutter_demo/auth_service.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  final scheme = ColorScheme.fromSeed(seedColor: Color(0xFFFF8383));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      home: AuthLayout(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        iconTheme: IconThemeData(color: scheme.primary),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: scheme.primary),
          iconColor: scheme.primary,
          suffixIconColor: scheme.primary,
        ),
      ),
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LottieBuilder.asset(
            'assets/wave.json',
            fit: BoxFit.cover,
            repeat: true,
            animate: true,
          ),
          SafeArea(child: LoginForm()),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chào mừng bạn trở lại',
                    style: TextTheme.of(context).titleSmall,
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Đăng nhập',
                    style: TextTheme.of(context).displayLarge,
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Icon(Icons.email_rounded),
                    ),
                  ),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !(RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value))) {
                      return "Email không hợp lệ!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    icon: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Icon(Icons.password_rounded),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_passwordVisible,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value))) {
                      return "Mật khẩu không hợp lệ!";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final (user, error) = await authService.value.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (error != null) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(backgroundColor: Theme.of(context).colorScheme.errorContainer,
                            content: Row(
                              children: [
                                Icon(Icons.error,color: Theme.of(context).colorScheme.error,),
                                SizedBox(width: 10,),
                                Text(error, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),),
                              ],
                            )));
                          }
                        }
                      },
                      child: const Text('Đăng nhập'),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: Text(
                        'hoặc',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.google),
                    label: Text('Đăng nhập với Google'),
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
