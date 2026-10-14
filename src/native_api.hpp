#pragma once
#include "native_runtime.hpp"

// Minimal GTA V Legacy native surface used by the traversal prototype only.
// Hashes are public native hashes; the local native-map.csv translates them
// for the exact supported Legacy build. No ScriptHookV dependency.
namespace gta
{
    inline Ped PlayerPedId()
    {
        return invoke<Ped>(0xD80958FC74E988A6);
    }

    inline BOOL DoesEntityExist(Entity entity)
    {
        return invoke<BOOL>(0x7239B21A38F536BA, entity);
    }

    inline Vector3 GetEntityCoords(Entity entity, BOOL alive)
    {
        return invoke<Vector3>(0x3FEF770D40960D5A, entity, alive);
    }

    inline Vector3 GetEntityVelocity(Entity entity)
    {
        return invoke<Vector3>(0x4805D2B1D8CF94A9, entity);
    }

    inline void SetEntityVelocity(Entity entity, float x, float y, float z)
    {
        invoke<Void>(0x1C99BB7B6E96D16F, entity, x, y, z);
    }

    inline void ApplyForceToEntity(Entity entity, float x, float y, float z)
    {
        invoke<Void>(0xC5F68BE9613E2D18, entity, 1, x, y, z,
            0.0f, 0.0f, 0.0f, 0, FALSE, TRUE, TRUE, FALSE, TRUE);
    }

    inline Vector3 GetGameplayCamCoord()
    {
        return invoke<Vector3>(0x14D6F5678D8F1B37);
    }

    inline Vector3 GetGameplayCamRot(int order)
    {
        return invoke<Vector3>(0x837765A25378F0BB, order);
    }

    inline int StartShapeTestLosProbe(float x1, float y1, float z1,
        float x2, float y2, float z2, int flags, Entity ignore)
    {
        return invoke<int>(0x377906D8A31E5586,
            x1, y1, z1, x2, y2, z2, flags, ignore, 7);
    }

    inline int GetShapeTestResult(int handle, BOOL* hit, Vector3* end,
        Vector3* normal, Entity* entity)
    {
        return invoke<int>(0x3D87450E15D98694, handle, hit, end, normal, entity);
    }

    inline void DrawLine(float x1, float y1, float z1,
        float x2, float y2, float z2, int red, int green, int blue, int alpha)
    {
        invoke<Void>(0x6B7256074AE34680,
            x1, y1, z1, x2, y2, z2, red, green, blue, alpha);
    }
}
