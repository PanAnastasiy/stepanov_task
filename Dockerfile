# Dockerfile (в корне проекта)

FROM apache/airflow:2.10.2-python3.12

USER root

# 1. Устанавливаем uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# 2. Устанавливаем git (требуется для dbt deps)
RUN apt-get update && apt-get install -y git && apt-get clean

# Переходим в airflow home
WORKDIR /opt/airflow

# 3. Копируем pyproject.toml и uv.lock из корня монорепы
COPY --chown=airflow:root pyproject.toml uv.lock /opt/airflow/

# 4. Синхронизируем зависимости uv
USER airflow
RUN uv sync --frozen --all-extras

USER root

# 5. Настройка ENV для dbt
ENV DBT_PROFILES_DIR=/opt/airflow/dbt_project
ENV DBT_PROJECT_DIR=/opt/airflow/dbt_project
