//
//  OpenFileCollectionViewAudioCell.swift
//  Disk
//
//  Created by Георгий on 16.09.2024.
//

import UIKit
import AVFoundation
import CoreAudio

class OpenFileCollectionViewAudioCell: UICollectionViewCell {
    
    var audioPlayer: AVAudioPlayer?
    lazy var playPauseButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        audioPlayer = nil
        setupPlayPauseButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            
            // Остановка аудио, если ячейка переиспользуется
            audioPlayer?.stop()
            audioPlayer = nil
        }
        
    func setupPlayPauseButton() {
            // Добавляем кнопку на ячейку
        contentView.addSubview(playPauseButton)
            
            // Устанавливаем изображение для кнопки
            playPauseButton.setTitle("Play", for: .normal)
            playPauseButton.setTitleColor(.blue, for: .normal)
            
            // Добавляем таргет для кнопки
            playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
            
            // Настраиваем Auto Layout (констрейнты)
            playPauseButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                playPauseButton.widthAnchor.constraint(equalToConstant: 100),
                playPauseButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    @objc func playPauseTapped() {
            // Логика для воспроизведения или паузы
            if let player = audioPlayer, player.isPlaying {
                player.pause()
                playPauseButton.setTitle("Play", for: .normal)
            } else {
                audioPlayer?.play()
                playPauseButton.setTitle("Pause", for: .normal)
            }
        }
    
    func setup(with audioData: Data) {
        playAudio(fromData: audioData)
    }
    
    func playAudio(fromData data: Data) {
            do {
                audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer?.prepareToPlay()
//                audioPlayer?.play()
            } catch let error {
                print("Ошибка воспроизведения аудио: \(error.localizedDescription)")
            }
        }
}
