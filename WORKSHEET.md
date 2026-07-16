# 📝 Physics Playground — Lesson Worksheet

**Name:** ______________________  **Date:** ______________  **Class:** ________

*One lesson (~60 minutes). You need a Mac with Xcode and this project —
your teacher will tell you where to find it. Work in pairs if sharing a Mac.*

> 💡 A printable version of this worksheet is in `worksheet.html` —
> open it in a web browser and press print.

## Learning objectives

By the end of this lesson you will be able to:

1. Explain what a **constant** is and why programmers name their values.
2. Recognise some Swift **data types**: `Float`, `Int`, `Bool`, arrays and ranges.
3. Use the **edit → compile → run** cycle to change a real 3D app.
4. Read code you didn't write and predict what changing it will do.

---

## Starter — before you touch the Mac (5 min)

Draw a line from each word to its meaning (or write the matching letter):

| Term | | Meaning |
|---|---|---|
| 1. Constant | | A. A decimal number, like `-9.8` or `0.5` |
| 2. `Float` | | B. A list of values, written like `[.red, .blue]` |
| 3. Array | | C. A named value that is set once and doesn't change while the app runs |
| 4. Range | | D. A true/false value |
| 5. `Bool` | | E. Everything between a lowest and highest value, written like `0.06...0.14` |

**1 = ____  2 = ____  3 = ____  4 = ____  5 = ____**

---

## Task 1 — Run the app (10 min)

Tick each step as you do it:

- [ ] Double-click **`PhysicsPlayground.xcodeproj`** to open it in Xcode.
- [ ] At the top of the window, choose the **Apple Vision Pro** simulator.
- [ ] Press the **▶ Run** button (the first build is slow — be patient!).
- [ ] When the two windows appear, press **Spawn shapes!** a few times.

Now experiment, and write down what you see:

**Q1.** What happens when you *click* (tap) a shape?

> _____________________________________________________________________

**Q2.** What happens when you click a shape and *hold and drag* it?

> _____________________________________________________________________

**Q3.** Slide the **Gravity** slider slowly from −9.8 up to +5. Describe what
happens as it passes 0.

> _____________________________________________________________________
>
> _____________________________________________________________________

---

## Task 2 — Predict, change, observe (20 min)

Open the file **`Tweakables.swift`** (find it in the list on the left of
Xcode, inside the `PhysicsPlayground` folder).

For each experiment: **write your prediction FIRST**, then make the change,
press ▶, and write what actually happened. Undo the change (⌘Z) before the
next experiment.

### Experiment A — Moon gravity
Change `gravity` from `[0, -9.8, 0]` to `[0, -1.6, 0]`.

- **I predict:** ________________________________________________________
- **What happened:** ____________________________________________________

### Experiment B — Shape confetti
Change `spawnCountPerTap` from `1` to `10`.

- **I predict:** ________________________________________________________
- **What happened:** ____________________________________________________

### Experiment C — Trampoline world
Change `bounciness` from `0.6` to `1.1`.

- **I predict:** ________________________________________________________
- **What happened:** ____________________________________________________
- **Think:** in real life, a ball can never bounce *higher* than it was
  dropped from. Why not? Where would the extra energy come from?

> _____________________________________________________________________

### Experiment D — Boulders
Change `shapeSize` from `0.06...0.14` to `0.2...0.3`.

- **I predict:** ________________________________________________________
- **What happened:** ____________________________________________________

---

## Task 3 — Read the code (15 min)

Still in `Tweakables.swift`, answer these:

**Q4.** What **data type** is `mass`? What data type is `metallicShapes`?

> `mass` is a ____________   `metallicShapes` is a ____________

**Q5.** `shapeSize` is written with TWO numbers: `0.06...0.14`. Why two?
What does the app do with them? (Hint: read the comment above it.)

> _____________________________________________________________________
>
> _____________________________________________________________________

**Q6.** What would happen if you changed `enabledShapes` to just `[.sphere]`?

> _____________________________________________________________________

**Q7.** Now open **`ShapeFactory.swift`** and find the function
`makeRoom`. The walls of the playground are *invisible but solid*. Read the
comments: what is missing from a wall entity that makes it invisible?

> _____________________________________________________________________

**Q8.** In `makeShape`, the code attaches several "components" to each
shape. Which component makes gravity affect the shape? (Hint: its name
contains the word "physics".)

> _____________________________________________________________________

---

## Plenary (5 min)

**Q9.** In your own words, describe the **edit → compile → run** cycle you
used today:

> _____________________________________________________________________
>
> _____________________________________________________________________

**Q10.** If you had another hour, what ONE feature would you add to this
app, and which file do you think you'd change?

> Feature: ______________________________________________________________
>
> File: _______________________________

---

## Finished early? 🚀

Open **[CHALLENGES.md](CHALLENGES.md)** and start on the Level 1
challenges — they carry straight on from what you did in Task 2. Level 2
awaits the brave.

---

<details>
<summary><strong>🔑 Answer key (teachers — click to reveal)</strong></summary>

**Starter:** 1 = C, 2 = A, 3 = B, 4 = E, 5 = D

**Q1.** The shape gets flicked/knocked into the air (an impulse is applied),
with a bit of random sideways movement.

**Q2.** The shape follows the pointer — you carry it around; when released
it falls under gravity again.

**Q3.** Falling slows as gravity approaches 0 (shapes drift/float); past 0
gravity points upwards, so shapes fall *up* and pile against the ceiling.

**Experiment A:** everything falls and bounces in slow motion (Moon gravity
is about 1/6 of Earth's).
**Experiment B:** ten shapes rain down per press instead of one.
**Experiment C:** each bounce is bigger than the last — shapes gain energy
until the cube is chaos. (Real bounces lose energy to heat/sound; gaining
energy would break conservation of energy.)
**Experiment D:** far bigger shapes; only a few fit in the cube.

**Q4.** `mass` is a `Float` (decimal number); `metallicShapes` is a `Bool`
(true/false).

**Q5.** It's a *range*: every new shape gets a random size between the two
numbers, so shapes vary in size.

**Q6.** Only spheres would spawn — a ball pit.

**Q7.** A wall has no **ModelComponent** (no mesh/material), so nothing is
drawn — but it still has a CollisionComponent, so it's solid.

**Q8.** The **PhysicsBodyComponent** (in `.dynamic` mode) makes the shape
obey gravity and bounce.

**Q9.** Any sensible description of: change the code in the editor → press
Run so Xcode compiles (translates) it → the app launches and you observe
the result → repeat.

**Q10.** Open answer — good ones name a sensible file (`Tweakables.swift`
for value changes, `ControlPanelView.swift` for new buttons,
`ShapeFactory.swift` for new shapes).

</details>
