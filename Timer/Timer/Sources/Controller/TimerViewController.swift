//
//  TimerViewController.swift
//  Timer
//
//  Created by Sanghyeon Park on 2/1/24.
//

import UIKit

class TimerViewController: UIViewController {
    
    var timerTitleLabel: UILabel = {
        let timerTitleLabel = UILabel()
        timerTitleLabel.textColor = .black
        timerTitleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        timerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerTitleLabel
    }()
    
    var timerCountLabel: UILabel = {
        let timerCountLabel = UILabel()
        timerCountLabel.textColor = .black
        timerCountLabel.font = .systemFont(ofSize: 70)
        timerCountLabel.minimumScaleFactor = 0.5
        timerCountLabel.adjustsFontSizeToFitWidth = true
        timerCountLabel.textAlignment = .center
        timerCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerCountLabel
    }()
    
    var timerToggleButton: UIButton = {
        let timerToggleButton = UIButton()
        timerToggleButton.setTitle("중지", for: .normal)
        timerToggleButton.setTitleColor(.black, for: .normal)
        timerToggleButton.translatesAutoresizingMaskIntoConstraints = false
        return timerToggleButton
    }()
    
    var timerService: TimerService = TimerService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        initSubViews()
        setupAutoLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timerService.startTimer()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timerService.stopTimer()
    }

}

// MARK: - Layout Function
extension TimerViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        
        // MARK: View Define
        
        timerService.delegate = self
        timerToggleButton.addTarget(self, action: #selector(didTapTimerToggleButton), for: .touchUpInside)
    }
    
    func initSubViews() {
        // MARK: AddSubView
        
        view.addSubview(timerTitleLabel)
        view.addSubview(timerCountLabel)
        view.addSubview(timerToggleButton)
    }
    
    func setupAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        // MARK: AutoLayout
        
        NSLayoutConstraint.activate([
            timerTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            timerTitleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            timerCountLabel.topAnchor.constraint(equalTo: timerTitleLabel.bottomAnchor, constant: 10),
            timerCountLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            timerCountLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            timerToggleButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            timerToggleButton.topAnchor.constraint(equalTo: timerCountLabel.bottomAnchor, constant: 20),
        ])
    }
}

// MARK: - Function

extension TimerViewController {
    /// 초를 시간:분:초 형태로 변경
    private func convertTimeFormat(seconds: Int) -> String {
        let hours: Int = seconds / 3600
        let minutes: Int = (seconds % 3600) / 60
        let remainingSeconds = (seconds % 3600) % 60
        
        let timeString = String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
        
        return timeString
    }
    
    @objc func didTapTimerToggleButton(_ sender: UIButton) {
        if timerService.isRunning {
            timerService.stopTimer()
            sender.setTitle("시작", for: .normal)
        } else {
            timerService.restartTimer()
            sender.setTitle("중지", for: .normal)
        }
    }
}

extension TimerViewController: TimerServiceDelegate {
    func timerService(service: TimerService, timerChanged timer: TimerModel, count: Int, limitCount: Int) {
        timerTitleLabel.text = "\(timer.title)"
        timerCountLabel.text = "\(convertTimeFormat(seconds: count))"
    }
    
    func timerService(service: TimerService, timerEnded count: Int) {
        timerCountLabel.text = "타이머 종료"
    }
    
    
}
