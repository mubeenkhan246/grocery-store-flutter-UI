import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass.dart';
import '../data/grocery_data.dart';

class GroceryShell extends ConsumerWidget {
  const GroceryShell({required this.child, super.key});

  final Widget child;

  static const tabs = [
    ('/', Icons.home_rounded, 'Home'),
    ('/categories', Icons.grid_view_rounded, 'Categories'),
    ('/search', Icons.search_rounded, 'Search'),
    ('/wishlist', Icons.favorite_rounded, 'Wishlist'),
    ('/profile', Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTabProvider);
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: GlassPanel(
          radius: 34,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < tabs.length; i++)
                _NavItem(
                  icon: tabs[i].$2,
                  label: tabs[i].$3,
                  active: selected == i,
                  onTap: () {
                    ref.read(selectedTabProvider.notifier).state = i;
                    context.go(tabs[i].$1);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          height: 52,
          decoration: BoxDecoration(
            color: active ? AppTheme.green.withValues(alpha: .92) : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: active ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: .58)),
              AnimatedSize(
                duration: const Duration(milliseconds: 240),
                child: active
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..forward();
    _redirectTimer = Timer(const Duration(milliseconds: 1900), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: Center(
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            child: ScaleTransition(
              scale: Tween<double>(begin: .82, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut)),
              child: GlassPanel(
                radius: 36,
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🥬', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 16),
                    Text('Lumi Grocery', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('Fresh food, delivered beautifully', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int page = 0;
  final slides = const [
    ('Curated harvests', 'Shop produce selected each morning from premium farms.', '🥗'),
    ('Cold-chain delivery', 'Track delicate dairy, frozen picks, and bakery orders live.', '🛵'),
    ('A calmer cart', 'Personal recommendations, smart deals, and instant checkout.', '🛒'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => context.go('/'), child: const Text('Skip'))),
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: slides.length,
                    onPageChanged: (value) => setState(() => page = value),
                    itemBuilder: (context, index) => TweenAnimationBuilder<double>(
                      tween: Tween(begin: .92, end: 1),
                      duration: const Duration(milliseconds: 480),
                      curve: Curves.easeOutCubic,
                      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                      child: GlassPanel(
                        radius: 36,
                        padding: const EdgeInsets.all(26),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(slides[index].$3, style: const TextStyle(fontSize: 124)),
                            const SizedBox(height: 32),
                            Text(slides[index].$1, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall),
                            const SizedBox(height: 16),
                            Text(slides[index].$2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < slides.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: page == i ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(color: page == i ? AppTheme.green : Colors.grey.withValues(alpha: .4), borderRadius: BorderRadius.circular(8)),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryGlassButton(
                  label: page == slides.length - 1 ? 'Start shopping' : 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  onTap: () => page == slides.length - 1 ? context.go('/') : controller.nextPage(duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/cart'),
        icon: const Icon(Icons.shopping_bag_rounded),
        label: const Text('Cart'),
        backgroundColor: AppTheme.green,
        foregroundColor: Colors.white,
      ),
      body: LiquidBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good morning, Ava', style: Theme.of(context).textTheme.titleMedium),
                  Text('32 Market Street • 18 min', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              actions: [GlassIconButton(icon: Icons.notifications_rounded, label: 'Notifications', onTap: () => context.push('/notifications')), const SizedBox(width: 12)],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
              sliver: SliverList.list(
                children: [
                  SearchGlassField(onTap: () => context.go('/search')),
                  const SizedBox(height: 18),
                  const _HeroBanner(),
                  const SizedBox(height: 24),
                  SectionHeader('Categories', action: 'View all', onAction: () => context.go('/categories')),
                  SizedBox(
                    height: 112,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => CategoryPill(category: categories[index]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionHeader('Popular products', action: 'Deals', onAction: () => context.push('/listing/Flash Deals')),
                  ProductCarousel(products: products.take(4).toList()),
                  const SizedBox(height: 24),
                  const _FlashDealStrip(),
                  const SizedBox(height: 24),
                  SectionHeader('Recommended for you'),
                  ProductGrid(products: products),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 36,
      padding: const EdgeInsets.all(22),
      child: SizedBox(
        height: 188,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chef-grade produce', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  Text('Up to 30% off organic fruit boxes today.', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  SizedBox(child: FilledButton(onPressed: () => context.push('/listing/Fruits'), child: const Text('Shop now'))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Text('🍓', style: TextStyle(fontSize: 86)),
          ],
        ),
      ),
    );
  }
}

class _FlashDealStrip extends StatelessWidget {
  const _FlashDealStrip();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 32,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: AppTheme.tomato.withValues(alpha: .16), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.bolt_rounded, color: AppTheme.tomato),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text('Flash deals refresh in 12:08 with premium pantry bundles.', style: Theme.of(context).textTheme.titleMedium)),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    return GroceryPage(
      title: 'Categories',
      trailing: GlassIconButton(icon: Icons.tune_rounded, label: 'Filter'),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .94, crossAxisSpacing: 14, mainAxisSpacing: 14),
        itemCount: categories.length,
        itemBuilder: (context, index) => GlassPanel(
          onTap: () => context.push('/listing/${categories[index].name}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundColor: categories[index].color.withValues(alpha: .18), child: Icon(categories[index].icon, color: categories[index].color)),
              const Spacer(),
              Text(categories[index].name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${18 + index * 4} curated items', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductListingScreen extends ConsumerWidget {
  const ProductListingScreen({required this.category, super.key});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final filtered = products.where((p) => p.category == category).toList();
    final visible = filtered.isEmpty ? products : filtered;
    return GroceryPage(
      title: category,
      showBack: true,
      trailing: GlassIconButton(icon: Icons.tune_rounded, label: 'Filter'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Row(children: [SearchGlassField(compact: true), const SizedBox(width: 10), GlassIconButton(icon: Icons.sort_rounded, label: 'Sort')]),
          const SizedBox(height: 14),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: const ['Best match', 'Organic', 'Under \$5', '4.8+', 'Flash'].length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) => Chip(label: Text(const ['Best match', 'Organic', 'Under \$5', '4.8+', 'Flash'][index])),
            ),
          ),
          const SizedBox(height: 18),
          ProductGrid(products: visible, shrinkWrap: true),
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productsProvider).firstWhere((item) => item.id == productId, orElse: () => ref.watch(productsProvider).first);
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 28),
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: GlassPanel(
                      radius: 36,
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(color: product.color.withValues(alpha: .44), borderRadius: BorderRadius.circular(30)),
                        child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 142))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlassPanel(
                    radius: 34,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(product.name, style: Theme.of(context).textTheme.headlineMedium)),
                            Text('\$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.green)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('${product.badge} • ${product.rating} rating • arrives in 18 min', style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 18),
                        Wrap(spacing: 8, runSpacing: 8, children: [for (final item in product.nutrition) Chip(label: Text(item))]),
                        const SizedBox(height: 18),
                        Text('Reviews', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text('“Unusually fresh, perfectly packed, and still cool at the door.”', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const QuantitySelector(),
                      const SizedBox(width: 12),
                      Expanded(child: PrimaryGlassButton(label: 'Add to Cart', icon: Icons.add_shopping_cart_rounded, onTap: () => context.push('/cart'))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryGlassButton(label: 'Buy Now', icon: Icons.flash_on_rounded, onTap: () => context.push('/checkout')),
                ],
              ),
              Positioned(top: 10, left: 16, child: GlassIconButton(icon: Icons.arrow_back_rounded, label: 'Back', onTap: () => context.pop())),
              Positioned(top: 10, right: 74, child: GlassIconButton(icon: Icons.ios_share_rounded, label: 'Share')),
              Positioned(top: 10, right: 16, child: GlassIconButton(icon: Icons.favorite_border_rounded, label: 'Wishlist')),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider).where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    return GroceryPage(
      title: 'Search',
      trailing: GlassIconButton(icon: Icons.mic_rounded, label: 'Voice search'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          SearchGlassField(autofocus: true, onChanged: (value) => setState(() => query = value)),
          const SizedBox(height: 22),
          SectionHeader(query.isEmpty ? 'Recent searches' : 'Live results'),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final item in ['berries', 'oat milk', 'bakery', 'organic greens']) Chip(label: Text(item))]),
          const SizedBox(height: 22),
          SectionHeader('Trending products'),
          ProductGrid(products: products.isEmpty ? ref.watch(productsProvider).take(4).toList() : products, shrinkWrap: true),
          const SizedBox(height: 22),
          SectionHeader('Suggested categories'),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final c in ref.watch(categoriesProvider).take(5)) ActionChip(label: Text(c.name), onPressed: () => context.push('/listing/${c.name}'))]),
        ],
      ),
    );
  }
}

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final products = ref.watch(productsProvider).where((p) => cart.containsKey(p.id)).toList();
    final subtotal = products.fold<double>(0, (sum, p) => sum + p.price * (cart[p.id] ?? 1));
    return GroceryPage(
      title: 'Shopping Cart',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          for (final product in products) CartRow(product: product, qty: cart[product.id] ?? 1),
          const SizedBox(height: 12),
          GlassPanel(child: Row(children: [const Icon(Icons.confirmation_number_rounded, color: AppTheme.green), const SizedBox(width: 12), Expanded(child: Text('LUMI20 applied', style: Theme.of(context).textTheme.titleMedium)), const Text('-\$4.20')])),
          const SizedBox(height: 12),
          OrderSummary(subtotal: subtotal, delivery: 2.99),
          const SizedBox(height: 16),
          PrimaryGlassButton(label: 'Checkout', icon: Icons.lock_rounded, onTap: () => context.push('/checkout')),
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GroceryPage(
      title: 'Checkout',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const CheckoutTile(icon: Icons.location_on_rounded, title: 'Delivery address', subtitle: '32 Market Street, Apt 8B'),
          const CheckoutTile(icon: Icons.schedule_rounded, title: 'Delivery slot', subtitle: 'Today, 4:30 PM - 5:00 PM'),
          const CheckoutTile(icon: Icons.credit_card_rounded, title: 'Payment method', subtitle: 'Apple Pay •••• 2841'),
          const SizedBox(height: 12),
          const OrderSummary(subtotal: 17.40, delivery: 2.99),
          const SizedBox(height: 16),
          PrimaryGlassButton(label: 'Place Order', icon: Icons.check_circle_rounded, onTap: () => context.push('/tracking')),
        ],
      ),
    );
  }
}

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GroceryPage(
      title: 'Order Tracking',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          GlassPanel(
            radius: 36,
            child: Column(
              children: [
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(colors: [Color(0xFFDDF7E7), Color(0xFFC7E8FF)]),
                  ),
                  child: Stack(children: const [
                    Positioned(top: 36, left: 44, child: Icon(Icons.storefront_rounded, size: 42, color: AppTheme.green)),
                    Positioned(bottom: 42, right: 42, child: Icon(Icons.home_rounded, size: 44, color: Color(0xFF2563EB))),
                    Center(child: Icon(Icons.delivery_dining_rounded, size: 68, color: Color(0xFF111827))),
                  ]),
                ),
                const SizedBox(height: 18),
                Text('Arriving in 14 minutes', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const LinearProgressIndicator(value: .68, minHeight: 8, borderRadius: BorderRadius.all(Radius.circular(8))),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const CheckoutTile(icon: Icons.person_rounded, title: 'Maya Chen', subtitle: 'Your delivery partner • 4.98 rating'),
          const SizedBox(height: 12),
          PrimaryGlassButton(label: 'Call driver', icon: Icons.call_rounded),
        ],
      ),
    );
  }
}

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(wishlistProvider);
    final products = ref.watch(productsProvider).where((p) => ids.contains(p.id)).toList();
    return GroceryPage(
      title: 'Wishlist',
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => CartRow(product: products[index], qty: 1, wishlistMode: true),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.receipt_long_rounded, 'Orders history', '12 completed orders'),
      (Icons.location_on_rounded, 'Saved addresses', 'Home, office, studio'),
      (Icons.credit_card_rounded, 'Payment methods', 'Apple Pay and 2 cards'),
      (Icons.notifications_rounded, 'Notifications', 'Offers and delivery alerts'),
      (Icons.settings_rounded, 'Settings', 'Appearance, privacy, account'),
      (Icons.support_agent_rounded, 'Support center', 'Chat with Lumi care'),
    ];
    return GroceryPage(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          GlassPanel(
            radius: 36,
            child: Row(
              children: [
                const CircleAvatar(radius: 34, backgroundColor: AppTheme.green, child: Text('A', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Ava Sterling', style: Theme.of(context).textTheme.titleLarge), Text('Lumi Black member', style: Theme.of(context).textTheme.bodyMedium)])),
                CupertinoSwitch(value: true, onChanged: (_) {}),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final item in items) Padding(padding: const EdgeInsets.only(bottom: 12), child: CheckoutTile(icon: item.$1, title: item.$2, subtitle: item.$3)),
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = const [
      ('Order update', 'Your bakery bag has been packed and sealed.', Icons.inventory_2_rounded),
      ('Offer', 'Organic berries are 25% off until 6 PM.', Icons.local_offer_rounded),
      ('Promotion', 'Unlock free delivery with Lumi Black this week.', Icons.workspace_premium_rounded),
      ('Delivery alert', 'Maya is approaching your building.', Icons.delivery_dining_rounded),
    ];
    return GroceryPage(
      title: 'Notifications',
      showBack: true,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        itemCount: alerts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => CheckoutTile(icon: alerts[index].$3, title: alerts[index].$1, subtitle: alerts[index].$2),
      ),
    );
  }
}

class GroceryPage extends StatelessWidget {
  const GroceryPage({required this.title, required this.child, this.trailing, this.showBack = false, super.key});

  final String title;
  final Widget child;
  final Widget? trailing;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Row(
                  children: [
                    if (showBack) ...[GlassIconButton(icon: Icons.arrow_back_rounded, label: 'Back', onTap: () => context.pop()), const SizedBox(width: 12)],
                    Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
                    ?trailing,
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchGlassField extends StatelessWidget {
  const SearchGlassField({this.onTap, this.onChanged, this.compact = false, this.autofocus = false, super.key});

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool compact;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return ExpandedOrSelf(
      expanded: compact,
      child: GlassPanel(
        radius: 28,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        onTap: onTap,
        child: TextField(
          enabled: onTap == null,
          autofocus: autofocus,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: const Icon(Icons.search_rounded),
            hintText: 'Search premium groceries',
            suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.mic_rounded)),
          ),
        ),
      ),
    );
  }
}

class ExpandedOrSelf extends StatelessWidget {
  const ExpandedOrSelf({required this.expanded, required this.child, super.key});
  final bool expanded;
  final Widget child;
  @override
  Widget build(BuildContext context) => expanded ? Expanded(child: child) : child;
}

class CategoryPill extends StatelessWidget {
  const CategoryPill({required this.category, super.key});
  final GroceryCategory category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 94,
      child: GlassPanel(
        radius: 28,
        padding: const EdgeInsets.all(12),
        onTap: () => context.push('/listing/${category.name}'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: category.color, size: 28),
            const SizedBox(height: 10),
            Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({required this.products, super.key});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 236,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(width: 176, child: ProductCard(product: products[index])),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({required this.products, this.shrinkWrap = false, super.key});
  final List<Product> products;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .68, crossAxisSpacing: 14, mainAxisSpacing: 14),
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}

class ProductCard extends ConsumerWidget {
  const ProductCard({required this.product, super.key});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liked = ref.watch(wishlistProvider).contains(product.id);
    return GlassPanel(
      radius: 30,
      padding: const EdgeInsets.all(12),
      onTap: () => context.push('/product/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: 'product-${product.id}',
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: product.color.withValues(alpha: .5), borderRadius: BorderRadius.circular(24)),
                child: Stack(
                  children: [
                    Center(child: Text(product.emoji, style: const TextStyle(fontSize: 58))),
                    Positioned(top: 8, right: 8, child: Icon(liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: liked ? AppTheme.tomato : Colors.black54)),
                    Positioned(bottom: 8, left: 8, child: _Badge(product.badge)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.star_rounded, color: AppTheme.citrus, size: 18), Text(product.rating.toString())]),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(width: 6),
              Text('\$${product.oldPrice.toStringAsFixed(2)}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .42))),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          color: Colors.white.withValues(alpha: .55),
          child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.ink)),
        ),
      ),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({super.key});
  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Row(
        children: [
          IconButton(onPressed: () => setState(() => qty = (qty - 1).clamp(1, 99)), icon: const Icon(Icons.remove_rounded)),
          Text('$qty', style: Theme.of(context).textTheme.titleMedium),
          IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add_rounded)),
        ],
      ),
    );
  }
}

