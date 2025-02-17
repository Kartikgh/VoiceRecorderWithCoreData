//
//  ViewController.swift
//  VoiceRecorderWithCoreData
//
//  Created by Karthik.Kurdekar on 17/02/25.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController {
    
    let recorderManager = VoiceRecorderManager()
    let coreDataHelper = CoreDataHelper()
    let playerManager = AudioPlayerManager()
    
    var recordings: [VoiceRecording] = []
    var currentUserID = "12345"
    var recordedFileURL: URL?
    
    let recordButton = UIButton()
    let stopButton = UIButton()
    let playButton = UIButton()
    let tableView = UITableView()
    let recordingIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadRecordings()
    }
    
    func setupUI() {
        
        recordButton.setTitle("Start", for: .normal)
        recordButton.backgroundColor = .red
        recordButton.layer.cornerRadius = 10
        recordButton.addTarget(self, action: #selector(startRecordingTapped), for: .touchUpInside)
        
        stopButton.setTitle("Stop", for: .normal)
        stopButton.backgroundColor = .gray
        stopButton.layer.cornerRadius = 10
        stopButton.addTarget(self, action: #selector(stopRecordingTapped), for: .touchUpInside)
        
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = .blue
        playButton.layer.cornerRadius = 10
        playButton.addTarget(self, action: #selector(playSelectedRecording), for: .touchUpInside)
        
        recordingIndicator.hidesWhenStopped = true
        recordingIndicator.color = .white
        view.addSubview(recordingIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecordingCell")
        
        let stackView = UIStackView(arrangedSubviews: [recordButton, stopButton, playButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        view.addSubview(tableView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        recordingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            recordingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func startRecordingTapped() {
        recordedFileURL = recorderManager.startRecording(userID: currentUserID)
        
        recordButton.setTitle("Recording...", for: .normal)
        recordButton.backgroundColor = .green
        recordingIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.2) {
            self.recordButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    
    @objc func stopRecordingTapped() {
        recorderManager.stopRecording()
        
        recordingIndicator.stopAnimating()
        recordButton.setTitle("Start", for: .normal)
        recordButton.backgroundColor = .red
        
        UIView.animate(withDuration: 0.2) {
            self.recordButton.transform = CGAffineTransform.identity
        }
        
        if let fileURL = recordedFileURL {
            coreDataHelper.saveRecording(userID: currentUserID, filePath: fileURL)
            loadRecordings()
        }
    }
    
    @objc func playSelectedRecording() {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            let recording = recordings[selectedIndex.row]
            if let audioFilePath = recording.audioFilePath {
                playerManager.playRecording(filePath: audioFilePath)
            }
        }
    }
    
    func loadRecordings() {
        recordings = coreDataHelper.fetchRecordings(for: currentUserID)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath)
        let recording = recordings[indexPath.row]
        cell.textLabel?.text = "Recording \(indexPath.row + 1) - \(recording.createdAt ?? Date())"
        return cell
    }
}
