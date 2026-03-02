# construction_estimator

Cấu trúc thư mục của một module:

module/
├── domain/
 │     ├── models/ ***(Model thuần Dart dùng cho UI / business)***

├── data/
 │     ├── entities/ ***(Model Isar dùng để tương tác với DB)***
 │     ├── repositories/ (Kho chứa các hàm tương tác với DB)

├── application/
 │     ├── cubits/ ***(State Management)***

├──presentation/
 │     ├── pages/ ***(UI)***
 │     ├── widgets
