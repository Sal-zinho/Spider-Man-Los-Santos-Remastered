"""Reference-only traversal physics oracle; no game process or files are touched."""
from __future__ import annotations
from dataclasses import dataclass
from math import sqrt

@dataclass(frozen=True)
class Vec3:
    x: float = 0.0
    y: float = 0.0
    z: float = 0.0

    def __add__(self, o: "Vec3") -> "Vec3": return Vec3(self.x+o.x, self.y+o.y, self.z+o.z)
    def __sub__(self, o: "Vec3") -> "Vec3": return Vec3(self.x-o.x, self.y-o.y, self.z-o.z)
    def __mul__(self, k: float) -> "Vec3": return Vec3(self.x*k, self.y*k, self.z*k)
    __rmul__ = __mul__
    def dot(self, o: "Vec3") -> float: return self.x*o.x + self.y*o.y + self.z*o.z
    def length(self) -> float: return sqrt(self.dot(self))
    def normalized(self) -> "Vec3":
        n = self.length()
        return self*(1.0/n) if n > 1e-9 else Vec3()

@dataclass
class SwingState:
    position: Vec3
    velocity: Vec3
    anchor: Vec3 | None = None
    rope_length: float = 0.0

    @property
    def attached(self) -> bool: return self.anchor is not None

    def attach(self, anchor: Vec3, rope_length: float | None = None) -> None:
        distance = (self.position-anchor).length()
        self.anchor = anchor
        self.rope_length = max(1.0, float(rope_length if rope_length is not None else distance))
        radial = (self.position-anchor).normalized()
        self.position = anchor + radial*self.rope_length
        self.velocity = self.velocity - radial*self.velocity.dot(radial)

    def release(self) -> Vec3:
        self.anchor = None
        self.rope_length = 0.0
        return self.velocity

    def step(self, dt: float, forward: Vec3 = Vec3(), gravity: Vec3 = Vec3(0, 0, -9.81), swing_accel: float = 18.0) -> None:
        dt = max(0.0, min(float(dt), 0.05))
        if dt == 0.0:
            return
        drive = forward
        if self.attached:
            radial = (self.position-self.anchor).normalized()  # type: ignore[operator]
            drive = drive - radial*drive.dot(radial)
            drive = drive.normalized()*swing_accel
        self.velocity = self.velocity + (gravity+drive)*dt
        self.position = self.position + self.velocity*dt
        if self.attached:
            offset = self.position-self.anchor  # type: ignore[operator]
            radial = offset.normalized()
            self.position = self.anchor + radial*self.rope_length  # type: ignore[operator]
            self.velocity = self.velocity - radial*self.velocity.dot(radial)
