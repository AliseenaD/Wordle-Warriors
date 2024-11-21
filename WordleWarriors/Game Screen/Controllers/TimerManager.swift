//
//  TimerManager.swift
//  WordleWarriors
//
//  Created by Mohamoud Barre on 11/20/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

extension GameBoardViewController{
    // Function to get the total elapsed time
    func getTotalElapsedTime() -> TimeInterval {
        guard let startTime = startTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    @objc func onBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Function to start the timer
    func startTimer() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
        displayLink?.add(to: .current, forMode: .common)
    }
    
    // Update the timer numbers
    @objc func updateTimer() {
        let totalTime = getTotalElapsedTime()
        let minutes = Int(totalTime) / 60
        let seconds = Int(totalTime) % 60
        let millis = Int((totalTime.truncatingRemainder(dividingBy: 1)) * 1000)
        boardScreen.timerLabel.text = String(format: "%02d:%02d.%03d", minutes, seconds, millis)
        
    }
    
    // Stop the timer
    func stopTimer() {
        displayLink?.invalidate()
        displayLink = nil
        saveGameState()
    }
}
