//
//  SystemVolume.swift
//  AutoVolume
//
//  Created by Shota Gen on 9/27/25.
//

import CoreAudio

func getSystemVolume() -> Float {
    var defaultOutputDeviceID = AudioDeviceID(0)
    var propertySize = UInt32(MemoryLayout.size(ofValue: defaultOutputDeviceID))
    
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultOutputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    
    AudioObjectGetPropertyData(
        AudioObjectID(kAudioObjectSystemObject),
        &address,
        0,
        nil,
        &propertySize,
        &defaultOutputDeviceID
    )
    
    var volume = Float32(0.0)
    propertySize = UInt32(MemoryLayout.size(ofValue: volume))
    address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyVolumeScalar,
        mScope: kAudioDevicePropertyScopeOutput,
        mElement: kAudioObjectPropertyElementMain
    )
    
    AudioObjectGetPropertyData(
        defaultOutputDeviceID,
        &address,
        0,
        nil,
        &propertySize,
        &volume
    )
    
    return volume
}

func setSystemVolume(_ volume: Float) {
    var defaultOutputDeviceID = AudioDeviceID(0)
    var propertySize = UInt32(MemoryLayout.size(ofValue: defaultOutputDeviceID))
    
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultOutputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    
    AudioObjectGetPropertyData(
        AudioObjectID(kAudioObjectSystemObject),
        &address,
        0,
        nil,
        &propertySize,
        &defaultOutputDeviceID
    )
    
    var newVolume = min(max(volume, 0.0), 1.0) // clamp 0–1
    address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyVolumeScalar,
        mScope: kAudioDevicePropertyScopeOutput,
        mElement: kAudioObjectPropertyElementMain
    )
    
    AudioObjectSetPropertyData(
        defaultOutputDeviceID,
        &address,
        0,
        nil,
        UInt32(MemoryLayout.size(ofValue: newVolume)),
        &newVolume
    )
}
