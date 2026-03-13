import 'package:flutter/material.dart';
import '../auth_text_field.dart';
import '../auth_password_field.dart';
import 'family_card.dart';
import 'gender_card.dart';
import '../primary_gradient_button.dart';
import 'terms_row.dart';
import '../outlined_social_button.dart';
import '../or_divider.dart';
import '../../../../utils/password_rules.dart';
import '../../../../utils/email_validator.dart';
import 'password_strength_bar.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController fullNameC;
  final TextEditingController usernameC;
  final TextEditingController emailC;
  final TextEditingController passC;
  final TextEditingController pass2C;

  final bool showPass;
  final VoidCallback onToggleShowPass;

  final bool isFamily;
  final ValueChanged<bool> onFamilyChanged;

  final bool accept;
  final ValueChanged<bool> onAcceptChanged;

  // ✅ değişti
  final String? gender; // null | female | male
  final ValueChanged<String?> onGenderChanged;

  // ✅ yeni
  final String? femaleMode; // null | open | closed
  final ValueChanged<String?> onFemaleModeChanged;

  final String? errorText;
  final Future<void> Function() onSubmit;

  const RegisterForm({
    super.key,
    required this.fullNameC,
    required this.usernameC,
    required this.emailC,
    required this.passC,
    required this.pass2C,
    required this.showPass,
    required this.onToggleShowPass,
    required this.isFamily,
    required this.onFamilyChanged,
    required this.accept,
    required this.onAcceptChanged,
    required this.gender,
    required this.onGenderChanged,
    required this.femaleMode,
    required this.onFemaleModeChanged,
    required this.errorText,
    required this.onSubmit,
  });

  static const textDark = Color(0xFF3E2723);
  static const textMuted = Color(0xFF6B675F);
  static const placeholder = Color(0xFF8B8680);
  static const iconBrown = Color(0xFF4A3428);
  static const border = Color(0x66B4A193);

  void _warn(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(milliseconds: 900)),
    );
  }

  String? _validateAll(BuildContext context) {
    final fullName = fullNameC.text.trim();
    final username = usernameC.text.trim();
    final email = emailC.text.trim();
    final pass = passC.text;
    final pass2 = pass2C.text;

    if (fullName.isEmpty) return 'Ad Soyad boş bırakılamaz.';
    if (username.isEmpty) return 'Kullanıcı adı boş bırakılamaz.';
    final emailErr = EmailValidator.validateForRegister(email);
    if (emailErr != null) return emailErr;
    final passErr = PasswordRules.validate(pass);
    if (passErr != null) return passErr;
    if (pass2 != pass) return 'Şifreler eşleşmiyor.';
    if (gender == null) return 'Lütfen cinsiyet seçin.';
    if (gender == 'female' && femaleMode == null) return 'Lütfen tesettürlü / tesettürsüz seçin.';
    if (!accept) return 'Devam etmek için koşulları kabul edin.';
    return null;
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final err = _validateAll(context);
    if (err != null) {
      _warn(context, err);
      return;
    }
    await onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          'Hesap Oluştur',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: textDark,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Zarafete giden yolculuğunuz başlasın',
            style: TextStyle(color: textMuted, fontSize: 16)),
        const SizedBox(height: 28),

        AuthTextField(
          controller: fullNameC,
          prefixIcon: Icons.badge_outlined,
          hintText: 'Ad Soyad',
          keyboardType: TextInputType.name,
          borderColor: border,
          iconColor: textMuted,
          textColor: textDark,
          hintColor: placeholder,
          inputPolicy: AuthInputPolicy.fullName,
          onInvalidInput: (m) => _warn(context, m),
        ),
        const SizedBox(height: 16),

        AuthTextField(
          controller: usernameC,
          prefixIcon: Icons.person_outline,
          hintText: 'Kullanıcı Adı',
          keyboardType: TextInputType.text,
          borderColor: border,
          iconColor: textMuted,
          textColor: textDark,
          hintColor: placeholder,
          inputPolicy: AuthInputPolicy.username,
          onInvalidInput: (m) => _warn(context, m),
        ),
        const SizedBox(height: 16),

        AuthTextField(
          controller: emailC,
          prefixIcon: Icons.mail_outline,
          hintText: 'E-posta',
          keyboardType: TextInputType.emailAddress,
          borderColor: border,
          iconColor: textMuted,
          textColor: textDark,
          hintColor: placeholder,
          inputPolicy: AuthInputPolicy.email,
          onInvalidInput: (m) => _warn(context, m),
        ),
        const SizedBox(height: 16),

        // ✅ güncellenmiş GenderCard
        GenderCard(
          gender: gender,
          onGenderChanged: onGenderChanged,
          femaleMode: femaleMode,
          onFemaleModeChanged: onFemaleModeChanged,
        ),
        const SizedBox(height: 16),

        AuthPasswordField(
          controller: passC,
          show: showPass,
          onToggle: onToggleShowPass,
          hintText: 'Şifre',
          borderColor: border,
          iconColor: textMuted,
          textColor: textDark,
          hintColor: placeholder,
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: passC,
          builder: (_, v, __) => PasswordStrengthBar(password: v.text),
        ),
        const SizedBox(height: 16),

        AuthPasswordField(
          controller: pass2C,
          show: showPass,
          onToggle: onToggleShowPass,
          hintText: 'Şifre Tekrar',
          borderColor: border,
          iconColor: textMuted,
          textColor: textDark,
          hintColor: placeholder,
          showToggle: false,
        ),
        const SizedBox(height: 16),

        FamilyCard(value: isFamily, onChanged: onFamilyChanged),
        const SizedBox(height: 16),

        TermsRow(value: accept, onChanged: onAcceptChanged),

        if (errorText != null) ...[
          const SizedBox(height: 10),
          Text(errorText!, style: const TextStyle(color: Colors.red, fontSize: 13)),
        ],

        const SizedBox(height: 14),

        PrimaryGradientButton(
          text: 'Hesap Oluştur',
          enabled: accept,
          onTap: () => _handleSubmit(context),
        ),

        const SizedBox(height: 18),

        const OrDivider(
          text: 'veya',
          lineColor: Color(0x4DB4A193),
          textColor: Color(0xFF8B8680),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: OutlinedSocialButton(
                text: 'Google',
                onTap: () => ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Google kayıt (demo)'))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedSocialButton(
                text: 'Facebook',
                onTap: () => ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Apple kayıt (demo)'))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Zaten hesabınız var mı? ', style: TextStyle(color: textMuted)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Giriş Yapın', style: TextStyle(color: iconBrown)),
            ),
          ],
        ),
      ],
    );
  }
}
