//
//  Tweakables.swift
//  PhysicsPlayground
//
//  ★★★ START HERE! ★★★
//
//  This file is YOURS to play with. Every value below changes how the
//  playground behaves. Change a number, press the Run button (▶) in Xcode,
//  and watch what happens. You cannot break anything permanently — if it
//  all goes wrong, just change the values back (or ask Xcode to undo, ⌘Z).
//
//  A few Swift words you'll see:
//    • `static let` means "a fixed value with a name". The app reads these
//      names instead of having magic numbers scattered everywhere.
//    • `Float` is a decimal number (like 0.5 or -9.8).
//    • `[a, b, c]` is a list (Swift calls it an Array).
//    • `SIMD3<Float>` is just three Floats packed together — perfect for
//      3D things like gravity, which has an x, y and z direction.
//

import RealityKit
import UIKit

/// The different shapes the playground knows how to make.
/// Want to add your own? See Challenge 3.1 in CHALLENGES.md!
enum ShapeKind: String, CaseIterable {
    case cube
    case sphere
    case cylinder
    case cone
}

enum Tweakables {

    // MARK: - The world 🌍

    /// Gravity, in metres per second squared, as [x, y, z].
    /// The y value is "up and down": negative = pulls things DOWN.
    ///   • Earth is [0, -9.8, 0]
    ///   • The Moon is [0, -1.6, 0]  (try it — everything goes floaty!)
    ///   • Jupiter is [0, -24.8, 0]
    ///   • [0, +3.0, 0] makes things FALL UPWARDS. Chaos. Recommended.
    /// (There's also a gravity slider in the control panel for quick
    ///  experiments — this value is just the starting point.)
    static let gravity: SIMD3<Float> = [0, -9.8, 0]

    /// Should the floor plate be visible? Set to false for an "invisible
    /// trampoline" look where shapes bounce on nothing.
    static let floorIsVisible = true

    /// The colour of the floor plate. Try .systemPink, .systemPurple,
    /// .black, or any other UIColor.
    static let floorColor: UIColor = .systemTeal

    // MARK: - The shapes 🎲

    /// Which shapes can spawn. Delete some to only get your favourites,
    /// e.g. [.sphere] for a ball pit!
    static let enabledShapes: [ShapeKind] = [.cube, .sphere, .cylinder, .cone]

    /// Every new shape picks a random size from this range, in METRES.
    /// (0.06 is about the size of a tennis ball.)
    /// Try 0.2...0.3 for boulders, or 0.01...0.03 for confetti.
    static let shapeSize: ClosedRange<Float> = 0.06...0.14

    /// The colours shapes can be. Add or remove any UIColor you like —
    /// try .magenta, .cyan, or even .brown.
    static let shapeColors: [UIColor] = [
        .systemRed, .systemOrange, .systemYellow,
        .systemGreen, .systemBlue, .systemPurple,
    ]

    /// true = shiny metal shapes, false = matte plastic shapes.
    static let metallicShapes = false

    /// How BOUNCY shapes are, from 0 to 1.
    ///   0.0 = lands like a beanbag (no bounce at all)
    ///   0.6 = a decent rubber ball
    ///   1.0 = never loses energy
    ///   Above 1.0 = gains energy every bounce. Trampoline madness. 😈
    /// (The control panel slider changes this live for NEW shapes.)
    static let bounciness: Float = 0.6

    /// How much shapes grip each other and the floor, 0 to 1.
    /// 0 = everything slides around like ice. 1 = very grippy.
    static let friction: Float = 0.5

    /// How heavy each shape is, in kilograms.
    /// Heavier shapes barge lighter ones out of the way.
    static let mass: Float = 1.0

    // MARK: - Spawning ✨

    /// How many shapes appear per press of the Spawn button.
    /// Try 10. You know you want to.
    static let spawnCountPerTap = 1

    /// How high above the centre of the playground new shapes appear,
    /// in metres. (The playground box is 1 metre tall, so keep this
    /// below about 0.4 or shapes will start inside the ceiling.)
    static let spawnHeight: Float = 0.35

    /// The most shapes allowed at once. When you spawn more than this,
    /// the OLDEST shapes quietly disappear to make room. Raising it a lot
    /// may make the app run slowly — that's a real lesson in performance!
    static let maxShapesInPlayground = 60

    // MARK: - Poking things 👆

    /// How hard a shape gets flicked when you tap it.
    /// 1.5 is a friendly nudge. 10 is a golf swing.
    static let tapFlickStrength: Float = 1.5
}
