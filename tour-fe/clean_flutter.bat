@echo off
echo ===============================
echo 🔄 Flutter Clean & Cache Reset
echo ===============================

:: Bước 1: Xoá build Flutter
echo >> Đang chạy flutter clean...
flutter clean

:: Bước 2: Xoá thư mục build trong project
echo >> Xoá thư mục build...
rmdir /s /q build
rmdir /s /q android\build

:: Bước 3: Xoá cache Gradle & Kotlin
echo >> Xoá cache Gradle và Kotlin...
rmdir /s /q "%USERPROFILE%\.gradle\caches\kotlin"
rmdir /s /q "%USERPROFILE%\.gradle\caches\modules-2"
rmdir /s /q "%USERPROFILE%\.gradle\caches\transforms-1"
rmdir /s /q "%USERPROFILE%\.gradle\caches\transforms-2"

:: Bước 4: Cài lại dependency
echo >> Chạy flutter pub get...
flutter pub get

echo ===============================
echo ✅ Dọn dẹp hoàn tất! Hãy thử flutter run
echo ===============================
pause
