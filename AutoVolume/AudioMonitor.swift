//
//  AudioMonitor.swift
//  AutoVolume
//
//  Created by Shota Gen on 9/27/25.
//

import AVFoundation

class AudioMonitor {
    private let engine = AVAudioEngine()
    private(set) var currentDB: Float = -160.0
    
    func start() {
        let inputNode = engine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        print("Starting audio monitoring...")
        print("Input format: \(format)")
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            let channelData = buffer.floatChannelData![0]
            let frameLength = Int(buffer.frameLength)

            
            let rms = sqrt((0..<frameLength).reduce(0) { $0 + pow(channelData[$1], 2) } / Float(frameLength))
            let db = 20 * log10(rms)
            
            DispatchQueue.main.async {
                self.currentDB = db.isFinite ? db : -160
                print("Current DB: \(self.currentDB)") // Debug output
            }
        }
        
        do {
            try engine.start()
            print("Audio engine started successfully")
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    func stop() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        print("Audio monitoring stopped")
    }
}
