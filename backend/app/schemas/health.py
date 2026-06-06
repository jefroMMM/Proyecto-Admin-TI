from pydantic import BaseModel, Field


class HealthResponse(BaseModel):
    status: str
    service: str


class HealthCheckItem(BaseModel):
    status: str
    detail: str


class HealthCheckResponse(BaseModel):
    status: str
    service: str
    environment: str
    checks: dict[str, HealthCheckItem] = Field(default_factory=dict)
