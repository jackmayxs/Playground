//
//  UIStackScrollView.swift
//  zeniko
//
//  Created by Choi on 2022/8/15.
//

import UIKit

class UIStackScrollView: UIBaseView {
    
    var axis: NSLayoutConstraint.Axis {
        willSet { stackView.axis = newValue }
    }
    
    var spacing: Double {
        willSet { stackView.spacing = newValue }
    }
    
    override var backgroundColor: UIColor? {
        get { scrollView.backgroundColor }
        set { scrollView.backgroundColor = newValue }
    }
    
    var contentInsets: UIEdgeInsets? {
        get { stackView.contentInsets }
        set { stackView.contentInsets = newValue }
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    override init(frame: CGRect) {
        self.spacing = 0
        self.axis = .vertical
        super.init(frame: frame)
    }
    
    init(axis: NSLayoutConstraint.Axis, spacing: Double = 0, @ArrayBuilder<UIView> subviewsBuilder: () -> [UIView] = { [] }) {
        self.axis = axis
        self.spacing = spacing
        super.init(frame: .zero)
        stackView.add(content: subviewsBuilder)
    }
    
    func refillSubviews(@ArrayBuilder<UIView> subviewsBuilder: () -> [UIView]) {
        stackView.refill(content: subviewsBuilder)
    }
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { subview in
            addArrangedSubview(subview)
        }
    }
    
    func addArrangedSubview(_ subview: UIView) {
        stackView.addArrangedSubview(subview)
    }
    
    let scrollView = TouchesDelayedScrollView.make { make in
        make.alwaysBounceVertical = true
    }
    lazy var stackView = UIStackView(
        axis: axis,
        distribution: .fill,
        alignment: .fill,
        spacing: spacing)
    
    override func prepare() {
        super.prepare()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = defaultBackgroundColor
    }
    
    override func prepareSubviews() {
        super.prepareSubviews()
        scrollView.addSubview(stackView)
        addSubview(scrollView)
    }
    
    
    override func prepareConstraints() {
        super.prepareConstraints()
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

class UIVerticalStackScrollView: UIStackScrollView {
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    override init(frame: CGRect) {
        super.init(axis: .vertical)
    }
    
    init(spacing: Double = 0, @ArrayBuilder<UIView> subviewsBuilder: () -> [UIView] = { [] }) {
        super.init(axis: .vertical, spacing: spacing, subviewsBuilder: subviewsBuilder)
    }
}
