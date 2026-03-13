import 'package:flutter/material.dart';
import '../glass_field_shell.dart';
import '../outlined_social_button.dart';
import '../or_divider.dart';
import '../primary_gradient_button.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController userController;
  final TextEditingController passController;

  final bool showPass;
  final VoidCallback onTogglePass;

  final String? errorText;

  final VoidCallback onForgotPass;
  final VoidCallback onLogin;
  final VoidCallback onGoogle;
  final VoidCallback onFacebook;
  final VoidCallback onGoRegister;

  const LoginForm({
    super.key,
    required this.userController,
    required this.passController,
    required this.showPass,
    required this.onTogglePass,
    required this.errorText,
    required this.onForgotPass,
    required this.onLogin,
    required this.onGoogle,
    required this.onFacebook,
    required this.onGoRegister,
  });

  // TSX sabit renkler (aynı)
  static const textDark = Color(0xFF3E2723);
  static const iconBrown = Color(0xFF4A3428);
  static const textMuted = Color(0xFF6B675F);
  static const placeholder = Color(0xFF8B8680);
  static const border = Color(0x66B4A193);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final h = mq.size.height;

    // Küçük ekranlar için boşlukları esnet (görünüm aynı hissi, taşma yok)
    final titleTop = (h * 0.01).clamp(8.0, 8.0); // aynı
    final formGap = (h * 0.035).clamp(20.0, 28.0);
    final sectionGap = (h * 0.02).clamp(14.0, 18.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: titleTop),
        Text(
          'Hoş Geldiniz',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: textDark,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hesabınıza giriş yapın',
          style: TextStyle(color: textMuted, fontSize: 16),
        ),
        SizedBox(height: formGap),

        // Username / Email
        _TextField(
          controller: userController,
          prefixIcon: Icons.mail_outline,
          hintText: 'Kullanıcı adı veya e-posta',
          keyboardType: TextInputType.emailAddress,
          borderColor: border,
          iconColor: textMuted,
          textColor: textDark,
          hintColor: placeholder,
        ),
        const SizedBox(height: 16),

        // Password
        _PasswordField(
          controller: passController,
          show: showPass,
          onToggle: onTogglePass,
          borderColor: border,
          iconColor: textMuted,
          textColor: textDark,
          hintColor: placeholder,
        ),

        if (errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 13),
          ),
        ],

        SizedBox(height: sectionGap),

        // Forgot
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF5C4033),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
            onPressed: onForgotPass,
            child: const Text('Şifremi Unuttum'),
          ),
        ),

        const SizedBox(height: 10),

        // Login button
        PrimaryGradientButton(
          text: 'Giriş Yap',
          onTap: onLogin,
        ),

        const SizedBox(height: 18),

        // Divider
        const OrDivider(
          text: 'veya',
          lineColor: Color(0x4DB4A193),
          textColor: placeholder,
        ),

        const SizedBox(height: 16),

        // Social
        Row(
          children: [
            Expanded(
              child: OutlinedSocialButton(
                text: 'Google',
                onTap: onGoogle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedSocialButton(
                text: 'Facebook',
                onTap: onFacebook,
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // Register link (right overflow fix: wrap + flexible)
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Hesabınız yok mu? ', style: TextStyle(color: textMuted)),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: iconBrown,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
                onPressed: onGoRegister,
                child: const Text('Kayıt Olun'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hintText;
  final TextInputType keyboardType;

  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final Color hintColor;

  const _TextField({
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    required this.keyboardType,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassFieldShell(
      borderColor: borderColor,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(prefixIcon, color: iconColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool show;
  final VoidCallback onToggle;

  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final Color hintColor;

  const _PasswordField({
    required this.controller,
    required this.show,
    required this.onToggle,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassFieldShell(
      borderColor: borderColor,
      child: TextField(
        controller: controller,
        obscureText: !show,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Şifre',
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(Icons.lock_outline, color: iconColor),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(show ? Icons.visibility_off : Icons.visibility, color: iconColor),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
