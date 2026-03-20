# Rick and Morty Characters App

Мобильное приложение на Flutter для просмотра персонажей мультсериала "Рик и Морти".

## Функционал
- Список персонажей с пагинацией (бесконечный скролл).
- Добавление в избранное.
- Оффлайн-режим (кеширование данных в Hive).
- Поддержка светлой и темной тем.

## Стек технологий
- **State Management:** Flutter BLoC (Cubit)
- **Database:** Hive (NoSQL)
- **Networking:** Dio
- **Images:** CachedNetworkImage

## Запуск проекта
1. Убедитесь, что установлен Flutter (версия 3.10 или выше).
2. Склонируйте репозиторий.
3. Выполните команды в терминале:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter run
