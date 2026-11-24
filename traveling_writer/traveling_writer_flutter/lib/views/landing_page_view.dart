import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/story.dart';
import '../services/storage_service.dart';
import '../theme/parchment_theme.dart';

class LandingPageView extends StatefulWidget {
  final Function(UserSession) onSessionStarted;

  const LandingPageView({
    super.key,
    required this.onSessionStarted,
  });

  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  bool _isSignUp = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _penNameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _penNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final login = _usernameController.text.trim();
    final password = _passwordController.text;

    if (login.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username/email and password.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final account = await StorageService.authenticate(login, password);
    if (account != null) {
      final session = account.toSession();
      await StorageService.setActiveSession(session);
      setState(() => _isLoading = false);
      widget.onSessionStarted(session);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Invalid credentials. If you do not have an account yet, click "Create Account" above.';
      });
    }
  }

  Future<void> _handleSignUp() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final penName = _penNameController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty || password.isEmpty || penName.isEmpty) {
      setState(() {
        _errorMessage = 'Please provide Pen Name, Username, and Password.';
      });
      return;
    }

    if (username.length < 3) {
      setState(() {
        _errorMessage = 'Username must be at least 3 characters long.';
      });
      return;
    }

    if (password.length < 4) {
      setState(() {
        _errorMessage = 'Password must be at least 4 characters long.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final existing = await StorageService.loadAccounts();
    final isTaken = existing.any(
      (a) => a.username.toLowerCase() == username.toLowerCase(),
    );

    if (isTaken) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Username "$username" is already taken. Please choose another or Sign In.';
      });
      return;
    }

    final newAccount = UserAccount(
      username: username,
      password: password,
      penName: penName,
      email: email,
    );

    await StorageService.saveAccount(newAccount);
    final session = newAccount.toSession();
    await StorageService.setActiveSession(session);

    setState(() => _isLoading = false);
    widget.onSessionStarted(session);
  }

  Future<void> _startGuestDemo() async {
    setState(() => _isLoading = true);
    final guestSession = UserSession(
      penName: 'Guest Writer',
      email: '',
      username: 'guest_${const Uuid().v4()}',
      isGuest: true,
    );
    await StorageService.setActiveSession(guestSession);
    setState(() => _isLoading = false);
    widget.onSessionStarted(guestSession);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: ParchmentTheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 18 : 32,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.08),
              color: ParchmentTheme.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                    color: ParchmentTheme.cardBorder, width: 1.5),
              ),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 22 : 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Icon & Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                ParchmentTheme.primaryUmber.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_stories,
                            color: ParchmentTheme.primaryUmber,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Traveling Writer',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ParchmentTheme.inkDark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tagline
                    const Text(
                      'Write boundless worlds. Never break canon.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        color: ParchmentTheme.primaryUmber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Auth Tab Switcher: [Sign In] | [Create Account]
                    Container(
                      decoration: BoxDecoration(
                        color: ParchmentTheme.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ParchmentTheme.cardBorder),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                setState(() {
                                  _isSignUp = false;
                                  _errorMessage = null;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !_isSignUp
                                      ? ParchmentTheme.primaryUmber
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: !_isSignUp
                                        ? Colors.white
                                        : ParchmentTheme.inkMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                setState(() {
                                  _isSignUp = true;
                                  _errorMessage = null;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isSignUp
                                      ? ParchmentTheme.primaryUmber
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: _isSignUp
                                        ? Colors.white
                                        : ParchmentTheme.inkMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Error Banner
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: ParchmentTheme.alertBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ParchmentTheme.alertBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: ParchmentTheme.alertText,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: ParchmentTheme.alertText,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // FORM FIELDS
                    if (_isSignUp) ...[
                      // Pen Name
                      TextField(
                        controller: _penNameController,
                        decoration: InputDecoration(
                          labelText: 'Pen Name',
                          hintText: 'e.g., Alden Vance or Elena',
                          prefixIcon: const Icon(Icons.edit_note, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Email (optional)
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email (Optional)',
                          hintText: 'author@domain.com',
                          prefixIcon:
                              const Icon(Icons.email_outlined, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Username
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText:
                            _isSignUp ? 'Choose Username' : 'Username or Email',
                        prefixIcon: const Icon(Icons.person_outline, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onSubmitted: (_) {
                        if (_isSignUp) {
                          _handleSignUp();
                        } else {
                          _handleSignIn();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 20,
                            color: ParchmentTheme.inkMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Submit Button
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: ParchmentTheme.primaryUmber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_isSignUp) {
                                _handleSignUp();
                              } else {
                                _handleSignIn();
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isSignUp ? 'Create Workspace' : 'Sign In',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: ParchmentTheme.cardBorder),
                    const SizedBox(height: 16),

                    // Guest / Hackathon Demo Button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ParchmentTheme.inkDark,
                        side:
                            const BorderSide(color: ParchmentTheme.cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading ? null : _startGuestDemo,
                      icon: const Icon(
                        Icons.bolt,
                        color: ParchmentTheme.secondaryBronze,
                        size: 18,
                      ),
                      label: const Text(
                        'Explore Hackathon Demo as Guest',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