class CartRow extends StatelessWidget {
  const CartRow({required this.product, required this.qty, this.wishlistMode = false, super.key});
  final Product product;
  final int qty;
  final bool wishlistMode;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 30,
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(color: product.color.withValues(alpha: .5), borderRadius: BorderRadius.circular(24)),
            child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 36))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.name, style: Theme.of(context).textTheme.titleMedium), Text('\$${product.price.toStringAsFixed(2)} • qty $qty')])),
          GlassIconButton(icon: wishlistMode ? Icons.add_shopping_cart_rounded : Icons.more_horiz_rounded, size: 44, label: wishlistMode ? 'Move to cart' : 'Actions'),
        ],
      ),
    );
  }
}

class CheckoutTile extends StatelessWidget {
  const CheckoutTile({required this.icon, required this.title, required this.subtitle, super.key});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 30,
      child: Row(
        children: [
          CircleAvatar(backgroundColor: AppTheme.green.withValues(alpha: .14), child: Icon(icon, color: AppTheme.green)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), Text(subtitle, style: Theme.of(context).textTheme.bodyMedium)])),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({required this.subtotal, required this.delivery, super.key});
  final double subtotal;
  final double delivery;

  @override
  Widget build(BuildContext context) {
    final total = subtotal + delivery - 4.20;
    return GlassPanel(
      radius: 32,
      child: Column(
        children: [
          SummaryLine(label: 'Subtotal', value: subtotal),
          SummaryLine(label: 'Delivery', value: delivery),
          const SummaryLine(label: 'Coupon', value: -4.20),
          const Divider(height: 24),
          SummaryLine(label: 'Total', value: total, strong: true),
        ],
      ),
    );
  }
}

class SummaryLine extends StatelessWidget {
  const SummaryLine({required this.label, required this.value, this.strong = false, super.key});
  final String label;
  final double value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [Expanded(child: Text(label, style: style)), Text('\$${value.toStringAsFixed(2)}', style: style)]),
    );
  }
}
