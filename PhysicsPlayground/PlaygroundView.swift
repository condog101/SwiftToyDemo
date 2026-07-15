//
//  PlaygroundView.swift
//  PhysicsPlayground
//
//  This is the 3D playground itself — the view inside the volumetric
//  window. It uses RealityView, which is the bridge between SwiftUI
//  (buttons, windows) and RealityKit (3D entities, physics).
//
//  The big ideas here:
//    1. We build the scene ONCE (the room + an empty "shapes" container).
//    2. When you press buttons in the control panel, `.onChange(...)`
//       blocks below react and add/remove/poke entities.
//    3. Gestures let you grab shapes (drag) and flick them (tap).
//

import SwiftUI
import RealityKit

struct PlaygroundView: View {

    /// The shared settings object (sliders, buttons) from the control panel.
    @Environment(PlaygroundSettings.self) private var settings

    /// The size of the playground box, in metres.
    /// (Must match the .defaultSize of the "playground" window in
    ///  PhysicsPlaygroundApp.swift — that's what sets the visible volume.)
    private let boxWidth: Float = 1.0
    private let boxHeight: Float = 1.0
    private let boxDepth: Float = 1.0

    /// The entity at the top of our scene. Everything lives inside it.
    @State private var rootEntity = Entity()

    /// A container just for the spawned shapes, so counting and clearing
    /// them is easy (we never accidentally delete the floor!).
    @State private var shapesContainer = Entity()

    /// Remembers what a shape's physics was doing before we grabbed it.
    @State private var draggedEntity: ModelEntity? = nil

    var body: some View {
        RealityView { content in
            // ----- This closure runs ONCE, when the window opens. -----

            // The PhysicsSimulationComponent is the "physics engine
            // settings" for everything inside rootEntity — most
            // importantly, which way gravity points.
            var simulation = PhysicsSimulationComponent()
            simulation.gravity = [0, settings.gravityY, 0]
            rootEntity.components.set(simulation)

            // Build the floor + invisible walls (see ShapeFactory.swift).
            rootEntity.addChild(
                ShapeFactory.makeRoom(width: boxWidth, height: boxHeight, depth: boxDepth)
            )

            shapesContainer.name = "shapesContainer"
            rootEntity.addChild(shapesContainer)

            content.add(rootEntity)
        }
        // ----- Reacting to the control panel -----

        // "When the spawn counter changes, spawn some shapes."
        .onChange(of: settings.spawnRequestID) {
            spawnShapes(count: settings.spawnCount)
        }
        // "When the reset counter changes, clear the playground."
        .onChange(of: settings.resetRequestID) {
            // Copy the list first — never delete from a list while
            // walking through it!
            for shape in Array(shapesContainer.children) {
                shape.removeFromParent()
            }
            settings.shapeCount = 0
        }
        // "When the gravity slider moves, update the physics engine."
        .onChange(of: settings.gravityY) {
            if var simulation = rootEntity.components[PhysicsSimulationComponent.self] {
                simulation.gravity = [0, settings.gravityY, 0]
                rootEntity.components.set(simulation)
            }
        }

        // ----- Gestures -----

        // TAP a shape to flick it upwards (with a bit of random sideways spin
        // so it feels alive).
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    guard let shape = value.entity as? ModelEntity,
                          shape.name == "shape" else { return }
                    let kick = Tweakables.tapFlickStrength
                    let impulse: SIMD3<Float> = [
                        Float.random(in: -0.3...0.3) * kick,  // random sideways nudge
                        kick,                                  // mostly upwards
                        Float.random(in: -0.3...0.3) * kick,
                    ]
                    // An "impulse" is a sudden shove — like a kick.
                    shape.applyLinearImpulse(impulse, relativeTo: nil)
                }
        )
        // DRAG a shape to carry it around, then let go to drop it.
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    guard let shape = value.entity as? ModelEntity,
                          shape.name == "shape" else { return }

                    // While being carried, the shape must ignore gravity —
                    // otherwise it fights your hand. ".kinematic" means
                    // "moved by code, not by physics".
                    if draggedEntity !== shape {
                        draggedEntity = shape
                        if var physicsBody = shape.components[PhysicsBodyComponent.self] {
                            physicsBody.mode = .kinematic
                            shape.components.set(physicsBody)
                        }
                    }

                    // The gesture gives us a position in "view" coordinates;
                    // convert it into the shape's parent's coordinate space
                    // so we can move the shape there.
                    var target = value.convert(value.location3D, from: .local, to: shape.parent!)

                    // Keep it inside the box (leave a small margin so it
                    // doesn't get pushed inside a wall).
                    let margin: Float = 0.08
                    target.x = min(max(target.x, -boxWidth / 2 + margin), boxWidth / 2 - margin)
                    target.y = min(max(target.y, -boxHeight / 2 + margin), boxHeight / 2 - margin)
                    target.z = min(max(target.z, -boxDepth / 2 + margin), boxDepth / 2 - margin)

                    shape.position = target
                }
                .onEnded { _ in
                    // Let go: hand control back to the physics engine.
                    if let shape = draggedEntity,
                       var physicsBody = shape.components[PhysicsBodyComponent.self] {
                        physicsBody.mode = .dynamic
                        shape.components.set(physicsBody)
                        // CHALLENGE 4.1: throw the shape by giving it the
                        // velocity your hand was moving at. See CHALLENGES.md!
                    }
                    draggedEntity = nil
                }
        )
    }

    // MARK: - Spawning

    /// Creates `count` new shapes near the top of the box, each with a
    /// random kind, size, colour and position.
    private func spawnShapes(count: Int) {
        for _ in 0..<count {
            let kind = Tweakables.enabledShapes.randomElement() ?? .cube
            let size = Float.random(in: Tweakables.shapeSize)
            let color = Tweakables.shapeColors.randomElement() ?? .systemPink

            let shape = ShapeFactory.makeShape(
                kind: kind,
                size: size,
                color: color,
                bounciness: settings.bounciness
            )

            // A random spot near the top, so shapes rain down.
            shape.position = [
                Float.random(in: -0.3...0.3),
                Tweakables.spawnHeight,
                Float.random(in: -0.3...0.3),
            ]

            shapesContainer.addChild(shape)
        }

        // Too many shapes? Quietly remove the oldest ones.
        // (children are stored oldest-first, so we trim from the front.)
        while shapesContainer.children.count > Tweakables.maxShapesInPlayground,
              let oldest = shapesContainer.children.first {
            oldest.removeFromParent()
        }

        settings.shapeCount = shapesContainer.children.count
    }
}
