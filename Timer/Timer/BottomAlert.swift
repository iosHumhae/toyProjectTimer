//
//  BottomAlert.swift
//  Timer
//
//  Created by Sanghyeon Park on 1/31/24.
//

import UIKit

final class BottomAlert {
    
    // MARK: Private Properties
    
    /// 바텀 알럿 매니저
    private var manager: BottomAlertManager = BottomAlertManager.shared
    
    /// 타겟 뷰컨트롤러
    private var viewController: UIViewController
    
    /// 알림 내용
    private var title: String
    /// 애니메이션 적용시 속도
    private var duration: Double
    /// 애니메이션 적용 여부
    private var isAnimation: Bool
    
    /// 알림의 배경 색상
    private var backgroundColor: UIColor = .systemIndigo
    
    
    // MARK: View Properties
    private var containerView: UIView = UIView()
    private var alertLabel: UILabel = UILabel()
    
    
    init(title: String, duration: Double = 0.5, isAnimation: Bool = true, _ viewController: UIViewController) {
        self.title = title
        self.duration = duration
        self.isAnimation = isAnimation
        self.viewController = viewController
    }
}

// MARK: - Public Function

extension BottomAlert {

    func showAlert() {
        manager.dismissBottomAlert()
        
        setupAlertView()
        
        viewController.view.addSubview(containerView)
        containerView.addSubview(alertLabel)
        
        manager.addBottomAlert(self)

        // 1. AlertView를 화면 바닥 아래에 위치시키는 제약 조건을 생성합니다.
        let initialConstraint = containerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: 300)
        let finalConstraint = containerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            initialConstraint,
            containerView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),

            alertLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            alertLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            alertLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 20),
            alertLabel.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        viewController.view.layoutIfNeeded() // 즉시 레이아웃 변경을 적용

        // 2. 애니메이션을 통해 AlertView를 원하는 위치로 이동시킵니다.
        UIView.animate(withDuration: 1, animations: {
            // 초기 제약 조건을 비활성화하고 새로운 제약 조건을 활성화합니다.
            NSLayoutConstraint.deactivate([initialConstraint])
            NSLayoutConstraint.activate([finalConstraint])

            self.viewController.view.layoutIfNeeded() // 애니메이션을 적용
        })
    }


    
    /// 배경 색깔 지정
    func setBackgroundColor(color backgroundColor: UIColor = .systemIndigo) {
        self.backgroundColor = backgroundColor
    }
    
    /// 알림 레이블 스타일 설정
    func setAlertLabelStyle(font: UIFont = .preferredFont(forTextStyle: .title3), color labelColor: UIColor = .white, alignment textAlignment: NSTextAlignment = .left) {
        alertLabel.font = font
        alertLabel.textColor = labelColor
        alertLabel.textAlignment = textAlignment
    }

    /// 매니저에게 전달하기 위한 AlertView 반환
    func alertView() -> UIView {
        return containerView
    }
}

// MARK: - Private Function

extension BottomAlert {
    private func setupAlertView() {
        containerView = {
            let alertView: UIView = UIView()
            alertView.backgroundColor = backgroundColor
            alertView.translatesAutoresizingMaskIntoConstraints = false
            return alertView
        }()
        
        alertLabel.text = title
        alertLabel.textColor = .white
        alertLabel.font = .preferredFont(forTextStyle: .body)
        alertLabel.textAlignment = .left
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
