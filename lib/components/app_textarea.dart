import 'package:flutter/material.dart';
import 'package:reminder_app/utils/theme.dart';

class AppTextArea extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final bool disabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  const AppTextArea({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.labelText,
    this.keyboardType = TextInputType.multiline,
    this.prefixIcon,
    this.initialValue,
    this.validator,
    this.fillColor,
    this.disabled = false,
    this.maxLines = 5,
    this.minLines = 3,
    this.maxLength,
  });

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {
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
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          focusNode: widget.disabled ? FocusNode() : _focusNode,
          validator: widget.validator,
          controller: _controller,
          keyboardType: widget.keyboardType,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          onChanged:
              widget.disabled
                  ? null
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24, // Increased vertical padding for text area
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
