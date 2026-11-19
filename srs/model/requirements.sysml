package DriveFlowRequirements {
    private import ScalarValues::*;

    /* ---------- Определения ---------- */
    requirement def FunctionalRequirement {
        attribute reqId : String;
        attribute priority : String;
    }

    requirement def QualityRequirement {
        attribute reqId : String;
        attribute priority : String;
    }

    part def BookingService;
    part def TripOrchestrator;     // Camunda 8 (Zeebe) + job workers на Kotlin
    part def PricingEngine;
    part def PaymentAdapter;
    part def OperatorService;
    part def AuditLog;

    /* ---------- Компоненты ---------- */
    part bookingService : BookingService;
    part tripOrchestrator : TripOrchestrator;
    part pricingEngine : PricingEngine;
    part paymentAdapter : PaymentAdapter;
    part operatorService : OperatorService;
    part auditLog : AuditLog;

    /* ---------- Модуль 1: Бронирование ---------- */
    requirement searchCars : FunctionalRequirement {
        doc /* Поиск свободных автомобилей по времени и локации. */
        :>> reqId = "REQ-FUNC-001";
        :>> priority = "Must";
    }
    requirement reserveCar : FunctionalRequirement {
        doc /* Бронь на интервал; пересечение интервалов одного автомобиля недопустимо. */
        :>> reqId = "REQ-FUNC-002";
        :>> priority = "Must";
    }
    requirement expireReservation : FunctionalRequirement {
        doc /* Истечение брони по настраиваемому таймауту, уведомление за 5 минут. */
        :>> reqId = "REQ-FUNC-003";
        :>> priority = "Must";
    }
    requirement cancelReservation : FunctionalRequirement {
        doc /* Отмена брони клиентом, комиссия по правилам тарифа. */
        :>> reqId = "REQ-FUNC-004";
        :>> priority = "Should";
    }

    /* ---------- Модуль 2: Поездка и расчёт ---------- */
    requirement activateTrip : FunctionalRequirement {
        doc /* Активация поездки: проверка прав и разблокировка автомобиля. */
        :>> reqId = "REQ-FUNC-005";
        :>> priority = "Must";
    }
    requirement finishAndPrice : FunctionalRequirement {
        doc /* Завершение поездки и расчёт стоимости по тарифу. */
        :>> reqId = "REQ-FUNC-006";
        :>> priority = "Must";
    }
    requirement idempotentPayment : FunctionalRequirement {
        doc /* Предавторизация и списание; повторный запрос не приводит к двойному списанию. */
        :>> reqId = "REQ-FUNC-007";
        :>> priority = "Must";
    }
    requirement retryAndCompensate : FunctionalRequirement {
        doc /* Повтор списания и компенсирующие действия (saga). */
        :>> reqId = "REQ-FUNC-008";
        :>> priority = "Should";
    }

    /* ---------- Модуль 3: Операторы и аудит ---------- */
    requirement disputeResolution : FunctionalRequirement {
        doc /* Разбор спорных поездок оператором, перерасчёт, частичный возврат. */
        :>> reqId = "REQ-FUNC-009";
        :>> priority = "Should";
    }
    requirement auditTrail : FunctionalRequirement {
        doc /* Журнал аудита всех переходов состояний поездки. */
        :>> reqId = "REQ-FUNC-010";
        :>> priority = "Must";
    }
    requirement historyAndReceipt : FunctionalRequirement {
        doc /* История поездок и электронный чек (в том числе PDF). */
        :>> reqId = "REQ-FUNC-011";
        :>> priority = "Should";
    }
    requirement tariffManagement : FunctionalRequirement {
        doc /* Управление тарифами с версионированием. */
        :>> reqId = "REQ-FUNC-012";
        :>> priority = "Could";
    }

    /* ---------- Нефункциональные требования ---------- */
    requirement perfBooking : QualityRequirement {
        doc /* p95 создания брони менее 300 мс при 200 запросах/с. */
        :>> reqId = "REQ-PERF-001";
        :>> priority = "Must";
    }
    requirement relNoDoubleBooking : QualityRequirement {
        doc /* 0 дублей брони при 1000 конкурентных запросах на один автомобиль. */
        :>> reqId = "REQ-REL-001";
        :>> priority = "Must";
    }
    requirement relProcessRestart : QualityRequirement {
        doc /* Состояние процесса поездки переживает перезапуск сервиса. */
        :>> reqId = "REQ-REL-002";
        :>> priority = "Must";
    }
    requirement secAuth : QualityRequirement {
        doc /* Аутентификация JWT и ролевая модель. */
        :>> reqId = "REQ-SEC-001";
        :>> priority = "Must";
    }
    requirement availTarget : QualityRequirement {
        doc /* Доступность 99,5 % в месяц. */
        :>> reqId = "REQ-AVAIL-001";
        :>> priority = "Should";
    }
    requirement portCompose : QualityRequirement {
        doc /* Запуск всех компонентов через Docker Compose. */
        :>> reqId = "REQ-PORT-001";
        :>> priority = "Must";
    }

    /* ---------- Трассируемость: satisfy ---------- */
    satisfy searchCars by bookingService;
    satisfy reserveCar by bookingService;
    satisfy expireReservation by tripOrchestrator;
    satisfy cancelReservation by bookingService;
    satisfy activateTrip by tripOrchestrator;
    satisfy finishAndPrice by pricingEngine;
    satisfy idempotentPayment by paymentAdapter;
    satisfy retryAndCompensate by tripOrchestrator;
    satisfy disputeResolution by operatorService;
    satisfy auditTrail by auditLog;
    satisfy historyAndReceipt by operatorService;
    satisfy tariffManagement by pricingEngine;
    satisfy relNoDoubleBooking by bookingService;
    satisfy relProcessRestart by tripOrchestrator;

    /* ---------- Верификация ---------- */
    verification def ConcurrentBookingTest {
        doc /* 1000 параллельных запросов на один автомобиль и интервал. */
        objective {
            verify reserveCar;
            verify relNoDoubleBooking;
        }
    }
    verification def IdempotentPaymentTest {
        objective {
            verify idempotentPayment;
        }
    }
    verification def ProcessRestartTest {
        objective {
            verify relProcessRestart;
        }
    }
}
