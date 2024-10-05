import 'package:flutter/material.dart';

class LegalNameScreen extends StatefulWidget {
  const LegalNameScreen({super.key});

  @override
  _LegalNameScreenState createState() => _LegalNameScreenState();
}

class _LegalNameScreenState extends State<LegalNameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_firstNameFocus);
    });
    _firstNameController.addListener(_updateFormValidity);
    _lastNameController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_updateFormValidity);
    _lastNameController.removeListener(_updateFormValidity);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocus.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      _isFormValid = _firstNameController.text.trim().isNotEmpty &&
          _lastNameController.text.trim().isNotEmpty;
    });
  }

  void _tryNavigateToNext() {
  if (_isFormValid) {
    Navigator.of(context).pushNamed(
      '/notifications',
      arguments: {'firstName': _firstNameController.text.trim()},
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your legal name',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: Color(0xFF171717),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'We need to know a bit about you so that we can create your account.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF737373),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                    'First name', _firstNameController, _firstNameFocus),
                const SizedBox(height: 16),
                _buildTextField('Last name', _lastNameController),
                const Spacer(),
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      [FocusNode? focusNode]) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Color(0xFF171717),
      ),
      decoration: InputDecoration(
        labelText: label, // Stable label text
        floatingLabelBehavior:
            FloatingLabelBehavior.never, // Ensure label doesn't float or shake
        hintText: label, // Show hint instead of floating label
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFFA3A3A3),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFFA3A3A3),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA3A3A3)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA3A3A3)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0), // Consistent padding
      ),
      onChanged: (_) => _updateFormValidity(),
      autofillHints: null, // Disable autofill suggestions
      enableSuggestions: false, // Disable suggestions
      autocorrect: false, // Disable autocorrect
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _tryNavigateToNext,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isFormValid
                ? const Color(0xFF4F39E3)
                : const Color(0xFF4F39E3).withOpacity(0.4),
          ),
          child: const Icon(
            Icons.chevron_right,
            color: Color(0xFFFAFAFA),
            size: 40,
          ),
        ),
      ),
    );
  }
}
