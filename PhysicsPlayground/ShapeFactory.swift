//
//  ShapeFactory.swift
//  PhysicsPlayground
//
//  A "factory" is just a piece of code whose job is to BUILD things.
//  This one builds the 3D objects in our playground:
//    • makeShape(...) builds one falling shape (cube, sphere, ...)
//    • makeRoom(...)  builds the floor and the invisible walls
//
//  In RealityKit, everything in a 3D scene is an "Entity". You give an
//  entity abilities by attaching "Components" — like giving a LEGO
//  minifigure different accessories:
//    • ModelComponent      = what it LOOKS like (mesh + material)
//    • CollisionComponent  = its SOLID outline, for bumping into things
//    • PhysicsBodyComponent = makes gravity and bouncing apply to it
//    • InputTargetComponent = lets fingers/taps interact with it
//    • HoverEffectComponent = makes it glow when you look at it
//

import RealityKit
import UIKit

enum ShapeFactory {

    // MARK: - Making one shape

    /// Builds one physics shape, ready to drop into the playground.
    /// - Parameters:
    ///   - kind: cube, sphere, cylinder or cone (see ShapeKind in Tweakables.swift)
    ///   - size: roughly its width/diameter in metres
    ///   - color: what colour to paint it
    ///   - bounciness: 0 = beanbag, 1 = superball
    static func makeShape(
        kind: ShapeKind,
        size: Float,
        color: UIColor,
        bounciness: Float
    ) -> ModelEntity {

        // 1. The MESH is the 3D geometry — the actual triangles drawn on
        //    screen. RealityKit can generate simple ones for us.
        let mesh: MeshResource
        // The COLLISION SHAPE is the invisible "solid" outline used by the
        // physics engine. It's usually simpler than the visible mesh, to
        // keep the maths fast.
        let collisionShape: ShapeResource

        switch kind {
        case .cube:
            mesh = MeshResource.generateBox(size: size, cornerRadius: size * 0.05)
            collisionShape = ShapeResource.generateBox(size: [size, size, size])
        case .sphere:
            mesh = MeshResource.generateSphere(radius: size / 2)
            collisionShape = ShapeResource.generateSphere(radius: size / 2)
        case .cylinder:
            mesh = MeshResource.generateCylinder(height: size, radius: size / 2)
            // There's no ready-made cylinder collision shape, so we ask
            // RealityKit to shrink-wrap the mesh in a "convex hull" —
            // imagine cling film stretched tightly around the shape.
            collisionShape = ShapeResource.generateConvex(from: mesh)
        case .cone:
            mesh = MeshResource.generateCone(height: size, radius: size / 2)
            collisionShape = ShapeResource.generateConvex(from: mesh)
        }

        // 2. The MATERIAL is the paint job: colour + shininess.
        let material = SimpleMaterial(color: color, isMetallic: Tweakables.metallicShapes)

        // 3. Put mesh + material together into an entity we can see.
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.name = "shape"   // we use this label later to count/remove shapes

        // 4. Give it a solid outline so it can bump into things.
        entity.components.set(CollisionComponent(shapes: [collisionShape]))

        // 5. Give it a physics body so gravity pulls it and bounces happen.
        //    The "physics material" is its surface feel: grip + bounce.
        let surface = PhysicsMaterialResource.generate(
            staticFriction: Tweakables.friction,
            dynamicFriction: Tweakables.friction,
            restitution: bounciness          // "restitution" = physics-speak for bounciness
        )
        entity.components.set(PhysicsBodyComponent(
            // The mass properties describe how heavy the shape is and how
            // it spins — RealityKit works that out from the collision shape.
            massProperties: .init(shape: collisionShape, mass: Tweakables.mass),
            material: surface,
            mode: .dynamic                   // .dynamic = "moves freely under physics"
        ))

        // 6. Let hands/taps interact with it, and make it glow on look/hover.
        entity.components.set(InputTargetComponent())
        entity.components.set(HoverEffectComponent())

        return entity
    }

    // MARK: - Making the room

    /// Builds the "room": a visible floor plate plus five INVISIBLE static
    /// walls (left, right, back, front, ceiling) so shapes stay inside the
    /// playground box instead of falling out into your actual room.
    ///
    /// The playground volume is `width` × `height` × `depth` metres, and
    /// its coordinate origin (0, 0, 0) is the CENTRE of the box. So the
    /// floor sits at y = -height/2, and the ceiling at y = +height/2.
    static func makeRoom(width: Float, height: Float, depth: Float) -> Entity {
        let room = Entity()
        room.name = "room"

        let wallThickness: Float = 0.1

        // --- The floor you can see ---
        if Tweakables.floorIsVisible {
            let plate = ModelEntity(
                mesh: .generateBox(width: width * 0.95, height: 0.02, depth: depth * 0.95, cornerRadius: 0.01),
                // withAlphaComponent makes the colour see-through (0 = invisible, 1 = solid)
                materials: [SimpleMaterial(color: Tweakables.floorColor.withAlphaComponent(0.4), isMetallic: false)]
            )
            plate.name = "floorPlate"
            plate.position = [0, -height / 2 + 0.01, 0]
            room.addChild(plate)
        }

        // --- The invisible solid surfaces ---
        // Fun fact: an Entity with a CollisionComponent but NO ModelComponent
        // is solid but draws nothing — a perfect invisible wall.
        // Each wall is a thick slab placed just OUTSIDE the box edge, so its
        // inner face lines up exactly with the edge of the playground.
        func invisibleSlab(size: SIMD3<Float>, position: SIMD3<Float>, name: String) -> Entity {
            let slab = Entity()
            slab.name = name
            slab.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: size)]))
            // .static = "never moves, but things can bump into it"
            slab.components.set(PhysicsBodyComponent(
                massProperties: .default,
                material: PhysicsMaterialResource.generate(
                    staticFriction: Tweakables.friction,
                    dynamicFriction: Tweakables.friction,
                    restitution: Tweakables.bounciness
                ),
                mode: .static
            ))
            slab.position = position
            return slab
        }

        let w = width, h = height, d = depth, t = wallThickness

        // The physics floor's TOP surface lines up with the top of the
        // visible plate (2 cm above the bottom of the box), so shapes rest
        // ON the plate instead of sinking into it.
        room.addChild(invisibleSlab(size: [w, t, d], position: [0, -h / 2 + 0.02 - t / 2, 0], name: "floor"))
        room.addChild(invisibleSlab(size: [w, t, d], position: [0, h / 2 + t / 2, 0], name: "ceiling"))
        room.addChild(invisibleSlab(size: [t, h, d], position: [-w / 2 - t / 2, 0, 0], name: "leftWall"))
        room.addChild(invisibleSlab(size: [t, h, d], position: [w / 2 + t / 2, 0, 0], name: "rightWall"))
        room.addChild(invisibleSlab(size: [w, h, t], position: [0, 0, -d / 2 - t / 2], name: "backWall"))
        room.addChild(invisibleSlab(size: [w, h, t], position: [0, 0, d / 2 + t / 2], name: "frontWall"))

        return room
    }
}
