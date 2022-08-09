//
//  UIGetVerificationCodeButton.swift
//  zeniko
//
//  Created by Choi on 2022/8/5.
//

import UIKit

class UIGetVerificationCodeButton: QMLoadingButton {

    private var remainSeconds = 1 {
        willSet {
            if newValue == 0 {
                isUserInteractionEnabled = true
                setTitle("获取验证码".localized, for: .normal)
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
        setTitle("获取验证码".localized, for: .normal)
        setTitleColor(.actionable, for: .normal)
        addTarget(self, action: #selector(countDown), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func countDown() {
        remainSeconds = 60
        isUserInteractionEnabled = false
        GCDTimer.scheduledTimer(timeInterval: .seconds(1)) {
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

}
