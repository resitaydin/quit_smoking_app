import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textWidget(
    String title, TextEditingController controller, Function validator,
    {Function? onTap, bool readOnly = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xffA7A7A7),
        ),
      ),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(
              12), // Increased border radius for a more attractive look
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                  0.1), // Slightly increased opacity for a softer shadow
              spreadRadius: 2, // Increased spread radius for a wider shadow
              blurRadius: 5, // Increased blur radius for a softer shadow
            ),
          ],
        ),
        child: TextFormField(
          readOnly: readOnly,
          onTap: onTap as void Function()?,
          validator: (input) => validator(input),
          controller: controller,
          style: GoogleFonts.montserrat(
            // You can change the font to your liking
            fontSize: 14,
            fontWeight:
                FontWeight.w500, // Adjusted font weight for a balanced look
            color: Colors
                .black87, // Changed text color to black for better readability
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16), // Added padding for better text alignment
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors
                .grey[50], // Set the fill color to match the container's color
          ),
        ),
      ),
    ],
  );
}
