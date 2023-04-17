//
//  ControllerPresentor.swift
//  KnowLED
//
//  Created by Choi on 2023/4/17.
//

import UIKit
import Jelly

struct ControllerPresentor {

    weak var presentingController: UIViewController!
    
    init(presentingController: UIViewController) {
        self.presentingController = presentingController
    }
    
    func pageSheet(
        _ controller: PresentedControllerType,
        presentationSize: CGSize? = nil,
        alignment: PresentationAlignment = .centerAlignment,
        tapToDismiss: Bool = true) {
            let screenSize = Size.screenSize
            let defaultWidth = min(screenSize.width * 0.676, 730.0)
            let defaultHight = min(screenSize.height * 0.869, 704.0)
            let defaultSize = CGSize(width: defaultWidth, height: defaultHight)
            let size = presentationSize.or(defaultSize).presentationSize
            let presentation = CoverPresentation(
                directionShow: .bottom,
                directionDismiss: .bottom,
                uiConfiguration: PresentationUIConfiguration(
                    cornerRadius: 10,
                    backgroundStyle: .dimmed(alpha: 0.7),
                    isTapBackgroundToDismissEnabled: tapToDismiss
                ),
                size: size,
                alignment: alignment,
                timing: PresentationTiming(duration: .custom(duration: 0.4), presentationCurve: .easeInOut, dismissCurve: .easeOut)
            )
            let animator = JellyAnimator(presentation: presentation)
            controller.prepareAnimator(animator)
            presentingController.present(controller, animated: true)
        }
    
    func fadeIn(_ controller: PresentedControllerType, tapBackgroundToDismissEnabled: Bool = true) {
        let fade = FadePresentation(
            size: controller.preferredContentSize.presentationSize,
            ui: PresentationUIConfiguration(
                cornerRadius: 6,
                backgroundStyle: .dimmed(alpha: 0.7),
                isTapBackgroundToDismissEnabled: tapBackgroundToDismissEnabled,
                corners: .allCorners
            )
        )
        let animator = JellyAnimator(presentation: fade)
        controller.prepareAnimator(animator)
        presentingController.present(controller, animated: true)
    }
    
    func popDialog(tapBackgroundToDismissEnabled: Bool = true, @SingleValueBuilder<PresentedControllerType> _ controllerBuilder: () -> PresentedControllerType) {
        let controller = controllerBuilder()
        popDialog(controller)
    }
    
    func popDialog(_ controller: PresentedControllerType, tapBackgroundToDismissEnabled: Bool = true) {
        let fade = FadePresentation(
            size: controller.preferredContentSize.presentationSize,
            timing: PresentationTiming(
                duration: .custom(duration: 0.25),
                presentationCurve: .easeInOut,
                dismissCurve: .easeInOut
            ),
            ui: PresentationUIConfiguration(
                cornerRadius: 6,
                backgroundStyle: .dimmed(alpha: 0.7),
                isTapBackgroundToDismissEnabled: tapBackgroundToDismissEnabled,
                corners: .allCorners
            )
        )
        let animator = JellyAnimator(presentation: fade)
        controller.prepareAnimator(animator)
        presentingController.present(controller, animated: true)
    }
    
    func slideIn(@SingleValueBuilder<PresentedControllerType> _ controllerBuilder: () -> PresentedControllerType) {
        let controller = controllerBuilder()
        slideIn(controller)
    }
    
    func slideIn(_ controller: PresentedControllerType, from direction: Direction) {
        let presentation = CoverPresentation(
            directionShow: direction,
            directionDismiss: direction,
            uiConfiguration: PresentationUIConfiguration(
                cornerRadius: 0,
                backgroundStyle: .dimmed(alpha: 0.7),
                isTapBackgroundToDismissEnabled: true
            ),
            size: controller.preferredContentSize.presentationSize,
            alignment: PresentationAlignment(vertical: .center, horizontal: .right),
            timing: PresentationTiming(duration: .normal, presentationCurve: .easeIn, dismissCurve: .easeOut)
        )
        let animator = JellyAnimator(presentation: presentation)
        controller.prepareAnimator(animator)
        presentingController.present(controller, animated: true)
    }
    
    func slideIn(_ controller: PresentedControllerType) {
        let presentation = CoverPresentation(
            directionShow: .bottom,
            directionDismiss: .bottom,
            uiConfiguration: PresentationUIConfiguration(
                cornerRadius: 20,
                backgroundStyle: .dimmed(alpha: 0.7),
                isTapBackgroundToDismissEnabled: true,
                corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            ),
            size: controller.preferredContentSize.presentationSize,
            alignment: PresentationAlignment(vertical: .bottom, horizontal: .center),
            timing: PresentationTiming(duration: .normal, presentationCurve: .easeIn, dismissCurve: .easeOut)
        )
        let animator = JellyAnimator(presentation: presentation)
        controller.prepareAnimator(animator)
        presentingController.present(controller, animated: true)
    }
}
