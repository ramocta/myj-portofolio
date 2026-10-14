import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                hint: Text(hintText, style: const TextStyle(color: Colors.white54, fontSize: 14)),
                dropdownColor: const Color(0xFF2C2C2C),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                style: const TextStyle(color: Colors.white),
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}