//
//  ViewController.swift
//  Timer
//
//  Created by Sanghyeon Park on 1/31/24.
//

import UIKit

class TimeSettingViewController: UIViewController {

    // MARK: View Define
    let timerService: TimerService = TimerService.shared
    
    let timeSettingView: TimeSettingView = TimeSettingView()
    let restSettingView: TimeSettingView = TimeSettingView()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle("시작", for: .normal)
        startButton.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        startButton.setTitleColor(.systemGreen, for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return startButton
    }()
    
    var loopLabel: UILabel = {
        let loopLabel = UILabel()
        loopLabel.text = "타이머 반복 실행"
        loopLabel.font = .preferredFont(forTextStyle: .body)
        loopLabel.textColor = .black
        loopLabel.translatesAutoresizingMaskIntoConstraints = false
        return loopLabel
    }()
    
    var loopSwitch: UISwitch = {
        let loopSwitch = UISwitch()
        loopSwitch.translatesAutoresizingMaskIntoConstraints = false
        return loopSwitch
    }()
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        initSubViews()
        setupAutoLayout()
        timerSetting()
    }
}

// MARK: - Layout Function

extension TimeSettingViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        
        // MARK: TimeSettingView Define
        timeSettingView.delegate = self
        restSettingView.delegate = self
        
        // MARK: View Define

        
    }
    
    func initSubViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(timeSettingView)
        stackView.addArrangedSubview(restSettingView)
        view.addSubview(loopLabel)
        view.addSubview(loopSwitch)
        view.addSubview(startButton)
    }
    
    func setupAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        // MARK: AutoLayout
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 200),

            loopLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loopLabel.centerYAnchor.constraint(equalTo: loopSwitch.centerYAnchor),
            
            loopSwitch.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            loopSwitch.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            
            startButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
        ])
    }
    
    
    func timerSetting() {
        timeSettingView.titleText = "학습"
        restSettingView.titleText = "휴식"
    }
}

// MARK: - Function

extension TimeSettingViewController {
    /// 알림 생성
    @objc func didTapStartButton() {
        guard timeSettingView.settedCount > 0,
              restSettingView.settedCount > 0 else {
            let bottomAlert = BottomAlert(title: "0분으로 설정된게 보이는데?", self)
            bottomAlert.showAlert()
            return
        }
        
        
        timerService.setTimer(
            multiCount: [
                TimerModel(title: timeSettingView.titleText, interval: timeSettingView.settedCount * 1),
                TimerModel(title: restSettingView.titleText, interval: restSettingView.settedCount * 1)],
            isLoop: loopSwitch.isOn
        )
        
        let vc = TimerViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: - Time Setting View Delegate

extension TimeSettingViewController: TimeSettingViewDelegate {
    func timeSettingView(maximumOfTimeCount view: TimeSettingView) -> Int {
        switch view {
        case timeSettingView:
            return 600
        case restSettingView:
            return 30
        default: return 0
        }
    }
    
    func timeSettingView(_ view: TimeSettingView, changedTimeCount count: Int) {
        print("변경 된 시간 값은 \(count)")
    }
}
