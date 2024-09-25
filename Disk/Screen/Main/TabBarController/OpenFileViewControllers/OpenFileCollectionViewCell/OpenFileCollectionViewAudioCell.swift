//
//  OpenFileCollectionViewAudioCell.swift
//  Disk
//
//  Created by Георгий on 16.09.2024.
//

import UIKit
import AVFoundation

class OpenFileCollectionViewAudioCell: UICollectionViewCell {
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "hifispeaker")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private weak var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse called")
        stopPlaying()
    }
    
    private func configureUI() {
        contentView.addSubview(playPauseButton)
        contentView.addSubview(progressSlider)
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(currentTimeLabel)

        setupConstraints()
    }
    
    @objc private func playPauseTapped() {
        guard let player = audioPlayer else { return }
        
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            audioPlayer?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            startTimer()
        }
    }

    func setup(audioData data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            
            progressSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
            progressSlider.value = 0
            
            updateTimeLabels()
        } catch let error {
            print("Ошибка воспроизведения аудио: \(error.localizedDescription)")
        }
    }
    
    private func updateTimeLabels() {
        currentTimeLabel.text = formatTime(audioPlayer?.currentTime ?? 0)
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        audioPlayer?.currentTime = TimeInterval(sender.value)
        updateTimeLabels()
        startTimer()
    }
    
    @objc private func updateSlider() {
        progressSlider.value = Float(audioPlayer?.currentTime ?? 0)
        updateTimeLabels()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopTimer()
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    private func setupConstraints() {
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        albumCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        albumCoverImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        progressSlider.snp.makeConstraints { make in
            make.top.equalTo(albumCoverImageView.snp_bottomMargin)
            make.centerX.equalTo(contentView)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.right.equalTo(progressSlider.snp_leftMargin).offset(-10)
            make.top.equalTo(progressSlider.snp_top)
            make.bottom.equalTo(progressSlider.snp_bottom)
            make.width.equalTo(50)
        }

        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(progressSlider.snp_right).offset(10)
            make.top.equalTo(progressSlider.snp_top)
            make.bottom.equalTo(progressSlider.snp_bottom)
            make.width.equalTo(50)
        }
    }
}

extension OpenFileCollectionViewAudioCell: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            stopTimer()
        }
}
