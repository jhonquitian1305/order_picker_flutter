import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_picker/domain/entities/user.dart';
import 'package:order_picker/main.dart';
import 'package:order_picker/presentation/providers/auth_provider.dart';
import 'package:order_picker/presentation/screens/orders_screen.dart';
import 'package:order_picker/presentation/screens/products_screen.dart';
import 'package:order_picker/presentation/widgets/register_form.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Widget? _selectedWidget;

  void _onItemTapped(Widget widgetTapped) {
    setState(() {
      _selectedWidget = widgetTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? loggedUser = ref.watch(authProvider).loggedUser;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _selectedWidget ??
          Center(
            child: Text(
                "Usuario logueado: id: ${loggedUser?.id}, name: ${loggedUser?.name}, role: ${loggedUser?.role}, jwt: ${loggedUser?.jwt}"),
          ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Orders'),
              onTap: () {
                // Update the state of the app
                _onItemTapped(const OrdersView());
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Products'),
              onTap: () {
                // Update the state of the app
                _onItemTapped(const ProductsView());
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ref.watch(authProvider).loggedUser?.role == Role.admin
                ? ListTile(
                    title: const Text('Register employee'),
                    onTap: () {
                      // Update the state of the app
                      _onItemTapped(RegisterForm(userRole: Role.employee));
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  )
                : const SizedBox.shrink(),
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                ref.read(authProvider.notifier).logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const MyApp(),
                    ),
                    ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
