//
//  CoreDataHelper.swift
//  VoiceRecorderWithCoreData
//
//  Created by Karthik.Kurdekar on 17/02/25.
//

import UIKit
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveRecording(userID: String, filePath: URL) {
        let newRecording = VoiceRecording(context: context)
        newRecording.id = UUID()
        newRecording.userID = userID
        
        let relativePath = filePath.lastPathComponent
        newRecording.audioFilePath = relativePath
        newRecording.createdAt = Date()
        
        do {
            try context.save()
            print("Recording saved to Core Data")
        } catch {
            print("Failed to save recording: \(error.localizedDescription)")
        }
    }
    
    func fetchRecordings(for userID: String) -> [VoiceRecording] {
        let request = VoiceRecording.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            let recordings = try context.fetch(request)
            return recordings
        } catch {
            print("Failed to fetch recordings: \(error.localizedDescription)")
            return []
        }
    }
}
