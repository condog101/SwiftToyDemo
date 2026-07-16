//
//  ControlPanelView.swift
//  PhysicsPlayground
//
//  The 2D control panel window — plain SwiftUI, no 3D here.
//  Buttons and sliders in this window change the shared
//  PlaygroundSettings object, and the 3D playground reacts instantly.
//
//  This is a great file to experiment with: try changing button labels,
//  slider ranges, or adding a whole new control (see CHALLENGES.md 3.4).
//

import SwiftUI

struct ControlPanelView: View {

    @Environment(PlaygroundSettings.self) private var settings

    /// Lets this view ask visionOS to open another window by its id.
    @Environment(\.openWindow) private var openWindow

    /// Makes sure we only auto-open the playground once.
    @State private var hasOpenedPlayground = false

    var body: some View {
        // `@Observable` objects need this line so SwiftUI sliders can
        // write values back into `settings` (a "binding").
        @Bindable var settings = settings

        VStack(spacing: 24) {

            Text("Physics Playground")
                .font(.extraLargeTitle2)

            // --- The big fun button ---
            Button {
                settings.requestSpawn()
            } label: {
                Label("Spawn shapes!", systemImage: "shippingbox.fill")
                    .font(.title)
                    .padding(.horizontal, 8)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)

            Divider()

            // --- Gravity slider ---
            VStack(alignment: .leading, spacing: 4) {
                Text("Gravity: \(settings.gravityY, specifier: "%.1f") m/s²")
                    .font(.headline)
                Slider(value: $settings.gravityY, in: -15...5)
                Text("Moon is −1.6 · Earth is −9.8 · positive = upside-down day 🙃")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // --- Bounciness slider ---
            VStack(alignment: .leading, spacing: 4) {
                Text("Bounciness of new shapes: \(settings.bounciness, specifier: "%.2f")")
                    .font(.headline)
                Slider(value: $settings.bounciness, in: 0...1.2)
                Text("0 = beanbag · 0.6 = rubber ball · above 1 = trouble 😈")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // --- Shapes per press ---
            Stepper(value: $settings.spawnCount, in: 1...10) {
                Text("Shapes per press: **\(settings.spawnCount)**")
            }

            Divider()

            // --- Status + reset ---
            HStack {
                Text("Shapes in playground: **\(settings.shapeCount)**")
                Spacer()
                Button("Reset", systemImage: "trash", role: .destructive) {
                    settings.requestReset()
                }
            }

            // Backup button in case the playground window gets closed.
            Button("Open Playground Window", systemImage: "cube.transparent") {
                openWindow(id: "playground")
            }
            .font(.footnote)
        }
        .padding(32)
        .frame(maxWidth: 460)
        .onAppear {
            // Open the 3D playground automatically the first time the
            // control panel appears, so you don't have to press anything.
            if !hasOpenedPlayground {
                hasOpenedPlayground = true
                openWindow(id: "playground")
            }
        }
    }
}
