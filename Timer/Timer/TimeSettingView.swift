//
//  TimeSettingView.swift
//  Timer
//
//  Created by Sanghyeon Park on 1/31/24.
//

import UIKit

protocol TimeSettingViewDelegate {
    /// 시간 카운트가 변경 될 때마다 실행되는 메소드
    func timeSettingView(_ view: TimeSettingView, changedTimeCount count:Int)
    /// 최대 시간 카운트 지정
    func timeSettingView(maximumOfTimeCount view: TimeSettingView) -> Int
}

class TimeSettingView: UIView {
    
    // MARK: Properties
    
    var delegate: TimeSettingViewDelegate?
    
    /// 최대 시간 설정
    private var maximumTimeCount: Int {
        guard let count = delegate?.timeSettingView(maximumOfTimeCount: self) else {
            return 0
        }
        titleDescLabel.text = "최대 \(count)\(timeUnitText)까지 설정할 수 있습니다."
        return count
    }
    
    /// 시간 지정
    private var timeCount: Int = 0 {
        didSet {
            timeLabel.text = "\(timeCount)"
        }
    }
    
    /// 타이틀 텍스트 지정
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    /// 시간 유닛 텍스트 지정
    var timeUnitText: String = "분" {
        didSet {
            timeUnitLabel.text = timeUnitText
        }
    }

    /// 설정된 타이머 카운트 반환
    var settedCount: Int {
        get {
            return timeCount
        }
    }
    
    /// 버튼 롱클릭시 숫자 증가를 위한 타이머 설정
    private var timer: Timer?
    
    
    // MARK: View Define
    
    var buttonConfiguration: UIButton.Configuration = {
        var buttonConfiguration: UIButton.Configuration = .plain()
        buttonConfiguration.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        return buttonConfiguration
    }()
    
    // 컨테이너 뷰
    private let containerView: UIView = {
        let containerView: UIView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    // 타이틀 레이블
    private let titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    // 타이틀 설명 레이블
    private let titleDescLabel: UILabel = {
        let titleDescLabel = UILabel()
        titleDescLabel.textColor = .systemGray3
        titleDescLabel.font = .preferredFont(forTextStyle: .body)
        titleDescLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleDescLabel
    }()
    
    // 시간 감소 버튼
    private lazy var decreaseButton: UIButton = {
        let decreaseButton: UIButton = UIButton(configuration: buttonConfiguration)
        decreaseButton.setImage(UIImage(systemName: "minus"), for: .normal)
        decreaseButton.tintColor = .black
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        return decreaseButton
    }()
    
    // 시간 증가 버튼
    private lazy var increaseButton: UIButton = {
        let increaseButton: UIButton = UIButton(configuration: buttonConfiguration)
        increaseButton.setImage(UIImage(systemName: "plus"), for: .normal)
        increaseButton.tintColor = .black
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        return increaseButton
    }()

    // 시간(숫자) 레이블
    private let timeLabel: UILabel = {
        let timeLabel: UILabel = UILabel()
        timeLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 60, weight: .light)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
    
    // 시간 단위 레이블
    private let timeUnitLabel: UILabel = {
        let timeUnitLabel: UILabel = UILabel()
        timeUnitLabel.textColor = .black
        timeUnitLabel.font = .preferredFont(forTextStyle: .title2)
        timeUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeUnitLabel
    }()
    
    
    // MARK: View Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        increaseButton.addTarget(self, action: #selector(touchUpInOutsideButton), for: .touchUpOutside)
        increaseButton.addTarget(self, action: #selector(touchDownIncreaseButton), for: .touchDown)
        increaseButton.addTarget(self, action: #selector(touchUpInsideButton), for: .touchUpInside)
        
        decreaseButton.addTarget(self, action: #selector(touchUpInOutsideButton), for: .touchUpOutside)
        decreaseButton.addTarget(self, action: #selector(touchDownDecreaseButton), for: .touchDown)
        decreaseButton.addTarget(self, action: #selector(touchUpInsideButton), for: .touchUpInside)
        
        timeLabel.text = "\(timeCount)"
        timeUnitLabel.text = "\(timeUnitText)"

        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(timeUnitLabel)
        containerView.addSubview(increaseButton)
        containerView.addSubview(decreaseButton)
        containerView.addSubview(titleDescLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            increaseButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            increaseButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            timeUnitLabel.trailingAnchor.constraint(equalTo: increaseButton.leadingAnchor, constant: -20),
            timeUnitLabel.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            
            timeLabel.trailingAnchor.constraint(equalTo: timeUnitLabel.leadingAnchor, constant: -10),
            timeLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            decreaseButton.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -20),
            decreaseButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            
            titleDescLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleDescLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Function

extension TimeSettingView {
    @objc func didTapButton(_ sender: UIButton) {
        switch sender {
        case increaseButton:
            increaseCount()
        case decreaseButton:
            decreaseCount()
        default: break
        }
        touchUpInOutsideButton()
    }
    
    @objc func increaseCount() {
        guard timeCount < maximumTimeCount else { return }
        timeCount += 1
    }
    
    @objc func decreaseCount() {
        guard timeCount > 0 else { return }
        timeCount -= 1
    }
    
    @objc func touchUpInsideButton(_ sender: UIButton) {
        switch sender {
        case increaseButton:
            increaseCount()
        case decreaseButton:
            decreaseCount()
        default: break
        }
        touchUpInOutsideButton()
    }
    
    @objc func touchDownIncreaseButton(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(increaseCount), userInfo: nil, repeats: true)
    }
    
    @objc func touchDownDecreaseButton(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseCount), userInfo: nil, repeats: true)
    }
    
    @objc func touchUpInOutsideButton() {
        timer?.invalidate()
        timer = nil
        delegate?.timeSettingView(self, changedTimeCount: timeCount)
    }
}

