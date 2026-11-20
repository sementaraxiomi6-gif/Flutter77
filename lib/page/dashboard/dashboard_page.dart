
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_store/bloc/auth/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  final Widget child;

  const DashboardPage({
    super.key,
    required this.child,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController =
      TextEditingController();

  final tabs = [
    '/dashboard/home',
    '/dashboard/order',
    '/dashboard/cart',
    '/dashboard/profile',
  ];

  int currentIndex = 0;

  final List<NavigationDestination> _appBarDestinations = const [
    NavigationDestination(
      selectedIcon: Icon(Icons.home, color: Colors.white),
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.shopping_bag, color: Colors.white),
      icon: Icon(Icons.shopping_bag),
      label: 'My Orders',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.shopping_cart, color: Colors.white),
      icon: Icon(Icons.shopping_cart),
      label: 'Cart',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.person, color: Colors.white),
      icon: Icon(Icons.person),
      label: 'Account',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final location = GoRouterState.of(context).uri.toString();
    final index = tabs.indexWhere(
      (tab) => location.startsWith(tab),
    );

    currentIndex = index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          unauthenticated: () {
            context.go('/login');
          },
        );
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: widget.child,
        extendBody: true,
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: _buildSearchField(),
        ),
        actions: [
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onSubmitted: (query) {
        if (query.isNotEmpty) {
          // Navigasi ke halaman pencarian akan dibuat nanti.
        }
      },
      decoration: InputDecoration(
        hintText: 'Search food...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      tooltip: 'Logout',
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text(
                'Apakah kamu yakin ingin keluar dari akun?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );

        if (confirm == true && mounted) {
          context.read<AuthBloc>().add(
                const AuthEvent.logoutRequested(),
              );
        }
      },
      icon: const Icon(Icons.logout_rounded),
      color: Colors.white,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16.0,
        left: 8.0,
        right: 8.0,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30.0,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: NavigationBar(
          surfaceTintColor: Colors.white,
          labelBehavior:
              NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: currentIndex,
          backgroundColor: Colors.white,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
            context.go(tabs[index]);
          },
          destinations: _appBarDestinations,
        ),
      ),
    );
  }
}
