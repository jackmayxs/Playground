//
//  Array+Rx.swift
//  RxPlayground
//
//  Created by Choi on 2022/4/20.
//

import RxSwift
import RxCocoa

extension Array where Element: ObservableConvertibleType {
    var merged: Observable<Element.Element> {
        Observable.from(self).merge()
    }
}

// MARK: - __________ UIButton+Rx __________
extension Observable where Element: UIButton {
    func matches(button: UIButton) -> Observable<Bool> {
        map { $0 == button }
    }
}

extension Array where Element: UIButton {
    
    /// 返回选中按钮ControlProperty
    /// - Parameter firstSelected: 首次选中的按钮
    /// - Returns: ControlProperty<Element?>
    func selectedButton(startWith firstSelected: Element?) -> ControlProperty<Element?> {
        let values = switchSelectedButton(startWith: firstSelected).optionalElement
        let observer = AnyObserver<Element?> { event in
            switch event {
            case .next(let button) where button.isNotValid:
                first(where: \.isSelected)?.isSelected = false
            default:
                break
            }
        }
        return ControlProperty(values: values, valueSink: observer)
    }
    
    /// 切换选中的按钮
    /// - Parameter firstSelected: 第一个选中的按钮
    /// - Returns: 选中按钮的事件序列
    func switchSelectedButton(startWith firstSelected: Element? = nil) -> Observable<Element> {
        let selectedButton = tappedButton
            .optionalElement
            .startWith(firstSelected)
            .unwrapped
        let disposable = handleSelectedButton(selectedButton)
        return selectedButton.do(onDispose: disposable.dispose)
    }
    
    /// 切换选中的按钮
    /// - Parameter firstSelection: 按钮在数组中的索引
    /// - Returns: 选中按钮的事件序列
    func switchSelectedButton(startWith firstSelection: Self.Index) -> Observable<Element> {
        guard let selectedButton = itemAt(firstSelection) else {
            fatalError("Index out of range!")
        }
        return switchSelectedButton(startWith: selectedButton)
    }
    
    /// 处理按钮选中/反选
    /// - Parameter selectedButton: 选中按钮的事件序列
    /// - Returns: Disposable
    private func handleSelectedButton(_ selectedButton: Observable<Element>) -> Disposable {
        selectedButton
            .scan([]) { lastResult, button -> [Element] in
                /// 选中按钮
                button.isSelected = true
                var buttons = lastResult
                /// 按钮数组不包含按钮的时候,将点击的按钮添加到数组
                if buttons.contains(button).isFalse {
                    buttons.append(button)
                }
                if buttons.count == 2 {
                    /// 移除上一个按钮并取消选中
                    let lastSelected = buttons.removeFirst()
                    lastSelected.isSelected = false
                }
                return buttons
            }
            .subscribe()
    }
    
    var tappedButton: Observable<Element> {
        let buttonObservables = map { button in
            button.rx.tap.map { button }
        }
        return Observable.from(buttonObservables).merge()
    }
}
