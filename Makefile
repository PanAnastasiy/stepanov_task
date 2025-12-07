.PHONY: up down restart build dbt-check lint fix


up:
	docker-compose up -d --build

down:
	docker-compose down

restart: down up

shell:
	docker-compose exec airflow-scheduler /bin/bash

dbt-check:
	docker-compose exec airflow-scheduler dbt debug --project-dir /opt/airflow/dbt_project

lint:
	uv run sqlfluff lint --ignore E501 --project-dir .

fix:
	uv run sqlfluff fix --project-dir .