//
//  BottomAlertManager.swift
//  Timer
//
//  Created by Sanghyeon Park on 1/31/24.
//

import UIKit

final class BottomAlertManager {
    static let shared: BottomAlertManager = BottomAlertManager()
    
    private var currentBottomAlert: BottomAlert?
    
    func dismissBottomAlert() {
        guard let bottomAlert = currentBottomAlert else { return }
        bottomAlert.alertView().removeFromSuperview()
        currentBottomAlert = nil
    }
    
    func addBottomAlert(_ alert: BottomAlert) {
        currentBottomAlert = alert
    }
}
