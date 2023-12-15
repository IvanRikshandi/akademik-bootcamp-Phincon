import UIKit
import Speech
protocol SearchBarCellDelegate {
    func searchTextChanged(_ text: String?)
}

class SearchBarCell: UITableViewCell {
    
    @IBOutlet weak var voiceHistory: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    var delegate: SearchBarCellDelegate?
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSpeechRecognition()
        style()
        searchField.addTarget(self, action: #selector(searchTextEditedChange), for: .editingChanged)
        if let voiceHistory = voiceHistory {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchByVoice))
            voiceHistory.addGestureRecognizer(tapGesture)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupSpeechRecognition() {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus == .authorized {
                    self.speechRecognizer?.delegate = self
                }
            }
            return
        }
    }
    
    func style() {
        containerView.makeCornerRadius(8)
        searchField.makeCornerRadius(3)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor.copy(alpha: 0.3)
    }
    
    @objc func searchTextEditedChange(_ sender: UITextField) {
        delegate?.searchTextChanged(sender.text ?? "")
    }
    
    @objc func searchByVoice() {
        if audioEngine.isRunning {
            stopSpeechRecognition()
        } else {
            startSpeechRecognition()
        }
    }
}

extension SearchBarCell: SFSpeechRecognizerDelegate {
    func startSpeechRecognition() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.request.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
                guard let self = self else { return }

                if let result = result {
                    let recognizedText = result.bestTranscription.formattedString
                    self.searchField.text = recognizedText
                }

                if result?.isFinal == true {
                    self.stopSpeechRecognition()
                }

                if let error = error {
                    print("Speech recognition error: \(error)")
                }
            }

        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    func stopSpeechRecognition() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
    }
}
