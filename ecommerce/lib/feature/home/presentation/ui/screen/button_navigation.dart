import 'package:ecommerce/feature/cart/presentation/ui/screen/cart_screen.dart';
import 'package:ecommerce/feature/home/presentation/ui/screen/home_page.dart';
import 'package:ecommerce/feature/home/presentation/ui/screen/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

    List<Widget> _screens() {
      return [
        HomePage(),
        WishlistPage(),
        CartScreen()
      ];
    }

    List<PersistentBottomNavBarItem> _navItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "Home",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite),
          title: "Wishlist",
          activeColorPrimary: Colors.red,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart_outlined),
          title: "Cart",
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens(),
      items: _navItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style3,
    );
  }
}