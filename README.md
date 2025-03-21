# ToDoList App

Простое приложение для управления задачами, разработанное с использованием UIKit, архитектуры MVVM и CoreData. Приложение позволяет добавлять, редактировать, удалять и искать задачи, а также загружает данные из [dummyjson API](https://dummyjson.com/todos).

---

## Требования и их выполнение

### 1. Список задач
- **Отображение списка задач на главном экране**: Задачи отображаются в таблице с названием, описанием, датой создания и статусом выполнения.
- **Добавление новой задачи**: Реализовано через экран создания задачи.
- **Редактирование задачи**: Реализовано через экран редактирования задачи.
- **Удаление задачи**: Задачи можно удалять через кнопку удаления.
- **Поиск по задачам**: Реализован поиск по названию и описанию задачи.

### 2. Загрузка списка задач из API
- При первом запуске приложение загружает задачи из [dummyjson API](https://dummyjson.com/todos) и сохраняет их в CoreData. При последующих запусках данные загружаются из CoreData.

### 3. Многопоточность
- Все операции (загрузка, создание, редактирование, удаление и поиск задач) выполняются в фоновом потоке с использованием **GCD**.
- Интерфейс не блокируется при выполнении операций.

### 4. CoreData
- Данные о задачах сохраняются в CoreData.
- При повторном запуске приложение восстанавливает данные из CoreData.

### 5. Система контроля версий
- Проект разработан с использованием **Git**.

### 6. Юнит-тесты
- Написаны юнит-тесты для основных компонентов приложения, включая `TaskListViewController`, `DetailViewController` и `TaskViewModel`.

### 7. Совместимость с Xcode 15
- Проект полностью совместим с **Xcode 15**.
### Дополнительно
- Генерация ассетов через SwiftGen, светлая/темная тема, локализация 
---

## Как запустить проект

### 1. Клонирование репозитория
Откройте терминал и выполните команду:
```bash
git clone https://github.com/BBBtp/iOS-TestTask-EM.git
cd iOS-TestTask-EM
pod install
