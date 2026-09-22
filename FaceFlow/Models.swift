import Foundation

struct Exercise: Identifiable, Hashable {
    let id: String
    let name: String
    let category: Goal
    let difficulty: String
    let defaultDuration: Int
    let icon: String
    let instructions: String
    let voiceScript: [String]
    let tags: [String]
}

struct RoutineExercise: Identifiable, Hashable {
    let id = UUID()
    let exercise: Exercise
    let duration: Int
}

struct Routine: Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let durationMinutes: Int
    let exercises: [RoutineExercise]
    let isPremium: Bool
}

enum ExerciseLibrary {
    static let all: [Exercise] = [
        Exercise(id: "shoulder_release", name: "Shoulder Release", category: .neck, difficulty: "Beginner", defaultDuration: 40, icon: "figure.arms.open", instructions: "Let your shoulders drop away from your ears. Keep your breathing easy and your movement slow.", voiceScript: ["Relax your shoulders.", "Let them soften away from your ears.", "Keep breathing normally."], tags: ["neck", "relaxation", "beginner"]),
        Exercise(id: "jaw_release", name: "Jaw Release", category: .jaw, difficulty: "Beginner", defaultDuration: 60, icon: "face.smiling", instructions: "Relax your jaw and allow a comfortable, gentle opening. Never force the movement.", voiceScript: ["Relax your shoulders.", "Let your jaw loosen gently.", "Keep the movement comfortable.", "And release."], tags: ["jaw", "relaxation", "beginner"]),
        Exercise(id: "neck_glide", name: "Neck Glide", category: .neck, difficulty: "Beginner", defaultDuration: 60, icon: "arrow.up.and.down.circle", instructions: "Move your head slowly through a comfortable range. Keep your shoulders relaxed.", voiceScript: ["Keep your shoulders relaxed.", "Move slowly through a comfortable range.", "No need to force the movement."], tags: ["neck", "mobility", "beginner"]),
        Exercise(id: "cheek_relaxation", name: "Cheek Relaxation", category: .fullFace, difficulty: "Beginner", defaultDuration: 45, icon: "face.smiling", instructions: "Soften your cheeks and facial muscles while breathing comfortably.", voiceScript: ["Soften your cheeks.", "Let the rest of your face relax.", "Breathe comfortably."], tags: ["cheeks", "relaxation"]),
        Exercise(id: "face_breathing", name: "Face Breathing", category: .relaxation, difficulty: "Beginner", defaultDuration: 80, icon: "wind", instructions: "Breathe slowly and use the exhale as a cue to soften your face and shoulders.", voiceScript: ["Take a slow breath in.", "Exhale and soften your face.", "Let your shoulders relax.", "Stay comfortable."], tags: ["relaxation", "beginner"]),
        Exercise(id: "brow_softening", name: "Brow Softening", category: .forehead, difficulty: "Beginner", defaultDuration: 45, icon: "face.smiling", instructions: "Notice tension around the brow and gently let it soften.", voiceScript: ["Notice your brow.", "Let the area soften.", "Keep your expression comfortable."], tags: ["forehead", "relaxation"]),
        Exercise(id: "temple_relax", name: "Temple Relax", category: .forehead, difficulty: "Beginner", defaultDuration: 45, icon: "circle.dotted", instructions: "Use gentle, comfortable fingertip movements around the temples. Stop if anything feels uncomfortable.", voiceScript: ["Use gentle movements.", "Keep the pressure light.", "Stay comfortable."], tags: ["forehead", "relaxation"]),
        Exercise(id: "eye_rest", name: "Eye Rest", category: .eyes, difficulty: "Beginner", defaultDuration: 45, icon: "eye", instructions: "Close or soften your gaze and let the muscles around your eyes relax.", voiceScript: ["Soften your gaze.", "Let the area around your eyes relax.", "Breathe slowly."], tags: ["eyes", "relaxation"]),
        Exercise(id: "slow_blink", name: "Slow Blink", category: .eyes, difficulty: "Beginner", defaultDuration: 40, icon: "eye", instructions: "Blink slowly and comfortably. Avoid squeezing the eyes.", voiceScript: ["Blink slowly.", "Keep it gentle.", "Let your eyes rest."], tags: ["eyes", "beginner"]),
        Exercise(id: "chin_release", name: "Chin Release", category: .jaw, difficulty: "Beginner", defaultDuration: 50, icon: "person.crop.circle", instructions: "Keep your head neutral and allow the chin and jaw area to soften.", voiceScript: ["Keep your head centered.", "Let the chin area soften.", "Breathe normally."], tags: ["jaw", "beginner"]),
        Exercise(id: "lower_face_reset", name: "Lower Face Reset", category: .jaw, difficulty: "Beginner", defaultDuration: 60, icon: "face.smiling", instructions: "Relax the lower face and move gently without forcing any range.", voiceScript: ["Relax your lower face.", "Keep the movement small and comfortable.", "Release."], tags: ["jaw", "full-face"]),
        Exercise(id: "side_neck_release", name: "Side Neck Release", category: .neck, difficulty: "Beginner", defaultDuration: 50, icon: "figure.stand", instructions: "Gently tilt your head within a comfortable range. Keep shoulders down.", voiceScript: ["Keep your shoulders down.", "Gently move to one side.", "Return to center.", "Switch sides."], tags: ["neck", "beginner"]),
        Exercise(id: "posture_reset", name: "Posture Reset", category: .neck, difficulty: "Beginner", defaultDuration: 45, icon: "figure.stand", instructions: "Sit or stand comfortably. Lengthen through the top of your head without stiffening.", voiceScript: ["Find a comfortable posture.", "Lengthen gently through the top of your head.", "Relax your shoulders."], tags: ["neck", "posture"]),
        Exercise(id: "forehead_reset", name: "Forehead Reset", category: .forehead, difficulty: "Beginner", defaultDuration: 50, icon: "face.smiling", instructions: "Relax the forehead and let the brow rest in a neutral position.", voiceScript: ["Relax your forehead.", "Let your brow rest.", "Keep your expression neutral and comfortable."], tags: ["forehead", "relaxation"]),
        Exercise(id: "eye_focus_reset", name: "Eye Focus Reset", category: .eyes, difficulty: "Beginner", defaultDuration: 50, icon: "eye", instructions: "Look comfortably ahead, then soften your gaze. Do not strain to focus.", voiceScript: ["Look comfortably ahead.", "Soften your gaze.", "Let your eyes rest."], tags: ["eyes"]),
        Exercise(id: "full_face_scan", name: "Full Face Scan", category: .fullFace, difficulty: "Beginner", defaultDuration: 60, icon: "face.smiling.inverse", instructions: "Scan from forehead to jaw and release areas of unnecessary tension.", voiceScript: ["Start at your forehead.", "Move your attention to your eyes.", "Soften your cheeks and jaw.", "Finish with an easy breath."], tags: ["full-face", "relaxation"]),
        Exercise(id: "smile_release", name: "Smile Release", category: .fullFace, difficulty: "Beginner", defaultDuration: 45, icon: "face.smiling", instructions: "Make a small comfortable smile, then release it completely.", voiceScript: ["Make a small comfortable smile.", "Hold gently.", "Now release and relax."], tags: ["full-face"]),
        Exercise(id: "evening_soften", name: "Evening Soften", category: .relaxation, difficulty: "Beginner", defaultDuration: 60, icon: "moon.stars", instructions: "Use slow breathing and a relaxed expression to wind down.", voiceScript: ["Slow your breathing.", "Soften your face.", "Let your shoulders drop.", "Take one more easy breath."], tags: ["relaxation", "evening"]),
        Exercise(id: "morning_wake", name: "Morning Wake-Up", category: .fullFace, difficulty: "Beginner", defaultDuration: 60, icon: "sun.max", instructions: "Use gentle facial movement to bring awareness to your face and neck.", voiceScript: ["Take a comfortable breath.", "Bring gentle movement to your face.", "Keep your neck relaxed.", "You're ready to begin your day."], tags: ["morning", "full-face"]),
        Exercise(id: "final_relaxation", name: "Final Relaxation", category: .relaxation, difficulty: "Beginner", defaultDuration: 60, icon: "sparkles", instructions: "Finish by relaxing the entire face, jaw and neck.", voiceScript: ["Let your whole face soften.", "Relax your jaw.", "Relax your neck.", "Take one calm breath."], tags: ["relaxation", "beginner"])
    ]
}

