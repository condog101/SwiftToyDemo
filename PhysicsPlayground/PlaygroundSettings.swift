//
//  PlaygroundSettings.swift
//  PhysicsPlayground
//
//  This is the app's "live" state — the values the sliders and buttons in
//  the control panel change WHILE the app is running (no rebuild needed).
//
//  Compare this with Tweakables.swift:
//    • Tweakables  = values baked in when you press Run (edit → rebuild)
//    • Settings    = values you can change live with the sliders
//
//  The `@Observable` line is a bit of Swift magic: it makes SwiftUI watch
//  this object, so any screen using these values redraws automatically
//  the moment one of them changes.
//

import SwiftUI
import Observation

@Observable
final class PlaygroundSettings {

    // MARK: - Live-adjustable values

    /// Current gravity in the "up/down" direction (the y-axis).
    /// Starts at whatever Tweakables.gravity says; the slider moves it.
    var gravityY: Float = Tweakables.gravity.y

    /// Bounciness for NEWLY spawned shapes (existing ones keep theirs).
    var bounciness: Float = Tweakables.bounciness

    /// How many shapes the Spawn button creates per press.
    var spawnCount: Int = Tweakables.spawnCountPerTap

    // MARK: - Live info (read by the control panel)

    /// How many shapes are currently in the playground.
    /// The playground updates this; the control panel just displays it.
    var shapeCount: Int = 0

    // MARK: - Button "events"

    // Here's a neat trick: SwiftUI reacts to VALUES changing, not to
    // button presses directly. So each button just adds 1 to a counter.
    // The playground notices the counter changed and does the work.
    // (This is called a "version counter" — a simple way to send a
    //  one-off event through observable state.)

    /// Goes up by 1 every time the Spawn button is pressed.
    private(set) var spawnRequestID = 0

    /// Goes up by 1 every time the Reset button is pressed.
    private(set) var resetRequestID = 0

    /// Called by the Spawn button in ControlPanelView.
    func requestSpawn() {
        spawnRequestID += 1
    }

    /// Called by the Reset button in ControlPanelView.
    func requestReset() {
        resetRequestID += 1
    }
}
