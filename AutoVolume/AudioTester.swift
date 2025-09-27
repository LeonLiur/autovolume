import AVFoundation

class AudioTester {
    let engine = AVAudioEngine()

    func start() {
        let input = engine.inputNode
        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, _ in
            guard let data = buffer.floatChannelData?[0] else { return }
            let length = Int(buffer.frameLength)

            var sum: Float = 0
            for i in 0..<length {
                sum += data[i] * data[i]
            }
            let rms = sqrt(sum / Float(length))
            let db = 20 * log10(rms)

            print("dB:", db.isFinite ? db : -160)
        }

        do {
            try engine.start()
            print("Engine started ✅")
        } catch {
            print("Engine error ❌:", error)
        }
        
        self.checkMicPermissionAndRequest { granted in
            if granted {
                print("Mic access granted, we can use the mic ✅")
            } else {
                print("Mic access not granted ❌")
            }
        }

        // 👇 NEW: check mic permission explicitly
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            print("Mic access: ✅ authorized")
        case .notDetermined:
            print("Mic access: ❔ not determined (should trigger popup)")
        case .denied:
            print("Mic access: ❌ denied (must reset with tccutil)")
        case .restricted:
            print("Mic access: 🚫 restricted (parental controls, MDM)")
        @unknown default:
            print("Mic access: unknown state")
        }
    }
    
    func checkMicPermissionAndRequest(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)

        switch status {
        case .authorized:
            print("Mic access: ✅ authorized")
            completion(true)

        case .notDetermined:
            print("Mic access: ❔ not determined (requesting…)")
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                DispatchQueue.main.async {
                    print("Mic access granted:", granted)
                    completion(granted)
                }
            }

        case .denied:
            print("Mic access: ❌ denied (must reset with tccutil)")
            completion(false)

        case .restricted:
            print("Mic access: 🚫 restricted (parental controls/MDM)")
            completion(false)

        @unknown default:
            completion(false)
        }
    }

}
