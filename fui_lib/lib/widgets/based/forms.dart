import 'package:flutter/material.dart';

class BasedCreatePassword extends StatefulWidget {
  const BasedCreatePassword({
    required this.textFieldKey,
    required this.onChanged,
    this.onFieldSubmitted,
  });
  final Key textFieldKey;
  final Function onChanged;
  final Function? onFieldSubmitted;

  @override
  BasedCreatePasswordState createState() {
    return BasedCreatePasswordState();
  }
}

class BasedCreatePasswordState extends State<BasedCreatePassword> {
  bool _obscurePassword = true;

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget.textFieldKey,
      obscureText: _obscurePassword,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: _buildEye(),
        ),
      ),
      validator: (value) {
        if ((value?.length ?? 0) < 4) {
          return 'Password is too short';
        }
        return null;
      },
      onChanged: (password) => widget.onChanged(password),
      onFieldSubmitted: (String? value) => widget.onFieldSubmitted!(),
    );
  }

  Widget _buildEye() {
    Color color = _obscurePassword ? Colors.grey : Colors.green;
    return IconButton(
        icon: const Icon(Icons.remove_red_eye),
        color: color,
        onPressed: () {
          _toggleObscurePassword();
        });
  }
}
