# 🧊 Physics Playground — a toy app for Apple Vision Pro

A one-metre glass cube of 3D space floats in your room. Press a button and
colourful cubes, spheres, cylinders and cones rain down, bounce off each
other, and pile up on the floor. Grab them, flick them, turn gravity off,
make everything a trampoline.

**The whole point of this project is for you to change the code and see
what happens.** It's small (six Swift files), heavily commented, and
designed so that changing a single number visibly changes the app.

## What you need

- A Mac with **Xcode 15.2 or newer** (free from the Mac App Store).
- That's it. No Apple Vision Pro headset needed — the app runs in the
  **visionOS simulator**, which comes with Xcode. No Apple ID or paid
  developer account needed for the simulator either.

> First time? When Xcode asks which platforms to install, tick
> **visionOS**. (You can also add it later in
> Xcode → Settings → Components.)

## Run it in 3 steps

1. **Double-click `PhysicsPlayground.xcodeproj`** — the project opens in Xcode.
2. At the top of the Xcode window, set the destination to
   **Apple Vision Pro** (a simulator).
3. Press the **▶ Run** button (or ⌘R). The first build takes a minute or
   two; after that it's fast.

Two windows appear in the simulator: a **control panel** and the
**playground cube**. Press **Spawn shapes!** and enjoy.

### Controlling the simulator

- **Look around:** click and drag the background.
- **Move:** hold ⌥W/A/S/D (or use the camera controls at the bottom right).
- **Tap something:** just click it.
- **Drag a shape:** click and hold a shape, then move the mouse.

## How to play

| Do this | And this happens |
|---|---|
| Press **Spawn shapes!** | Shapes rain from the top of the cube |
| Click a shape | It gets flicked into the air |
| Click-drag a shape | You carry it around; let go to drop it |
| Move the **Gravity** slider | Instant Moon/Earth/upside-down physics |
| Move the **Bounciness** slider | New shapes get bouncier or duller |
| Press **Reset** | The cube empties |

## Now make it YOURS ✏️

Open **`PhysicsPlayground/Tweakables.swift`**. Every value in it is safe
to change. Edit a number, press ▶ again, see the difference. Some ideas:

- `gravity` → `[0, -1.6, 0]` — welcome to the Moon
- `spawnCountPerTap` → `10` — shape confetti
- `bounciness` → `1.1` — the floor is a trampoline (chaos guaranteed)
- `shapeSize` → `0.2...0.3` — boulders

Then work through **[CHALLENGES.md](CHALLENGES.md)** — a graded set of
challenges from "change one number" to "add a whole new feature".

## Map of the code

All the Swift lives in the `PhysicsPlayground/` folder:

| File | What it does |
|---|---|
| `Tweakables.swift` | ★ Start here — all the fun numbers to change |
| `PhysicsPlaygroundApp.swift` | The front door: declares the two windows |
| `ControlPanelView.swift` | The 2D window with the buttons and sliders |
| `PlaygroundView.swift` | The 3D scene: spawning, gravity, tap and drag |
| `ShapeFactory.swift` | Builds the shapes, the floor and the invisible walls |
| `PlaygroundSettings.swift` | The live state shared between the two windows |

How the pieces talk to each other:

```
ControlPanelView  --writes-->  PlaygroundSettings  --read by-->  PlaygroundView
   (buttons/sliders)              (shared state)                  (the 3D cube)
                                                                       |
                                                                  ShapeFactory
                                                              (builds the entities)
```

## Troubleshooting

- **"Apple Vision Pro" isn't in the destination list** — install the
  visionOS platform: Xcode → Settings → Components → get **visionOS**
  (it's a few GB, be patient), then restart Xcode.
- **First build is slow** — normal. Later builds are much faster.
- **A build error after you edited something** — read the red message;
  Xcode usually offers a one-click "Fix" button. Experimenting with
  errors (and fixing them) is genuinely how programmers learn. ⌘Z
  undoes your last change if you get stuck.
- **You broke it completely and want a clean start** — in Terminal, run
  `git checkout .` inside the project folder to restore every file.
- **The project itself won't open** (e.g. a much newer Xcode) — regenerate
  it: install [XcodeGen](https://github.com/yonaskolb/XcodeGen)
  (`brew install xcodegen`), then run `xcodegen generate` in the project
  folder. That rebuilds `PhysicsPlayground.xcodeproj` from `project.yml`.
- **No app icon** — expected; we ship an empty icon placeholder. Adding
  real icon images is a nice bonus challenge.

## For teachers

- Works entirely in the free visionOS simulator; nothing to sign, no
  accounts to create. One Mac per pair of students works well.
- `Tweakables.swift` maps to GCSE concepts: constants, data types
  (`Float`, arrays, ranges), and the edit–compile–run cycle.
- `CHALLENGES.md` is levelled: Level 1 needs no Swift knowledge, Level 4
  stretches confident students. Each challenge states what success looks
  like, so students can self-check.
