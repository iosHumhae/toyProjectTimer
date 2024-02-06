//
//  TimerService.swift
//  Timer
//
//  Created by Sanghyeon Park on 2/1/24.
//

// 타이머를 중단했다가 다시 실행하면 속도가 빨라지는 문제가 있지만, 아직은 해결 할 자신이 없음.

import Foundation

protocol TimerServiceDelegate {
    /// 타이머의 시간이 변경 될때마다 실행되는 메소드
    func timerService(service: TimerService, timerChanged timer: TimerModel, count: Int, limitCount: Int)
    /// 타이머의 작동이 끝날때 실행되는 메소드
    func timerService(service: TimerService, timerEnded count: Int)
}

class TimerService {
    // 싱글톤 패턴
    static let shared = TimerService()
    
    // MARK: Public Properties
    
    var delegate: TimerServiceDelegate?
    /// 타이머가 작동중인지 반환
    var isRunning: Bool {
        get {
            return isTimerRunning
        }
    }
    /// 현재 돌아가고 있는 타이머를 반환
    var currentTimer: TimerModel {
        get {
            return timerIntervals[currentTimerIntervalIndex]
        }
    }
    
    // MARK: Private Properties
    
    private var timer: Timer? = nil
    private var timerType: TimerType = .multi
    private var timerIntervals: [TimerModel] = []
    private var currentTimerIntervalIndex: Int = 0
    private var currentTimerInterval: Int = 0
    private var isTimerRunning: Bool = false
    private var isTimerLoop: Bool = false
}

extension TimerService {
    /// 타이머 설정
    func setTimer(multiCount timers: [TimerModel], isLoop: Bool = true) {
        resetTimer()
        timerType = .multi
        isTimerLoop = isLoop
        timers.forEach { count in
            timerIntervals.append(count)
        }
    }
    
    func setTimer(singleCount timer: TimerModel) {
        resetTimer()
        timerType = .single
        timerIntervals.append(timer)
    }
    
    /// 타이머 중단
    func stopTimer() {
        removeTimer()
    }
    
    /// 타이머 실행
    func startTimer(timerIndex: Int = 0) {
        guard !isTimerRunning else {
            removeTimer()
            return
        }
        
        isTimerRunning = true
        
        currentTimerInterval = timerIntervals[timerIndex].interval
        timerSelector()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSelector), userInfo: self, repeats: true)
    }
    
    /// 타이머 재시작
    func restartTimer() {
        isTimerRunning = true
        timerSelector()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSelector), userInfo: self, repeats: true)
    }
    
    /// 타이머 리셋
    private func resetTimer() {
        removeTimer()
        timerIntervals.removeAll()
    }
    
    /// 타이머 제거
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    /// 타이머
    @objc private func timerSelector() {
        guard isTimerRunning else { return }
        
        print("currentTimerIntervalIndex: \(currentTimerIntervalIndex)")
        
        delegate?.timerService(service: self, timerChanged: timerIntervals[currentTimerIntervalIndex], count: currentTimerInterval, limitCount: timerIntervals[0].interval)
        currentTimerInterval -= 1
        
        // 타이머가 종료 되었다
        if currentTimerInterval < -1 {
            isTimerRunning = false
            delegate?.timerService(service: self, timerEnded: timerIntervals[0].interval)
            // 타이머 타입에 따른 분기처리
            switch timerType {
            case .single:
                resetTimer()
            case .multi:
                removeTimer()
                // 다음 진행할 타이머가 있는가?
                if currentTimerIntervalIndex < timerIntervals.count - 1 {
                    currentTimerIntervalIndex += 1
                    startTimer(timerIndex: currentTimerIntervalIndex)
                } else {
                    if isTimerLoop {
                        // 타이머 반복인가?
                        currentTimerIntervalIndex = 0
                        startTimer(timerIndex: currentTimerIntervalIndex)
                    }
                }
            }
        }

    }
}
