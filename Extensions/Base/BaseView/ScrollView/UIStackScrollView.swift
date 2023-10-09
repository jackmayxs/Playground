//
//  UIStackScrollView.swift
//
//  Created by Choi on 2022/8/15.
//

import UIKit

class UIStackScrollView: UIBaseScrollView {
    
    class var defaultAxis: NSLayoutConstraint.Axis {
        .vertical
    }
    
    lazy var stackView = UIStackView(axis: Self.defaultAxis, distribution: .fill, alignment: .fill, spacing: 0.0)
    
    override var defaultContentView: UIView {
        stackView
    }
        
    override func prepare() {
        super.prepare()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    override func prepareConstraints() {
        super.prepareConstraints()
        stackView.snp.makeConstraints { make in
            switch axis {
            case .horizontal:
                make.height.equalToSuperview()
            case .vertical:
                make.width.equalToSuperview()
            @unknown default:
                break
            }
        }
    }
}

extension UIStackScrollView {
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: Double = 0, @ArrayBuilder<UIView> subviewsBuilder: () -> [UIView] = { [] }) {
        let arrangedSubviews = subviewsBuilder()
        self.init(axis: axis, spacing: spacing, arrangedSubviews: arrangedSubviews)
    }
    
    convenience init(
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0,
        @ArrayBuilder<UIView> subviewsBuilder: () -> [UIView] = { [] }) {
            let arrangedSubviews = subviewsBuilder()
            self.init(axis: Self.defaultAxis, distribution: distribution, alignment: alignment, spacing: spacing, arrangedSubviews: arrangedSubviews)
        }
    
    convenience init(
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0,
        arrangedSubviews: [UIView] = .empty) {
            self.init(frame: .zero)
            self.axis = axis
            self.distribution = distribution
            self.alignment = alignment
            self.spacing = spacing
            self.stackView.reArrangedSubviews = arrangedSubviews
        }
    
    var axis: NSLayoutConstraint.Axis {
        get { stackView.axis }
        set { stackView.axis = newValue }
    }
    
    var distribution: UIStackView.Distribution {
        get { stackView.distribution }
        set { stackView.distribution = newValue }
    }
    
    var alignment: UIStackView.Alignment {
        get { stackView.alignment }
        set { stackView.alignment = newValue }
    }
    
    var spacing: Double {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }
    
    var contentInsets: UIEdgeInsets? {
        get { stackView.contentInsets }
        set { stackView.contentInsets = newValue }
    }
    
    func reArrangeSubviews(@ArrayBuilder<UIView> subviewsBuilder: () -> [UIView]) {
        stackView.reArrange(subviewsBuilder)
    }
    
    func reArrangeSubviews(_ arrangedSubviews: [UIView]) {
        stackView.reArrange(arrangedSubviews)
    }
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { subview in
            addArrangedSubview(subview)
        }
    }
    
    func addArrangedSubview(_ subview: UIView) {
        stackView.addArrangedSubview(subview)
    }
}

// MARK: - 子类
class UIHStackScrollView: UIStackScrollView {
    final override class var defaultAxis: NSLayoutConstraint.Axis { .horizontal }
}
class UIVStackScrollView: UIStackScrollView {
    final override class var defaultAxis: NSLayoutConstraint.Axis { .vertical }
}
