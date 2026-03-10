import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rpskindisease/constants/colors.dart';
import 'package:rpskindisease/constants/routes.dart';
import 'package:rpskindisease/constants/shared_preferences.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String displayName =
        user?.displayName?.trim().isNotEmpty == true ? user!.displayName! : 'Pet owner';
    final String email = user?.email ?? 'Not signed in';
    final String? photoUrl = user?.photoURL;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // —— Header title ——
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryBlackColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 28),

              // —— User card ——
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: paleColor1,
                      backgroundImage:
                          photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                      child: photoUrl == null || photoUrl.isEmpty
                          ? Icon(
                              Icons.person_rounded,
                              size: 48,
                              color: primaryGreyColor,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // —— Account section ——
              _sectionLabel('Account'),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: email,
              ),
              const SizedBox(height: 8),
              _ProfileTile(
                icon: Icons.badge_outlined,
                label: 'Display name',
                value: displayName,
              ),
              const SizedBox(height: 32),

              // —— Log out ——
              _sectionLabel('Actions'),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.logout_rounded,
                label: 'Log out',
                value: 'Sign out of this account',
                trailing: Icon(Icons.chevron_right_rounded, color: primaryGreyColor, size: 22),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  SharedPreferencesHelper.clearAll();
                  if (context.mounted) {
                    moveToScreen(context, ScreenRoutes.toSigninScreen);
                  }
                },
                accent: true,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primaryGreyColor,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool accent;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.onTap,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accent ? paleColor6.withOpacity(0.25) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (accent ? primaryRedColor : primaryBlackColor).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: accent ? primaryRedColor : primaryBlackColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: primaryGreyColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: accent ? primaryRedColor : primaryBlackColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
