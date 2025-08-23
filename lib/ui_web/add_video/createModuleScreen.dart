import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models_web/model_module.dart';
import 'moduleDetailsScreen.dart';

class CreateModuleScreen extends StatefulWidget {
  static const String routeName = 'createModuleScreen';
  final String stage;

  const CreateModuleScreen({super.key, required this.stage});

  @override
  _CreateModuleScreenState createState() => _CreateModuleScreenState();
}

class _CreateModuleScreenState extends State<CreateModuleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isLoading = false;

  // قائمة المراحل (عرض + الكود اللي يروح للفاييربيز)

  Future<void> _createModule() async {
    if (widget.stage == null || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك اختر المرحلة وادخل اسم الموديول")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance
          .collection("center")
          .doc('101')
          .collection('Mr')
          .doc('Mr1017595')
          .collection('modules')
          .doc(widget.stage) // نخزن الموديول جوه المرحلة
          .collection('module')
          .doc();

      final newModule = Module(
        id: docRef.id,
        title: _titleController.text.trim(),
        stage: widget.stage!, // نخزن الكود P_1, P_2, P_3
        price: double.tryParse(_priceController.text) ?? 0.0,
        videos: [],
        createdAt: DateTime.now(),
        imageUrl: '',
      );

      await docRef.set(newModule.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إنشاء الموديول بنجاح ✅")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ModuleDetailsScreen(
            module: newModule,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ أثناء إنشاء الموديول: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إنشاء موديول جديد")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "اسم الموديول"),
            ),
            const SizedBox(height: 20),

            // Dropdown لاختيار المرحلة
            const SizedBox(height: 20),

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "السعر"),
            ),
            const SizedBox(height: 20),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              onPressed: _createModule,
              icon: const Icon(Icons.add),
              label: const Text("إنشاء موديول"),
            ),
          ],
        ),
      ),
    );
  }
}
