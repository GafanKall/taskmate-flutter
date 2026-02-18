import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final DateTime? value;
  final void Function(DateTime?)? onDateSelected;
  final String? Function(String?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.value,
    this.onDateSelected,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: value != null ? DateFormat('yyyy-MM-dd').format(value!) : '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: firstDate ?? DateTime(2000),
              lastDate: lastDate ?? DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                      onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null && onDateSelected != null) {
              onDateSelected!(pickedDate);
            }
          },
          validator: validator,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Theme.of(context).hintColor),
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
      ],
    );
  }
}
