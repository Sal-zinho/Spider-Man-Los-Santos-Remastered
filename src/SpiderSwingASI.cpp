// Spider-Man: Los Santos — Remastered Edition
// GTA V Legacy Story Mode traversal prototype. Melty/native-adapter build.
// This file contains original gameplay code and no game assets.
#include <Windows.h>
#include <cmath>
#include "native_api.hpp"

namespace
{
    constexpr int kKeyToggle = VK_F7;
    constexpr int kKeyWeb = VK_F8;
    constexpr float kMaxWebDistance = 150.0f;
    constexpr float kSwingAcceleration = 16.0f;

    bool g_enabled = false;
    bool g_attached = false;
    bool g_prevToggle = false;
    bool g_prevWeb = false;
    Vector3 g_anchor = { 0.0f, 0, 0.0f, 0, 0.0f, 0 };
    float g_ropeLength = 0.0f;

    bool KeyPressedEdge(int key, bool& previous)
    {
        const bool down = (GetAsyncKeyState(key) & 0x8000) != 0;
        const bool edge = down && !previous;
        previous = down;
        return edge;
    }

    Vector3 Add(Vector3 a, Vector3 b)
    {
        return { a.x + b.x, 0, a.y + b.y, 0, a.z + b.z, 0 };
    }

    Vector3 Sub(Vector3 a, Vector3 b)
    {
        return { a.x - b.x, 0, a.y - b.y, 0, a.z - b.z, 0 };
    }

    Vector3 Mul(Vector3 a, float s)
    {
        return { a.x * s, 0, a.y * s, 0, a.z * s, 0 };
    }

    float Dot(Vector3 a, Vector3 b)
    {
        return a.x*b.x + a.y*b.y + a.z*b.z;
    }

    float Length(Vector3 a)
    {
        return std::sqrt(Dot(a, a));
    }

    Vector3 Normalize(Vector3 a)
    {
        const float n = Length(a);
        return n > 0.0001f ? Mul(a, 1.0f / n) : Vector3{ 0, 0, 0, 0, 0, 0 };
    }

    Vector3 CameraForward()
    {
        const Vector3 rot = gta::GetGameplayCamRot(2);
        const float pitch = rot.x * 0.01745329252f;
        const float yaw = rot.z * 0.01745329252f;
        const float cp = std::cos(pitch);
        return Normalize({ -std::sin(yaw) * std::abs(cp), 0,
            std::cos(yaw) * std::abs(cp), 0, std::sin(pitch), 0 });
    }

    bool TryFindAnchor(Ped player, Vector3& anchor)
    {
        const Vector3 origin = gta::GetGameplayCamCoord();
        const Vector3 end = Add(origin, Mul(CameraForward(), kMaxWebDistance));
        const int ray = gta::StartShapeTestLosProbe(
            origin.x, origin.y, origin.z, end.x, end.y, end.z, -1, player);

        BOOL hit = FALSE;
        Vector3 hitPosition = { 0, 0, 0, 0, 0, 0 };
        Vector3 surfaceNormal = { 0, 0, 0, 0, 0, 0 };
        Entity hitEntity = 0;
        int result = 1;

        // Shape tests complete asynchronously; yield the mod fiber briefly.
        for (int frame = 0; frame < 12 && result == 1; ++frame)
        {
            WAIT(0);
            result = gta::GetShapeTestResult(
                ray, &hit, &hitPosition, &surfaceNormal, &hitEntity);
        }

        if (result != 2 || !hit)
            return false;

        if (Length(Sub(hitPosition, gta::GetEntityCoords(player, TRUE))) < 4.0f)
            return false;

        anchor = hitPosition;
        return true;
    }

    void ReleaseWeb()
    {
        g_attached = false;
        g_ropeLength = 0.0f;
    }

    void TickSwing(Ped player)
    {
        if (!g_attached)
            return;

        const Vector3 position = gta::GetEntityCoords(player, TRUE);
        const Vector3 offset = Sub(position, g_anchor);
        const float distance = Length(offset);

        if (distance < 0.5f || distance > kMaxWebDistance * 1.2f)
        {
            ReleaseWeb();
            return;
        }

        const Vector3 hand = Add(position, Vector3{ 0.0f, 0, 0.85f, 0, 0.0f, 0 });
        gta::DrawLine(hand.x, hand.y, hand.z,
            g_anchor.x, g_anchor.y, g_anchor.z, 225, 245, 255, 235);

        const Vector3 outward = Normalize(offset);
        Vector3 velocity = gta::GetEntityVelocity(player);
        const float radialSpeed = Dot(velocity, outward);

        if (distance >= g_ropeLength && radialSpeed > 0.0f)
        {
            velocity = Sub(velocity, Mul(outward, radialSpeed));
            gta::SetEntityVelocity(player, velocity.x, velocity.y, velocity.z);
        }

        const float stretch = distance - g_ropeLength;
        if (stretch > 0.0f)
        {
            const float pull = (stretch * 5.0f) +
                (radialSpeed > 0.0f ? radialSpeed * 1.5f : 0.0f);
            const Vector3 towardAnchor = Mul(outward, -pull);
            gta::ApplyForceToEntity(player,
                towardAnchor.x, towardAnchor.y, towardAnchor.z);
        }

        Vector3 forward = CameraForward();
        forward = Sub(forward, Mul(outward, Dot(forward, outward)));
        forward = Normalize(forward);

        if ((GetAsyncKeyState('W') & 0x8000) != 0 ||
            (GetAsyncKeyState(VK_UP) & 0x8000) != 0)
        {
            const Vector3 drive = Mul(forward, kSwingAcceleration);
            gta::ApplyForceToEntity(player, drive.x, drive.y, drive.z);
        }
    }

    void ScriptMain()
    {
        while (true)
        {
            WAIT(0);
            const Ped player = gta::PlayerPedId();
            if (!gta::DoesEntityExist(player))
                continue;

            if (KeyPressedEdge(kKeyToggle, g_prevToggle))
            {
                g_enabled = !g_enabled;
                if (!g_enabled)
                    ReleaseWeb();
            }

            if (g_enabled && KeyPressedEdge(kKeyWeb, g_prevWeb))
            {
                if (g_attached)
                {
                    ReleaseWeb();
                }
                else
                {
                    Vector3 candidate = { 0, 0, 0, 0, 0, 0 };
                    if (TryFindAnchor(player, candidate))
                    {
                        g_anchor = candidate;
                        g_ropeLength = Length(Sub(
                            gta::GetEntityCoords(player, TRUE), g_anchor));
                        g_attached = g_ropeLength > 4.0f &&
                            g_ropeLength < kMaxWebDistance;
                    }
                }
            }

            if (g_enabled)
                TickSwing(player);
        }
    }
}

BOOL APIENTRY DllMain(HMODULE module, DWORD reason, LPVOID)
{
    if (reason == DLL_PROCESS_ATTACH)
    {
        DisableThreadLibraryCalls(module);
        native_runtime::start(module, ScriptMain, nullptr);
    }
    else if (reason == DLL_PROCESS_DETACH)
    {
        native_runtime::stop();
    }
    return TRUE;
}
