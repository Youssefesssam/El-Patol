import 'package:el_patol/ui/screens/auth/registerScreen/registerProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class RegisterUtils {
  static Widget buildTextFieldDateWithIcon(
      String label,
      IconData icon,
      Function(String) onChanged, {
        required RegisterProvider provider,
        bool readOnly = false,
        VoidCallback? onTap,
      }) {
    final bool isEmpty = provider.birthDay.isEmpty;

    return TextFormField(
      controller: TextEditingController(text: provider.birthDay),
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        counterStyle: TextStyle(color: Colors.black),
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: isEmpty ? Colors.blue : Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:  Colors.blue ,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
      ),
    );
  }
  static Widget buildTextFieldLocationWithIcon(
      String label, {
        String? hintText,
        required IconData icon,
        required Function(String) onChanged,
        required RegisterProvider provider,
        bool readOnly = false,
        VoidCallback? onTap,
        Widget? suffixIcon, // ⬅️ الجديد
      }) {
    return TextFormField(
      controller: TextEditingController(text: provider.address),
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon, // ⬅️ هنا كمان
        border: OutlineInputBorder(),
      ),
    );
  }



  static Widget buildTextFieldWithIcon(
      String label,
      IconData icon,
      Function(String) onChanged, {
        RegisterProvider? provider,
        TextEditingController? controller,
        bool obscure = false,
        TextInputType keyboardType = TextInputType.text,
        String? hintText,
      }) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field required";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(

        labelText: label,
        labelStyle: TextStyle(color: Colors.blue.shade600),
        floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
        prefixIcon: Icon(icon, color: Colors.blue.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.blue,
        ),
      ),
      style: TextStyle(color: Colors.black87, fontSize: 16),
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );

  }

  static Widget buildTextPassFieldWithIcon(
      String label,
      IconData icon,
      Function(String) onChanged, {
        required TextEditingController controller,
        required dynamic provider,
        bool obscure = false,
        bool isPassword = false,
        String? hintText,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return StatefulBuilder(
      builder: (context, setState) {
        String password = controller.text;

        bool hasMinLength = password.length >= 8;
        bool hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
        bool hasNumber = RegExp(r'[0-9]').hasMatch(password);

        Widget buildRequirement(String text, bool condition) {
          return Row(
            children: [
              Icon(
                condition ? Icons.check_circle : Icons.cancel,
                color: condition ? Colors.green : Colors.red,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: condition ? Colors.green : Colors.red,
                  fontSize: 13,
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              onChanged: (value) {
                onChanged(value);
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.blue.shade600),
                floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
                prefixIcon: Icon(icon, color: Colors.blue.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            if (isPassword) ...[
              SizedBox(height: 10),
              Text(
                "Password must contain:",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              buildRequirement("• At least 8 characters", hasMinLength),
              buildRequirement("• At least one letter (a-z)", hasLetter),
              buildRequirement("• At least one number (0-9)", hasNumber),
            ]
          ],
        );
      },
    );
  }


  static Widget buildGenderDropdown(RegisterProvider provider) {
    return DropdownButtonFormField<String>(
      value: provider.gender,
      decoration: InputDecoration(
        labelText: "Gender",
        labelStyle: TextStyle(color: Colors.blue.shade600),
        floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
        prefixIcon: Icon(Icons.transgender, color: Colors.blue.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(
          value: "male",
          child: Text("Male", style: TextStyle(color: Colors.black87)),
        ),
        DropdownMenuItem(
          value: "female",
          child: Text("Female", style: TextStyle(color: Colors.black87)),
        ),
      ],
      onChanged: (value) => provider.setGender(value!),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade500),
    );
  }

  static Widget buildTalentDropdown(RegisterProvider provider) {
    return DropdownButtonFormField<String>(
      value: provider.selectedTalent,
      decoration: InputDecoration(
        labelText: 'selectTalent',
        labelStyle: TextStyle(color: Colors.blue.shade600),
        floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
        prefixIcon: Icon(Icons.star, color: Colors.blue.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(
          value: "الترتيل / الإنشاد",
          child: Text("الترتيل / الإنشاد"),
        ),
        DropdownMenuItem(
          value: "العزف على آلة موسيقية",
          child: Text("العزف على آلة موسيقية"),
        ),
        DropdownMenuItem(
          value: "التمثيل المسرحي",
          child: Text("التمثيل المسرحي"),
        ),
        DropdownMenuItem(
          value: "الإخراج / التصوير",
          child: Text("الإخراج / التصوير"),
        ),
        DropdownMenuItem(
          value: "التصميم الجرافيكي",
          child: Text("التصميم الجرافيكي"),
        ),
        DropdownMenuItem(
          value: "الكتابة الإبداعية",
          child: Text("الكتابة الإبداعية"),
        ),
        DropdownMenuItem(value: "الترجمة", child: Text("الترجمة")),
        DropdownMenuItem(
          value: "التقديم / الإلقاء",
          child: Text("التقديم / الإلقاء"),
        ),
        DropdownMenuItem(value: "المونتاج", child: Text("المونتاج")),
        DropdownMenuItem(value: "البرمجة", child: Text("البرمجة")),
        DropdownMenuItem(value: "العمل الفني", child: Text("العمل الفني")),
        DropdownMenuItem(
          value: "التنظيم والإدارة",
          child: Text("التنظيم والإدارة"),
        ),
        DropdownMenuItem(
          value: "التعليم والتدريب",
          child: Text("التعليم والتدريب"),
        ),
        DropdownMenuItem(
          value: "التسويق الرقمي",
          child: Text("التسويق الرقمي"),
        ),
        DropdownMenuItem(value: "الطهي", child: Text("الطهي")),
        DropdownMenuItem(value: "الخط العربي", child: Text("الخط العربي")),
        DropdownMenuItem(
          value: "الترجمة الفورية",
          child: Text("الترجمة الفورية"),
        ),
        DropdownMenuItem(
          value: "الإبداع في التواصل",
          child: Text("الإبداع في التواصل"),
        ),
        DropdownMenuItem(
          value: "الإلقاء الشعري",
          child: Text("الإلقاء الشعري"),
        ),
        DropdownMenuItem(
          value: "التصوير الفوتوغرافي",
          child: Text("التصوير الفوتوغرافي"),
        ),
        DropdownMenuItem(
          value: "وسائل التواصل الاجتماعي",
          child: Text("وسائل التواصل الاجتماعي"),
        ),
        DropdownMenuItem(
          value: "إصلاح وصيانة الأجهزة",
          child: Text("إصلاح وصيانة الأجهزة"),
        ),
        DropdownMenuItem(value: "خدمة الآخرين", child: Text("خدمة الآخرين")),
        DropdownMenuItem(
          value: "التوجيه والإرشاد",
          child: Text("التوجيه والإرشاد"),
        ),
        DropdownMenuItem(value: "أخرى", child: Text("أخرى")),
      ],
      onChanged: (value) => provider.setSelectedTalent(value!),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade500),
    );
  }

  static Widget buildStepContainer(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  static Widget buildAspectButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: AnimatedScale(
              duration: Duration(milliseconds: 200),
              scale: 1,
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            letterSpacing: 0.4,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}