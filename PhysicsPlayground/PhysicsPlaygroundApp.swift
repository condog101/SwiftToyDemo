//
//  PhysicsPlaygroundApp.swift
//  PhysicsPlayground
//
//  Every Swift app has exactly one file with `@main` — it's the front
//  door. When the app launches, visionOS looks here to find out what
//  windows ("scenes") the app has.
//
//  Our app has TWO windows:
//    1. "controls"   — a normal flat window with buttons and sliders
//                      (this one opens first, at launch)
//    2. "playground" — a VOLUMETRIC window: a 1-metre glass cube of real
//                      3D space that you can walk around!
//
//  The control panel auto-opens the playground for you (see the
//  .onAppear in ControlPanelView.swift).
//

import SwiftUI

@main
struct PhysicsPlaygroundApp: App {

    /// ONE settings object shared by BOTH windows. The control panel
    /// writes to it; the playground reads from it. That's how a button
    /// press in one window makes shapes appear in the other.
    @State private var settings = PlaygroundSettings()

    var body: some Scene {
        // Window 1: the control panel (flat, like an iPad app floating
        // in your room).
        WindowGroup(id: "controls") {
            ControlPanelView()
                .environment(settings)   // hand the shared settings in
        }
        .defaultSize(width: 460, height: 560)

        // Window 2: the playground volume. `.volumetric` is what makes it
        // a 3D box instead of a flat panel. Its size here must match the
        // box size used in PlaygroundView.swift.
        WindowGroup(id: "playground") {
            PlaygroundView()
                .environment(settings)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.0, height: 1.0, depth: 1.0, in: .meters)
    }
}
