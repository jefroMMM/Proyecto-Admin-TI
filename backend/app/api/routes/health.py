from pathlib import Path
from typing import Annotated
from uuid import uuid4

from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.db.session import get_db_session
from app.schemas.health import HealthCheckItem, HealthCheckResponse, HealthResponse

router = APIRouter()


@router.get("/health", response_model=HealthResponse)
async def health_check() -> HealthResponse:
    return HealthResponse(status="ok", service="backend")


@router.get("/healthcheck", response_model=HealthCheckResponse)
async def strict_healthcheck(
    session: Annotated[AsyncSession, Depends(get_db_session)],
) -> HealthCheckResponse | JSONResponse:
    checks: dict[str, HealthCheckItem] = {}

    await _check_database(session, checks)
    _check_audio_storage(settings.audio_storage_path, checks)
    _check_runtime_configuration(checks)

    overall_status = (
        "ok"
        if all(check.status == "ok" for check in checks.values())
        else "error"
    )
    payload = HealthCheckResponse(
        status=overall_status,
        service=settings.PROJECT_NAME,
        environment=settings.ENVIRONMENT,
        checks=checks,
    )

    if overall_status != "ok":
        return JSONResponse(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            content=payload.model_dump(),
        )

    return payload


async def _check_database(
    session: AsyncSession,
    checks: dict[str, HealthCheckItem],
) -> None:
    try:
        result = await session.execute(text("SELECT 1"))
        value = result.scalar_one()
        if value != 1:
            raise RuntimeError(f"unexpected SELECT 1 result: {value!r}")
        checks["database"] = HealthCheckItem(
            status="ok",
            detail="PostgreSQL responded to SELECT 1",
        )
    except Exception as exc:  # noqa: BLE001 - healthcheck must report any failure.
        checks["database"] = HealthCheckItem(
            status="error",
            detail=f"Database check failed: {exc}",
        )


def _check_audio_storage(
    storage_path: Path,
    checks: dict[str, HealthCheckItem],
) -> None:
    probe_path = storage_path / f".healthcheck-{uuid4().hex}"
    try:
        storage_path.mkdir(parents=True, exist_ok=True)
        probe_path.write_text("ok", encoding="utf-8")
        if probe_path.read_text(encoding="utf-8") != "ok":
            raise RuntimeError("storage probe readback mismatch")
        checks["audio_storage"] = HealthCheckItem(
            status="ok",
            detail=f"Audio storage is writable at {storage_path}",
        )
    except Exception as exc:  # noqa: BLE001 - healthcheck must report any failure.
        checks["audio_storage"] = HealthCheckItem(
            status="error",
            detail=f"Audio storage check failed: {exc}",
        )
    finally:
        probe_path.unlink(missing_ok=True)


def _check_runtime_configuration(checks: dict[str, HealthCheckItem]) -> None:
    configured_providers = {
        "openai": bool(settings.OPENAI_API_KEY),
        "assemblyai": bool(settings.ASSEMBLYAI_API_KEY),
        "cartesia": bool(settings.CARTESIA_API_KEY and settings.CARTESIA_VOICE_ID),
    }
    checks["runtime_configuration"] = HealthCheckItem(
        status="ok",
        detail=(
            "Core configuration loaded; external provider credentials configured: "
            f"{configured_providers}"
        ),
    )
