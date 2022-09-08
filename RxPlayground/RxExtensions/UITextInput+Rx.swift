//
//  UITextInput+Rx.swift
//  RxPlayground
//
//  Created by Choi on 2022/4/20.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextView {
    var unmarkedText: Observable<String> {
        didChange
            .withUnretained(base)
            .map(\.0.unmarkedText)
            .orEmpty
            .distinctUntilChanged()
    }
}

extension Reactive where Base: UITextField {
    
    var observedText: Observable<String?> {
        /// 分别用于观察直接赋值时的文本变化和编辑时的文本变化
        Observable.merge(observe(\.text), text.observable)
    }
    
    var unmarkedText: Observable<String> {
        /// 注意这里observedText的后面不能加.distinctUntilChanged()操作符
        /// 否则拼音字符编辑完成后会出现unmarkedText事件不发送的问题
        /// 因为在输入拼音时,UITextField的.editingChanged事件会在拼音编辑完成时调用两次
        /// 只有第二次的时候才能获取到unmarkedText
        observedText
            .withUnretained(base)
            .map(\.0.unmarkedText)
            .distinctUntilChanged()
            .orEmpty
    }
}
