import 'package:flutter/material.dart';

import 'charts.dart';
import 'componentChart.dart';

class DetalsChart extends StatefulWidget {
  static const String routeName = 'detalsChart';

  const DetalsChart({super.key});

  @override
  _DetalsChartState createState() => _DetalsChartState();
}

class _DetalsChartState extends State<DetalsChart> {
  int selectedMonth = 1;
  List<String> suggestions = ["تحسين الاجتماع الأسبوعي", "إضافة وقت للأسئلة"];
  TextEditingController suggestionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          "إحصائيات المشاركة",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تحليل الأنشطة المختلفة خلال الشهر",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),

            // زر اختيار الشهر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("اختر الفترة:", style: TextStyle(fontSize: 16)),
                DropdownButton<int>(
                  value: selectedMonth,
                  items: [
                    DropdownMenuItem(value: 1, child: Text("هذا الشهر")),
                    DropdownMenuItem(value: 2, child: Text("الشهر الماضي")),
                    DropdownMenuItem(value: 3, child: Text("آخر 3 أشهر")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),

            // الرسم البياني
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ComponentChart(selectedmonth: selectedMonth),
              ),
            ),

            SizedBox(height: 20),

            // إدخال اقتراح
            Text(
              "شارك باقتراحك:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: suggestionController,
                    decoration: InputDecoration(
                      hintText: "اكتب اقتراحك هنا...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (suggestionController.text.isNotEmpty) {
                      setState(() {
                        suggestions.add(suggestionController.text);
                        suggestionController.clear();
                      });
                    }
                  },
                  child: Text("إرسال"),
                ),
              ],
            ),

            SizedBox(height: 10),

            // عرض الاقتراحات مع نظام تصويت
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(suggestions[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("تم تسجيل إعجابك بالاقتراح!")),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // زر مشاركة الإحصائيات
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("تم نسخ رابط الإحصائيات!")),
                  );
                },
                icon: Icon(Icons.share),
                label: Text("مشاركة الإحصائيات"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
