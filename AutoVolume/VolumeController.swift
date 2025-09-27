//
//  VolumeController.swift
//  AutoVolume
//
//  Created by Shota Gen on 9/27/25.
//

import Foundation

class VolumeController: ObservableObject {
    let audioMonitor = AudioMonitor()
    private var timer: Timer?
    
    private var initialRatio: Float = 1.0
    private var initialDB: Float = -160
    private var initialVolume: Float = 0.5
    
    @Published private(set) var isAutoAdjusting = false
    
    // Call this from UI toggle
    func start() {
        guard !isAutoAdjusting else { return }
        
        audioMonitor.start()
        initialDB = max(audioMonitor.currentDB, 0.1) // avoid /0
        initialVolume = getSystemVolume()
        initialRatio = initialVolume / initialDB
        
        isAutoAdjusting = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.adjustVolume()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isAutoAdjusting = false
        audioMonitor.stop()
    }
    
    private func adjustVolume() {
        let currentDB = max(audioMonitor.currentDB, 0.1)
        let targetVolume = min(max(initialRatio * currentDB, 0.0), 1.0)
        print("trying to set target volume:", targetVolume)
        setSystemVolume(targetVolume)
    }
}
