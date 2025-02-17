# Voice Recording App

A simple iOS app that allows users to record, save, and play back audio recordings. The app leverages `AVFoundation` for audio recording and playback, `CoreData` for persistent storage of recordings, and provides a clean and interactive UI for user interaction.

## Features

- **Record Audio**: Start and stop audio recordings.
- **Save Recordings**: Recordings are saved with a unique file name and stored in the app’s Documents directory.
- **Play Recordings**: Play back previously recorded audio from the list of saved recordings.
- **CoreData Integration**: Store metadata for each recording, including the file path and timestamp.
- **UI Animations**: Visual feedback during recording to improve user experience.

## Technologies Used

- **Swift**: Programming language.
- **AVFoundation**: Framework used for recording and playing audio.
- **CoreData**: Framework for managing the persistent storage of recordings.
- **UIKit**: Framework used for the app's user interface.

## Requirements

- iOS 13.0 or later
- Xcode 12.0 or later

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/VoiceRecordingApp.git
   ```

2. Open the project in Xcode.

3. Build and run the project on a real iOS device (audio recording won't work on the simulator).

## How to Use

### 1. Start Recording
- Tap on the **Start** button to begin recording.
- Visual feedback is provided during recording with animations.

### 2. Stop Recording
- Tap on the **Stop** button to stop the recording.
- The recording will automatically be saved and added to the list of recordings.

### 3. Play a Recording
- Tap on a recording in the list to select it.
- Tap on the **Play** button to listen to the selected recording.

## File Management

### Saving Recordings
- The app saves recordings to the device's **Documents directory**.
- Each recording is stored with a unique filename (UUID) to avoid conflicts.

### Fetching Recordings
- The app uses **CoreData** to store metadata for each recording (e.g., file path, creation date).
- Recordings can be loaded and displayed in a list.

## Code Explanation

### FileManagerHelper

A utility class that provides a method for fetching the app's **Documents directory**. This directory is used to save and load audio files.

```swift
class FileManagerHelper {
    
    static let shared = FileManagerHelper()
    
    private init() {}

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
```

### VoiceRecording Management

**VoiceRecorderManager** is responsible for starting and stopping recordings. It uses `AVAudioRecorder` for recording audio.

```swift
class VoiceRecorderManager: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    
    func startRecording(userID: String) -> URL? {
        // Recording setup code here
    }
    
    func stopRecording() {
        // Stop recording logic
    }
}
```

**CoreDataHelper** manages saving and fetching recordings to/from CoreData.

```swift
class CoreDataHelper {
    func saveRecording(userID: String, filePath: URL) {
        // Save recording to CoreData
    }
    
    func fetchRecordings(for userID: String) -> [VoiceRecording] {
        // Fetch recordings for a user
    }
}
```

**AudioPlayerManager** handles the playback of audio files using `AVAudioPlayer`.

```swift
class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    
    func playRecording(filePath: String) {
        // Play audio from file path
    }
}
```

## Contribution

Feel free to fork the project, make improvements, and submit pull requests. Contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
