//
//  FileManager.swift
//  VoiceRecorderWithCoreData
//
//  Created by Karthik.Kurdekar on 17/02/25.
//

import Foundation

class FileManagerHelper {
    
    static let shared = FileManagerHelper()
    
    private init() {}
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
