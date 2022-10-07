//
//  UIGetVerificationCodeButton.swift
//  zeniko
//
//  Created by Choi on 2022/8/5.
//

import UIKit
import RxSwift

class UIGetVerificationCodeButton: QMLoadingButton {

    private var timer: GCDTimer?
    
    private var remainSeconds = 1 {
        willSet {
            if newValue == 0 {
                isUserInteractionEnabled = true
                setTitle(localized.获取验证码~, for: .normal)
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
        setTitle(localized.获取验证码~, for: .normal)
        setTitleColor(.actionable, for: .normal)
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
