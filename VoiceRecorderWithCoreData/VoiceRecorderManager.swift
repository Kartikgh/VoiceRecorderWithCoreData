//
//  VoiceRecorderManager.swift
//  VoiceRecorderWithCoreData
//
//  Created by Karthik.Kurdekar on 17/02/25.
//

import AVFoundation

class VoiceRecorderManager: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    var audioFileName: URL?
    
    func startRecording(userID: String) -> URL? {
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let fileName = "\(UUID().uuidString).m4a"
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
            
            self.audioFileName = fileURL
            
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            return fileURL
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
            return nil
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
