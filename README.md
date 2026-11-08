# 💸 حوالاتي (Hawalati) - Offline Money Transfer Manager

تطبيق هاتف محمول فاخر لتسجيل وإدارة الحوالات المالية يعمل **بدون إنترنت تماماً (Offline-Only)** مصمم باستخدام إطار العمل **Flutter** وتأمين البيانات بطبقة تشفير **AES-256**.

![Hawalati Banner](assets/images/banner.png)

## 🌟 الميزات الرئيسية
- 🔒 **عمل دون اتصال 100%**: لا يحتوي التطبيق على أي طلبات شبكة أو أذونات إنترنت.
- 🔐 **أمان عالي**: مصادقة بيومترية (بصمة/وجه) مع تخزين مشفر مفاتيح البيانات عبر `flutter_secure_storage`.
- 📊 **لوحة تحكم وتقارير**: رسوم بيانية تفاعلية وتصدير التقارير كملفات PDF و CSV محلياً.
- 💱 **إدارة العملات**: دعم كافة العملات مع إدخال سعر الصرف يدويًا بكل مرونة.
- 💾 **نسخ احتياطي محلي**: إمكانية استخراج واستعادة قاعدة بيانات Isar بصيغة JSON مضغوطة.

## 🛠️ البنية التقنية (Tech Stack)
- **إطار العمل**: Flutter (Dart)
- **إدارة الحالة**: Riverpod
- **قاعدة البيانات المحلية**: Isar Database (NoSQL)
- **التشغيل**: Android & iOS

## 🚀 طريقة التشغيل

```bash
# 1. استنسخ المستودع
git clone [https://github.com/your-username/hawalati.git](https://github.com/your-username/hawalati.git)

# 2. اننتقل إلى مجلد المشروع
cd hawalati

# 3. قم بتحميل الحزم
flutter pub get

# 4. ولد ملفات Isar
flutter pub run build_runner build --delete-conflicting-outputs

# 5. شغل التطبيق
flutter run
