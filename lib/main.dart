import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ProfileApp());
}

// ---- Brand palette --------------------------------------------------------
const Color kBg = Color(0xFF0B0B10);
const Color kCard = Color(0xFF16161F);
const Color kCard2 = Color(0xFF1C1C29);
const Color kText = Color(0xFFF4F4F7);
const Color kSub = Color(0xFF8E8EA0);
const List<Color> kBrand = [Color(0xFFFF2D78), Color(0xFF9B5CFF)]; // pink → purple

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBg,
        colorScheme: const ColorScheme.dark(
          surface: kBg,
          primary: Color(0xFFFF2D78),
        ),
        fontFamily: 'Roboto',
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: kBg,
      ),
      child: Scaffold(
        body: _FadeInUp(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _Header(),
                SizedBox(height: 18),
                _Identity(),
                SizedBox(height: 20),
                _ActionButtons(),
                SizedBox(height: 22),
                _StatsCard(),
                SizedBox(height: 26),
                _Section(title: 'About Me', child: _AboutCard()),
                SizedBox(height: 22),
                _Section(title: 'Profile Details', child: _DetailsList()),
                SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Header: gradient banner + top bar + overlapping avatar ---------------
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 234,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Gradient banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 172,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: kBrand,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
              ),
              // Soft highlight for depth
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(34),
                    bottomRight: Radius.circular(34),
                  ),
                  gradient: RadialGradient(
                    center: const Alignment(-0.7, -0.9),
                    radius: 1.2,
                    colors: [
                      Colors.white.withValues(alpha: 0.18),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _GlassIconButton(
                      icon: Icons.settings_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Avatar (overlaps banner)
          const Positioned(
            top: 118,
            left: 0,
            right: 0,
            child: Center(child: _Avatar()),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      height: 116,
      child: Stack(
        children: [
          // Gradient ring
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: kBrand),
              boxShadow: [
                BoxShadow(
                  color: kBrand.first.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kBg,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kCard2,
                ),
                alignment: Alignment.center,
                child: ShaderMask(
                  shaderCallback: (rect) =>
                      const LinearGradient(colors: kBrand).createShader(rect),
                  child: const Text(
                    'GH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Online badge
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF22D37A),
                shape: BoxShape.circle,
                border: Border.all(color: kBg, width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Identity: name, role, location pill ----------------------------------
class _Identity extends StatelessWidget {
  const _Identity();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Guljar Hosen',
              style: TextStyle(
                color: kText,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.verified, color: Color(0xFF3B9DFF), size: 22),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Product · UX Designer',
          style: TextStyle(color: kSub, fontSize: 14.5),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.location_on_outlined, size: 16, color: kSub),
              SizedBox(width: 5),
              Text(
                'Dhaka, Bangladesh',
                style: TextStyle(color: kSub, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---- Action buttons -------------------------------------------------------
class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Primary gradient button
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: kBrand),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: kBrand.first.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_outlined,
                            color: Colors.white, size: 19),
                        SizedBox(width: 8),
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Secondary outlined button
          Expanded(
            child: Material(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.10)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_outlined, color: kText, size: 19),
                      SizedBox(width: 8),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: kText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Stats card -----------------------------------------------------------
class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: const [
          Expanded(child: _Stat(value: '52', label: 'Projects')),
          _StatDivider(),
          Expanded(child: _Stat(value: '9.2K', label: 'Followers', accent: true)),
          _StatDivider(),
          Expanded(child: _Stat(value: '4 Yrs', label: 'Experience')),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final bool accent;
  const _Stat({required this.value, required this.label, this.accent = false});

  @override
  Widget build(BuildContext context) {
    final valueWidget = Text(
      value,
      style: const TextStyle(
        color: kText,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    );
    return Column(
      children: [
        if (accent)
          ShaderMask(
            shaderCallback: (rect) =>
                const LinearGradient(colors: kBrand).createShader(rect),
            child: valueWidget,
          )
        else
          valueWidget,
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: kSub, fontSize: 12.5)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}

// ---- Section wrapper ------------------------------------------------------
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
          child: Text(
            title,
            style: const TextStyle(
              color: kText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: const Text(
        'UX designer & Flutter developer passionate about crafting clean, '
        'human-centered interfaces. I turn complex problems into intuitive, '
        'delightful experiences — one pixel at a time.',
        style: TextStyle(color: kSub, fontSize: 14.5, height: 1.55),
      ),
    );
  }
}

// ---- Detail tiles ---------------------------------------------------------
class _DetailsList extends StatelessWidget {
  const _DetailsList();

  @override
  Widget build(BuildContext context) {
    const items = [
      _Detail(
        icon: Icons.email_outlined,
        color: Color(0xFFFF2D78),
        label: 'Email',
        value: 'guljar.hosen.ux@gmail.com',
      ),
      _Detail(
        icon: Icons.work_outline_rounded,
        color: Color(0xFFFFB020),
        label: 'Role',
        value: 'Product / UX Designer',
      ),
      _Detail(
        icon: Icons.location_on_outlined,
        color: Color(0xFF22D3A6),
        label: 'Location',
        value: 'Dhaka, Bangladesh',
      ),
      _Detail(
        icon: Icons.code_rounded,
        color: Color(0xFF9B5CFF),
        label: 'GitHub',
        value: 'github.com/GuljarGlimpse',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (final item in items) ...[
            item,
            if (item != items.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _Detail({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(color: kSub, fontSize: 12.5)),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        color: kText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: kSub.withValues(alpha: 0.6), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Entrance animation ---------------------------------------------------
class _FadeInUp extends StatelessWidget {
  final Widget child;
  const _FadeInUp({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 24),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
