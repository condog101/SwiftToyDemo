# 🏆 Challenges

Work through these in order — they get harder as you go. For each one:
make the change, press **▶ Run**, and check it against
*"You know it works when…"*.

Stuck? ⌘Z undoes your edits, and `git checkout .` in Terminal restores
everything to the original.

---

## Level 1 — Change a number 🟢

*No new code — just edit values in `Tweakables.swift`.*

### 1.1 Moon gravity
**Goal:** make everything fall slowly, like on the Moon.
**Hint:** find `gravity` in `Tweakables.swift`. The Moon pulls at 1.6 m/s².
**You know it works when…** spawned shapes drift down lazily and bounce
in slow motion.

### 1.2 Boulder mode
**Goal:** make the shapes big.
**Hint:** `shapeSize` is a *range* — the app picks a random size between
the two numbers. Try `0.2...0.3`.
**You know it works when…** three or four shapes fill the whole cube.

### 1.3 Shape confetti
**Goal:** 10 shapes per press of the Spawn button.
**Hint:** `spawnCountPerTap`.
**You know it works when…** one press makes it rain.

### 1.4 Your colours
**Goal:** change the palette — maybe your favourite football team's
colours, or all pinks.
**Hint:** edit the `shapeColors` list. Try `.systemPink`, `.magenta`,
`.cyan`, `.white`, `.black`…
**You know it works when…** every new shape uses only your colours.

---

## Level 2 — Change a line or two 🟡

### 2.1 Trampoline world
**Goal:** shapes that gain energy with every bounce.
**Hint:** `bounciness` above `1.0` means each bounce is bigger than the
last. Try `1.1`. (Physics fans: why is this impossible in real life?
Where would the extra energy come from?)
**You know it works when…** the cube gradually turns into popcorn.

### 2.2 Metal shapes
**Goal:** shiny chrome shapes instead of matte plastic.
**Hint:** one `true`/`false` in `Tweakables.swift` controls this.
**You know it works when…** shapes reflect light like metal.

### 2.3 Ball pit
**Goal:** only spheres spawn.
**Hint:** `enabledShapes` is a list of shape kinds. What happens if it
has just one thing in it?
**You know it works when…** no more cubes, cylinders or cones.

### 2.4 Invisible floor
**Goal:** shapes bounce on… nothing.
**Hint:** `floorIsVisible`. (The invisible physics floor is separate from
the visible plate — look at `makeRoom` in `ShapeFactory.swift` to see why.)
**You know it works when…** shapes still land and stack, but you can't
see what they're landing on.

---

## Level 3 — Add a small feature 🟠

*Now you'll write a few lines of new code. The hints tell you which file.*

### 3.1 A new shape kind
**Goal:** add a *capsule* (pill shape) to the mix.
**Hint 1:** in `Tweakables.swift`, add `case capsule` to `ShapeKind`, and
add `.capsule` to `enabledShapes`.
**Hint 2:** Xcode will now show an error in `ShapeFactory.swift`: *"switch
must be exhaustive"*. That's Swift protecting you — it noticed you added a
kind without saying what it looks like! Add to the `switch`:
```swift
case .capsule:
    mesh = MeshResource.generateSphere(radius: size / 2)
    collisionShape = ShapeResource.generateSphere(radius: size / 2)
```
then make it pill-shaped by stretching the entity: after
`entity.name = "shape"`, add
`if kind == .capsule { entity.scale = [1, 1.8, 1] }`.
**You know it works when…** pills rain down alongside the other shapes.

### 3.2 Tap to delete
**Goal:** tapping a shape makes it vanish (pop!) instead of flicking it.
**Hint:** in `PlaygroundView.swift`, find the `SpatialTapGesture`. Replace
the impulse code with `shape.removeFromParent()`, and update
`settings.shapeCount` afterwards.
**You know it works when…** shapes disappear when clicked.

### 3.3 Lucky-dip bounciness
**Goal:** every shape gets its own random bounciness, so some are dead
weights and some are superballs.
**Hint:** in `PlaygroundView.swift`, `spawnShapes` passes
`settings.bounciness` into the factory. Swap it for
`Float.random(in: 0...1.2)`.
**You know it works when…** one spawn button press produces a mix of
duds and bouncers.

### 3.4 Anti-gravity button
**Goal:** a new button in the control panel that flips gravity upside down.
**Hint:** in `ControlPanelView.swift`, add
```swift
Button("Flip gravity! 🙃") {
    settings.gravityY = -settings.gravityY
}
```
near the Spawn button. That's the whole feature — the gravity `.onChange`
in `PlaygroundView.swift` already does the rest. Ask yourself: why?
**You know it works when…** pressing it makes every shape fall *up* and
pile on the ceiling.

---

## Level 4 — Stretch goals 🔴

*Proper challenges. You'll need to read Apple's documentation or search
for the right API — exactly what real developers do.*

### 4.1 Throw shapes
**Goal:** when you release a dragged shape, it keeps your hand's speed —
so you can throw it.
**Hint:** in the drag gesture's `.onEnded`, the `value` has a
`velocity` (a 3D speed). Convert it like the drag position is converted,
then give it to the shape's `PhysicsMotionComponent`:
```swift
shape.components.set(PhysicsMotionComponent(linearVelocity: thrownVelocity))
```
Set the body mode back to `.dynamic` *first*.
**You know it works when…** a flick of the mouse sends a shape flying
across the cube.

### 4.2 Sound on impact
**Goal:** a little "bop" sound when shapes collide.
**Hint:** RealityKit publishes collision events. In `PlaygroundView.swift`'s
`RealityView` make-closure you can subscribe:
```swift
_ = content.subscribe(to: CollisionEvents.Began.self) { event in
    // play a sound here
}
```
For the sound itself, look up `AudioFileResource` (needs a sound file in
the app) or start simpler with `UIImpactFeedbackGenerator`… does that
exist on visionOS? Investigate!
**You know it works when…** a shape landing makes a noise.

### 4.3 Scoreboard ornament
**Goal:** the shape count floats attached to the playground cube itself,
in an "ornament" — a little panel that hangs off a window's edge.
**Hint:** search Apple's docs for the SwiftUI `.ornament` modifier and
attach one to the `RealityView`.
**You know it works when…** the live count hovers beside the cube.

### 4.4 Break out of the box (hard!)
**Goal:** an ImmersiveSpace mode — shapes bounce on a huge floor in your
whole room instead of inside the 1 m cube.
**Hints:**
1. In `PhysicsPlaygroundApp.swift`, add a third scene:
   `ImmersiveSpace(id: "big") { BigPlaygroundView() }`.
2. Make `BigPlaygroundView` a copy of `PlaygroundView` with a much bigger
   `makeRoom` (say 3×3×3 m) and no ceiling.
3. Open it from the control panel with
   `@Environment(\.openImmersiveSpace)` — note it's `async`, so call it
   inside `Task { await openImmersiveSpace(id: "big") }`.
4. In an ImmersiveSpace the origin is on the *floor at your feet*, not the
   centre of a cube — so the room's floor belongs at `y = 0`, and shapes
   should spawn at `y = 1.5` or so.
**You know it works when…** you're standing *inside* the playground and
shapes rain around you.

---

## Ideas beyond the worksheet 💡

Shape spinner (give spawned shapes random `angularVelocity`), a "sun" in
the middle that shapes orbit (hint: gravity `[0,0,0]` plus a force toward
the centre each frame), two-colour teams that score points when they touch
the floor first, textures instead of flat colours… If you build something
fun, show someone!
