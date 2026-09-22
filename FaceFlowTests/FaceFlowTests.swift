import XCTest
@testable import FaceFlow

final class FaceFlowTests: XCTestCase {
    @MainActor
    func testRoutineGeneratorCreatesRoutine() {
        let routine = RoutineGenerator.generate(
            goals: [.jaw, .neck],
            duration: 5,
            experience: .beginner
        )
        XCTAssertFalse(routine.exercises.isEmpty)
        XCTAssertGreaterThan(routine.durationMinutes, 0)
    }

    @MainActor
    func testExerciseLibraryHasTwentyExercises() {
        XCTAssertEqual(ExerciseLibrary.all.count, 20)
    }
}
