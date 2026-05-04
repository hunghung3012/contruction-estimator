TÀI LIỆU SỬ DỤNG MODULE CHO CHỨC NĂNG YÊU CẦU TRUY CẬP GALLERY HOẶC CAMERA THÔNG QUA PACKAGE image_picker VÀ camera

**I. Import Package:**

permission_handler: ^12.0.1

device_info_plus: ^11.5.0

image_picker: ^1.2.1

camera: ^0.11.2

**II. Config:**

**1. Cấu hình cho package permission_handler:**
Trong android/gradle.properties thêm:

```properties
android.useAndroidX=true
android.enableJetifier=true
```

    Trong ios/Podfile thêm:

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
     flutter_additional_ios_build_settings(target)
     target.build_configurations.each do |config|   
         config.build_settings['DEBUG_INFORMATION_FORMAT'] ='dwarf-with-dsym'  
         config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
	      '$(inherited)',
              'PERMISSION_PHOTOS=1',
	      'PERMISSION_CAMERA=1',
         ]
     end
  end
end
```

2. **Cấu hình cho package image_picker:**
   Trong android/app/src/main/AndroidManifest.xml thêm:

```
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name=""android.permission.READ_MEDIA_IMAGES" />
```

Trong ios/Runner/Info.plist thêm:

```
<key>NSPhotoLibraryUsageDescription</key>
<string>The app needs photo access to pick images for ... </string>
```

3. **Cấu hình cho package camera:**

Trong android/gradle.properties thêm:

```
<uses-permission android:name="android.permission.CAMERA" />
```

Trong ios/Runner/Info.plist thêm:

```
<key>NSCameraUsageDescription</key>
<string>The app needs camera access to take photos for ...</string>
```

**III. Cách dùng:**
