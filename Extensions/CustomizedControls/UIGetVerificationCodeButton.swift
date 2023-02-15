//
//  UIGetVerificationCodeButton.swift
//  zeniko
//
//  Created by Choi on 2022/8/5.
//

import UIKit
import RxSwift
import RxCocoa

class UIGetVerificationCodeButton: QMLoadingButton {

    private var timer: GCDTimer?
    
    @Variable private var resignActiveDate: Date?
    @Variable private var activeDate: Date?
    
    private var remainSeconds = 1 {
        willSet {
            if newValue <= 0 {
                isUserInteractionEnabled = true
                setTitle(localized.com_GET_VERIFICATION_CODE~, for: .normal)
                if let timer {
                    timer.invalidate()
                }
            } else {
                let title = LocalizationManager.shared.localized(remainSeconds: newValue)
                setTitle(title, for: .normal)
            }
            superview?.setNeedsLayout()
            superview?.superview?.setNeedsLayout()
        }
    }
    
    init() {
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 14.0)
        setTitle(localized.com_GET_VERIFICATION_CODE~, for: .normal)
        setTitleColor(.actionable, for: .normal)
        
        rx.disposeBag.insert {
            Observable.combineLatest($resignActiveDate.unwrapped, $activeDate.unwrapped)
                .map { resign, active -> Int in
                    guard active >= resign else { return 0 }
                    return active.timeIntervalSince(resign).int
                }
                .filter(\.isPositive)
                .bind {
                    [unowned self] passedSeconds in
                    remainSeconds -= passedSeconds
                }
            
            NotificationCenter.default.rx
                .notification(UIApplication.didEnterBackgroundNotification)
                .map { note in
                    Date.now
                }
                .bind(to: rx.resignActiveDate)
            
            NotificationCenter.default.rx
                .notification(UIApplication.willEnterForegroundNotification)
                .map { note in
                    Date.now
                }
                .bind(to: rx.activeDate)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func countDown() {
        remainSeconds = 60
        isUserInteractionEnabled = false
        timer = GCDTimer.scheduledTimer(timeInterval: .seconds(1)) {
            [weak self] timer in
            guard let button = self else {
                timer.invalidate()
                return
            }
            button.remainSeconds -= 1
            if button.remainSeconds == 0 {
                timer.invalidate()
            }
        }
    }
    
    func clear() {
        if let timer {
            timer.invalidate()
        }
        remainSeconds = 0
    }

}
