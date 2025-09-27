//
//  AutoVolumeApp.swift
//  AutoVolume
//
//  Created by Leo Liu on 2025-09-27.
//

import SwiftUI
import AVFoundation

@main
struct AutoVolumeApp: App {
    @StateObject private var volumeController = VolumeController()
    
    init() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                print("✅ Mic access granted")
            } else {
                print("❌ Mic access denied")
            }
        }
    }

    var body: some Scene {
        MenuBarExtra("AutoVolume", image: "MenuBar") {
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
