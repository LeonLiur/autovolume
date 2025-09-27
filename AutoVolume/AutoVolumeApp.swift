//
//  AutoVolumeApp.swift
//  AutoVolume
//
//  Created by Leo Liu on 2025-09-27.
//

import SwiftUI

@main
struct AutoVolumeApp: App {
    @StateObject private var audioMonitor = AudioMonitor()

    var body: some Scene {
        MenuBarExtra("AutoVolume", systemImage: "speaker.wave.2.fill") {
            Text("Ambient dB: \(Int(audioMonitor.currentDB))")
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
