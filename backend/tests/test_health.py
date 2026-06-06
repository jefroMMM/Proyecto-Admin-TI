from collections.abc import AsyncGenerator

from fastapi.testclient import TestClient

from app.db.session import get_db_session
from app.main import app


class HealthyResult:
    def scalar_one(self) -> int:
        return 1


class HealthySession:
    async def execute(self, statement: object) -> HealthyResult:
        return HealthyResult()


class FailingSession:
    async def execute(self, statement: object) -> HealthyResult:
        raise RuntimeError("database unavailable")


async def healthy_db_session() -> AsyncGenerator[HealthySession, None]:
    yield HealthySession()


async def failing_db_session() -> AsyncGenerator[FailingSession, None]:
    yield FailingSession()


def test_health_endpoint_returns_basic_status() -> None:
    client = TestClient(app)

    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok", "service": "backend"}


def test_healthcheck_returns_200_when_dependencies_are_available() -> None:
    app.dependency_overrides[get_db_session] = healthy_db_session
    client = TestClient(app)

    response = client.get("/healthcheck")

    app.dependency_overrides.clear()
    payload = response.json()
    assert response.status_code == 200
    assert payload["status"] == "ok"
    assert payload["checks"]["database"]["status"] == "ok"
    assert payload["checks"]["audio_storage"]["status"] == "ok"
    assert payload["checks"]["runtime_configuration"]["status"] == "ok"


def test_healthcheck_returns_500_when_database_fails() -> None:
    app.dependency_overrides[get_db_session] = failing_db_session
    client = TestClient(app)

    response = client.get("/healthcheck")

    app.dependency_overrides.clear()
    payload = response.json()
    assert response.status_code == 500
    assert payload["status"] == "error"
    assert payload["checks"]["database"]["status"] == "error"
