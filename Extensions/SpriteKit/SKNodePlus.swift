//
//  SKNodePlus.swift
//
//  Created by Choi on 2023/8/23.
//

import UIKit
import SpriteKit

extension SKNode {
    static let defaultAnchorPoint = CGPoint(x: 0.5, y: 0.5)
}

extension SKNode {
    
    /// 开启 | 关闭手势
    /// - Parameter enabled: 是否启用顶层SKView的手势
    func setGesturesEnabled(_ enabled: Bool) {
        if let gestures = scene?.view?.gestureRecognizers {
            gestures.forEach { gesture in
                gesture.isEnabled = enabled
            }
        }
    }
    
    func purge() {
        for child in children {
            child.purge()
        }
        removeAllChildren()
    }
    
    func replaceAction(_ action: SKAction, withKey actionKey: String) {
        if let _ = self.action(forKey: actionKey) {
            removeAction(forKey: actionKey)
        }
        run(action, withKey: actionKey)
    }
    
    func reposition(to corner: UIRectCorner, xInset: CGFloat, yInset: CGFloat) {
        guard let parent else { return }
        lazy var parentFrame = parent.frame
        lazy var parentWidth = parentFrame.width
        lazy var parentHeight = parentFrame.height
        var origin = CGPoint.zero
        switch corner {
        case .topLeft:
            origin.x = xInset
            origin.y = yInset
        case .topRight:
            origin.x = parentWidth - xInset - width
            origin.y = yInset
        case .bottomLeft:
            origin.x = xInset
            origin.y = parentHeight - yInset - height
        case .bottomRight:
            origin.x = parentWidth - xInset - width
            origin.y = parentHeight - yInset - height
        default:
            break
        }
        reposition(to: origin)
    }
    
    func reposition(to edge: UIRectEdge, inset: CGFloat) {
        guard let parent else { return }
        lazy var parentFrame = parent.frame
        lazy var parentWidth = parentFrame.width
        lazy var parentHeight = parentFrame.height
        switch edge {
        case .top:
            repositionY(inset)
        case .left:
            repositionX(inset)
        case .bottom:
            repositionY(parentHeight - inset - height)
        case .right:
            repositionX(parentWidth - inset - width)
        default:
            break
        }
    }
    
    /// 重新布局
    /// - Parameter origin: UIKit坐标系下的原点位置
    func reposition(to origin: CGPoint) {
        guard let parent else { return }
        let x = origin.x + width.half
        let y = parent.frame.height - origin.y - height.half
        position = CGPoint(x: x, y: y)
    }
    
    /// 重新布局y坐标
    /// - Parameter y: UIKit坐标系下的y坐标
    func repositionY(_ y: CGFloat) {
        guard let parent else { return }
        position.y = parentAnchorPoint.y * parentHeight
    }
    
    /// 重新布局x坐标
    /// - Parameter x: UIKit坐标系下的x坐标
    func repositionX(_ x: CGFloat) {
        guard parent.isValid else { return }
        position.x = x + (parentAnchorPoint.x - 1.0) * parentWidth
    }
    
    /// 是否接近重合
    /// - Parameter another: 另一个节点
    /// - Returns: 是否接近重合
    func almostOverlap(_ node: SKNode) -> Bool {
        frame.intersection(node.frame).area > node.frame.area / 4.0
    }
    
    var scale: CGFloat {
        get { xScale }
        set {
            setScale(newValue)
        }
    }
    
    /// 五个定位锚点 | 用于计算贴合最近的格子
    var anchorPoints: [CGPoint] {
        [position, topLeft, bottomLeft, bottomRight, topRight]
    }
    /// 定位锚点
    var topLeft: CGPoint {
        CGPoint(x: x - width.half, y: y + height.half)
    }
    /// 定位锚点
    var topRight: CGPoint {
        CGPoint(x: x + width.half, y: y + height.half)
    }
    /// 定位锚点
    var bottomLeft: CGPoint {
        CGPoint(x: x - width.half, y: y - height.half)
    }
    /// 定位锚点
    var bottomRight: CGPoint {
        CGPoint(x: x + width.half, y: y - height.half)
    }
    /// position.x
    var x: CGFloat { position.x }
    /// position.y
    var y: CGFloat { position.y }
    
    var height: CGFloat { frame.height }
    
    var width: CGFloat { frame.width }
    
    var parentWidth: CGFloat { parentSize.width }
    
    var parentHeight: CGFloat { parentSize.height }
    
    var parentSize: CGSize { parentFrame.size }
    
    /// 父节点的Frame
    var parentFrame: CGRect {
        parent.or(.zero, else: \.frame)
    }
    
    /// 父节点的AnchorPoint
    var parentAnchorPoint: CGPoint {
        parent.or(SKNode.defaultAnchorPoint) { parent in
            if let scene = parent as? SKScene {
                return scene.anchorPoint
            } else if let sprite = parent as? SKSpriteNode {
                return sprite.anchorPoint
            } else {
                return SKNode.defaultAnchorPoint
            }
        }
    }
}
