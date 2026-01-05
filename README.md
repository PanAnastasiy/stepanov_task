# ❄️ dbt + Airflow Data Vault Project

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Airflow](https://img.shields.io/badge/Airflow-017CEE?style=for-the-badge&logo=Apache%20Airflow&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=Snowflake&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=Docker&logoColor=white)

Проект по построению корпоративного хранилища данных (DWH) с использованием методологии **Data Vault 2.0**, оркестрацией через **Apache Airflow** и трансформациями на **dbt** (Data Build Tool) в облаке **Snowflake**.

---

## 🏗 Архитектура и Моделирование

Проект реализует полный цикл ELT процесса, преобразуя сырые данные из `SNOWFLAKE_SAMPLE_DATA` в аналитические витрины.

### 🔄 Data Flow (Поток данных)

1.  **Sources (Stage):** Загрузка данных из `SNOWFLAKE_SAMPLE_DATA` (TPCH/TPCDS).
2.  **Raw Vault:**
   *   **Hubs:** Бизнес-ключи (Customer, Order, etc.).
   *   **Links:** Связи между сущностями (строго 2 сущности на линк).
   *   **Satellites:** Атрибуты и контекст.
      *   *Optimization:* Разделение сателлитов на **High Velocity** (часто меняющиеся данные) и **Low Velocity** (редко меняющиеся) для оптимизации хранения.
      *   *Effectivity Satellites:* Отслеживание истории изменений связей (Driver keys).
3.  **Business Vault:**
   *   Внедрение бизнес-правил.
   *   **PIT (Point-in-Time) tables:** Для ускорения джойнов при построении витрин.
   *   **Bridge tables:** Для упрощения связей "многие-ко-многим".
   *   Обогащение данных через внешние Seed-файлы (Master Data).
4.  **Data Marts (Star Schema):**
   *   Финальные витрины для отчетности.
   *   **Facts:** Транзакционные данные.
   *   **Dimensions:** Измерения (Dim_Date, Dim_Customer).

---

# 📂 Структура проекта

```

dbt_airflow_task/
│
├── .github/                   # CI/CD workflows (lint, dbt test/run, build images)
│
├── core/
│   ├── airflow/               # Airflow DAGs, plugins, airflow.cfg overrides
│   │   ├── dags/              # DAG definitions
│   │
│   └── dbt_customer_project/  # Main dbt project
│       ├── macros/            # Custom dbt macros (hashing, auditing, utils)
│       ├── models/
│       │   ├── staging/        # Staging models (views, light transforms)
│       │   ├── raw_vault/      # Data Vault layer (Hubs, Links, Satellites)
│       │   ├── business_vault/ # PIT tables, Computed Satellites
│       │   ├── sources/        # Source definitions (YAML)
│       │   └── marts/          # Data marts (facts, dimensions)
│       ├── seeds/              # Seed CSVs (reference / master data)
│       ├── dbt_project.yml     # dbt project configuration
│       └── profiles.yml        # dbt connection profiles (optional, often external)
│
├── Dockerfile                 # Root image (optional, e.g. dbt runner)
├── docker-compose.yml         # Local orchestration (Airflow + dbt + DB)
├── entrypoint.sh              # Container startup logic
│
├── Makefile                   # Unified CLI for local dev & CI

```
# Быстрый старт (Make)

В проекте настроен **Makefile** для полной автоматизации. Вам не нужно запоминать команды Docker или dbt.

## Одна команда для всего (Magic Command)

Если вы запускаете проект в первый раз, просто выполните:

```bash
make install

Что сделает эта команда:

1.Создаст .env файл из шаблона (⚠️ Не забудьте вписать туда пароли от Snowflake!)

2.Поднимет Docker контейнеры (Airflow, Postgres)

3.Проверит соединение с базой данных (dbt debug)

4.Загрузит справочники (dbt seed)

5.Построит всё хранилище (dbt run)

6.Протестирует данные (dbt test)

7.Сгенерирует документацию
```

# Справочник команд

Если нужен ручной контроль, используйте отдельные команды:



| Команда | Описание |
| ----------------- | ------------------------------------------ |
| make up | Поднять Docker контейнеры и настроить окружение |
| make down | Остановить и удалить контейнеры |
| make dbt-check | Проверить соединение dbt с базой данных |
| make dbt-run | Запустить построение моделей |
| make dbt-test | Запустить тесты качества данных |
| make dbt-docs | Генерировать документацию dbt |
| make shell | Зайти внутрь контейнера Airflow (bash) |
| make lint | Проверка SQL кода (SQLFluff) |
| make fix | Автоматическое исправление стиля SQL кода |