@MainActor
enum RoutineGenerator {
    static func generate(goals: Set<Goal>, duration: Int, experience: Experience) -> Routine {
        let target = max(3, duration * 60)
        let requested = goals.isEmpty ? [.fullFace, .relaxation] : Array(goals)
        var candidates: [Exercise] = []

        for goal in requested {
            candidates += ExerciseLibrary.all.filter { $0.category == goal || $0.tags.contains(goal.rawValue) }
        }

        if candidates.isEmpty {
            candidates = ExerciseLibrary.all
        }

        var unique: [Exercise] = []
        for exercise in candidates {
            if !unique.contains(exercise) { unique.append(exercise) }
        }

        let fallback = ExerciseLibrary.all.filter { !unique.contains($0) }
        unique += fallback

        var selected: [RoutineExercise] = []
        var remaining = target
        var index = 0

        while remaining > 0 && index < unique.count {
            let exercise = unique[index]
            let durationForExercise = min(exercise.defaultDuration, max(30, remaining))
            selected.append(RoutineExercise(exercise: exercise, duration: durationForExercise))
            remaining -= durationForExercise
            index += 1
            if selected.count >= 8 { break }
        }

        if selected.isEmpty {
            selected = [RoutineExercise(exercise: ExerciseLibrary.all[0], duration: min(40, target))]
        }

        let actual = Int(round(Double(selected.reduce(0) { $0 + $1.duration }) / 60.0))
        let title = requested.contains(.jaw) ? "Jaw & Neck Reset" :
            requested.contains(.relaxation) ? "Daily Relaxation Ritual" : "Full Face Reset"

        return Routine(
            id: UUID(),
            name: title,
            description: "A short guided routine built from your selected goals.",
            durationMinutes: max(1, actual),
            exercises: selected,
            isPremium: false
        )
    }
}
