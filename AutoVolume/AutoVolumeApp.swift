//
//  AutoVolumeApp.swift
//  AutoVolume
//
//  Created by Leo Liu on 2025-09-27.
//

import SwiftUI

@main
struct AutoVolumeApp: App {
    @StateObject private var volumeController = VolumeController()

    var body: some Scene {
        MenuBarExtra("AutoVolume", systemImage: "speaker.wave.2.fill") {
            Text("Ambient dB: \(Int(volumeController.audioMonitor.currentDB))")
            Toggle("Auto Adjust", isOn: Binding(
                get: { volumeController.isAutoAdjusting },
                set: { isOn in
                    if isOn {
                        volumeController.start()
                    } else {
                        volumeController.stop()
                    }
                }
            ))
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}