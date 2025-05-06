import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/utils/theme.dart';

class AppTextField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final bool isPassword;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final bool disabled; // Add disabled property
  final int? maxLines;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.isPassword = false,
    this.initialValue,
    this.validator,
    this.fillColor,
    this.disabled = false, // Default to false
    this.maxLines,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasText = _controller.text.isNotEmpty;
    final bool isFocused = _focusNode.hasFocus;
    final Color borderColor =
        (isFocused || hasText) ? theme.primaryColor : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: !widget.disabled,
          maxLines: widget.maxLines,
          focusNode:
              widget.disabled
                  ? FocusNode()
                  : _focusNode, // use a dummy focus node if disabled.
          validator: widget.validator,
          controller: _controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          onChanged:
              widget.disabled
                  ? null // Disable onChanged when disabled
                  : (value) {
                    widget.onChanged(value);
                    if (widget.validator != null) {
                      setState(() {
                        _errorText = widget.validator!(value);
                      });
                    } else {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
          decoration: InputDecoration(
            errorText: _errorText,
            hintText: hasText ? '' : widget.hintText,
            labelText: widget.labelText ?? widget.hintText,
            floatingLabelBehavior:
                hasText || isFocused
                    ? FloatingLabelBehavior.always
                    : FloatingLabelBehavior.auto,
            labelStyle: TextStyle(
              color: isFocused ? theme.primaryColor : Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.black38,
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
            filled: true,
            fillColor: widget.fillColor ?? Colors.white,
            prefixIcon: widget.prefixIcon,
            prefixIconColor: primaryColor,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          _obscureText
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          key: ValueKey<bool>(_obscureText),
                        ),
                      ),
                      onPressed:
                          widget.disabled
                              ? null // Disable the button when disabled
                              : () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                    )
                    : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
