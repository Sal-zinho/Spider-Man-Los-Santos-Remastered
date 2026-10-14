import sys
import unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))
from traversal_physics import SwingState, Vec3

class TraversalPhysicsTests(unittest.TestCase):
    def test_attach_constrains_rope_length(self):
        state = SwingState(Vec3(10, 0, 0), Vec3(0, 2, 0))
        state.attach(Vec3(0, 0, 0), 8)
        self.assertAlmostEqual((state.position-state.anchor).length(), 8.0, places=6)

    def test_rope_length_stays_constant_during_swing(self):
        state = SwingState(Vec3(0, 0, -10), Vec3(12, 0, 0))
        state.attach(Vec3(0, 0, 0), 10)
        for _ in range(500):
            state.step(1/120, forward=Vec3(1, 0, 0))
            self.assertAlmostEqual((state.position-state.anchor).length(), 10.0, places=5)

    def test_release_preserves_velocity(self):
        state = SwingState(Vec3(0, 0, -10), Vec3(5, 1, 0))
        state.attach(Vec3(0, 0, 0), 10)
        state.step(1/60, forward=Vec3(1, 0, 0))
        before = state.velocity
        after = state.release()
        self.assertFalse(state.attached)
        self.assertEqual(after, before)

    def test_free_fall_moves_without_anchor(self):
        state = SwingState(Vec3(), Vec3())
        state.step(0.05)
        self.assertLess(state.position.z, 0)
        self.assertFalse(state.attached)

if __name__ == '__main__':
    unittest.main(verbosity=2)
