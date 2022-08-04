//
//  BasePresentationController.swift
//  zeniko
//
//  Created by Choi on 2022/8/5.
//

import UIKit

class BasePresentationController: UIPresentationController {
    
    private lazy var maskView: UIView = {
        let mask = UIView()
        if let frame = containerView?.bounds {
            mask.frame = frame
        }
        mask.backgroundColor = .black.withAlphaComponent(0.5)
        return mask
    }()
    
    //决定了弹出框的frame
    override var frameOfPresentedViewInContainerView: CGRect {
        let height = 410.0
        return CGRect(
            x: 0,
            y: Size.screenHeight - height,
            width: Size.screenWidth,
            height: height
        )
    }

    //重写此方法可以在弹框即将显示时执行所需要的操作
    override func presentationTransitionWillBegin() {
        maskView.alpha = 0
        containerView?.addSubview(maskView)
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 1
        }
    }

    //重写此方法可以在弹框显示完毕时执行所需要的操作
    override func presentationTransitionDidEnd(_ completed: Bool) {
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(tappedMaskView))
        maskView.addGestureRecognizer(tapGuesture)
    }
    
    @objc func tappedMaskView() {
        presentedViewController.dismiss(animated: true)
    }

    //重写此方法可以在弹框即将消失时执行所需要的操作
    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
        }
    }

    //重写此方法可以在弹框消失之后执行所需要的操作
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            maskView.removeFromSuperview()
        }
    }
}
