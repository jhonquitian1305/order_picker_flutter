import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_picker/presentation/providers/auth_provider.dart';
import 'package:order_picker/presentation/screens/home_screen.dart';
import 'package:order_picker/presentation/screens/register_user_screen.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:order_picker/presentation/widgets/rounded_text_field.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key, required this.appTitle});

  final String appTitle;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.sizeOf(context).height * 0.15 , 16, 0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  "Welcome to Order Picker",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              textController: emailController,
              labelText: "Email",
              hintText: "Enter your email.",
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              textController: passwordController,
              obscureText: true,
              labelText: "Password",
              hintText: "Enter your password.",
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Button(
                    child: const Text("Log In"),
                    onPressed: () => handleLogin(ref),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    type: ButtonType.secondary,
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const RegisterUserScreen())),
                    child: const Text("Register"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  handleLogin(WidgetRef ref) async {
    BuildContext context = ref.context;
    bool logged = await ref
        .read(authProvider.notifier)
        .login(emailController.text, passwordController.text);
    if (context.mounted) {
      logged
          ? Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    title: appTitle,
                  )))
          : loginErrorDialog(context);
    }
  }

  loginErrorDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: const Text(
          'El usuario o contraseña son incorrectos',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
