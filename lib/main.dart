import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterShellDiagnosticApp());
}

class FlutterShellDiagnosticApp extends StatelessWidget {
  const FlutterShellDiagnosticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DUGHRY Flutter Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF123B67)),
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline, size: 76, color: Colors.green),
                    SizedBox(height: 20),
                    Text(
                      'اختبار تشغيل دوجري',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'إذا ظهرت هذه الشاشة وظلت مفتوحة، فهذا يؤكد أن Android وFlutter يعملان، وسنبحث عن سبب الإغلاق داخل كود التطبيق الأصلي.',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text('DUGHRY • Flutter Shell Diagnostic'),
                    SizedBox(height: 8),
                    Text('نسخة اختبار منفصلة — لا تحتوي على واجهات أو وظائف التطبيق الأصلية'),
                    SizedBox(height: 16),
                    Text('اترك الشاشة مفتوحة لمدة دقيقة للتأكد من ثبات التشغيل.'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
