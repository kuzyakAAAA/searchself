# UML Sequence Diagram: создание бронирования

Диаграмма описывает сценарий создания бронирования переговорной комнаты, включая валидацию бизнес-правил и взаимодействие с внешними компонентами.

```mermaid
sequenceDiagram
    autonumber
    actor Employee as Сотрудник
    participant Frontend
    participant Backend as Backend/API
    participant DB as Database
    participant Notification as Система уведомлений

    Employee->>Frontend: Указать комнату, дату и время
    Frontend->>Backend: POST /api/v1/bookings (JSON)

    Note over Backend: Валидация BR-001, BR-002
    Backend->>Backend: Проверить корректность времени
    
    alt Время некорректно
        Backend-->>Frontend: 400 Bad Request (INVALID_TIME_RANGE)
        Frontend-->>Employee: Показать ошибку времени
    else Время валидно
        Backend->>DB: Проверить активность комнаты и пересечения (BR-003, BR-004)
        DB-->>Backend: Результат проверки
        
        alt Комната занята или неактивна
            Backend-->>Frontend: 409 Conflict (BOOKING_CONFLICT)
            Frontend-->>Employee: Показать ошибку: комната недоступна
        else Свободно
            Backend->>DB: INSERT INTO bookings (confirmed)
            DB-->>Backend: ID бронирования
            
            %% Асинхронная отправка события
            Backend-)Notification: Event: booking_created (BR-010)
            
            Backend-->>Frontend: 201 Created + ID
            Frontend-->>Employee: Показать подтверждение
            Notification-->>Employee: Отправить Email/Push
        end
    end