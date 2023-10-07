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
    
    /// 位置变动时更新位置
    /// - Parameter newPosition: 新位置
    func rePositionIfNeeded(_ newPosition: CGPoint) {
        guard newPosition != position else { return }
        position = newPosition
    }
    
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
    
    private func reposition(to corner: UIRectCorner, xInset: CGFloat, yInset: CGFloat) {
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
    
    private func reposition(to edge: UIRectEdge, inset: CGFloat) {
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
    private func reposition(to origin: CGPoint, other: Int? = nil) {
        let x = origin.x + width.half
        let y = -origin.y - height.half
        position = CGPoint(x: x, y: y)
    }
    
    /// 重新布局y坐标
    /// - Parameter y: UIKit坐标系下的y坐标
    private func repositionY(_ y: CGFloat) {
        position.y = -y - height.half
    }
    
    /// 重新布局x坐标
    /// - Parameter x: UIKit坐标系下的x坐标
    private func repositionX(_ x: CGFloat) {
        guard parent.isValid else { return }
        position.x = x + width.half
    }
    
    /// 是否接近重合 | 适用于两个节点宽高相同的情况
    /// - Parameter another: 另一个节点
    /// - Returns: 重合部分的面积
    func almostOverlap(_ node: SKNode) -> CGFloat? {
        let intersectionArea = frame.intersection(node.frame).area
        guard intersectionArea >= node.frame.area / 4.0 else { return nil }
        return intersectionArea
    }
    
    var scale: CGFloat {
        get { xScale }
        set {
            setScale(newValue)
        }
    }
    
    /// 五个定位锚点 | 用于计算贴合最近的格子
    var anchorPoints: [CGPoint] {
        [center, topLeft, bottomLeft, bottomRight, topRight]
    }
    
    /// 根据position计算出的相对于父节点的中心点
    var center: CGPoint {
        get {
            let dx = anchorBottomLeftOffsetX - width.half
            let dy = anchorBottomLeftOffsetY - height.half
            let centerX = position.x - dx
            let centerY = position.y - dy
            return CGPoint(x: centerX, y: centerY)
        }
        set {
            let dx = anchorBottomLeftOffsetX - width.half
            let dy = anchorBottomLeftOffsetY - height.half
            let positionX = newValue.x + dx
            let positionY = newValue.y + dy
            position = CGPoint(x: positionX, y: positionY)
        }
    }
    
    /// 定位锚点 | 左上角(在父节点中的位置)
    var topLeft: CGPoint {
        let x = position.x - anchorBottomLeftOffsetX
        let y = position.y + anchorTopRightOffsetY
        return CGPoint(x: x, y: y)
    }
    
    /// 定位锚点 | 右上角(在父节点中的位置)
    var topRight: CGPoint {
        let x = position.x + anchorTopRightOffsetX
        let y = position.y + anchorTopRightOffsetY
        return CGPoint(x: x, y: y)
    }
    
    /// 定位锚点 | 左下角(在父节点中的位置)
    var bottomLeft: CGPoint {
        let x = position.x - anchorBottomLeftOffsetX
        let y = position.y - anchorBottomLeftOffsetY
        return CGPoint(x: x, y: y)
    }
    
    /// 定位锚点 | 右下角(在父节点中的位置)
    var bottomRight: CGPoint {
        let x = position.x + anchorTopRightOffsetX
        let y = position.y - anchorBottomLeftOffsetY
        return CGPoint(x: x, y: y)
    }
    
    /// anchorPoint 距离右上角为原点的两条坐标轴的距离Y
    private var anchorTopRightOffsetY: CGFloat {
        height - anchorBottomLeftOffsetY
    }
    
    /// anchorPoint 距离左下角为原点的两条坐标轴的距离Y
    private var anchorBottomLeftOffsetY: CGFloat {
        height * calculatedAnchorPoint.y
    }
    
    /// anchorPoint 距离右上角为原点的两条坐标轴的距离X
    private var anchorTopRightOffsetX: CGFloat {
        width - anchorBottomLeftOffsetX
    }
    
    /// anchorPoint 距离左下角为原点的两条坐标轴的距离X
    private var anchorBottomLeftOffsetX: CGFloat {
        width * calculatedAnchorPoint.x
    }
    /// position.x
    var x: CGFloat { position.x }
    /// position.y
    var y: CGFloat { position.y }
    
    var height: CGFloat { frame.height }
    
    var width: CGFloat { frame.width }
    
    /// 返回以左上角为origin的Rect再按照X轴线翻转的Rect
    var flippedUIFrame: CGRect {
        uiFrame.flipped
    }
    
    /// 以左上角为origin的Rect | 原本的frame属性的origin是左下角
    var uiFrame: CGRect {
        CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: frame.height)
    }
    
    var parentWidth: CGFloat { parentSize.width }
    
    var parentHeight: CGFloat { parentSize.height }
    
    var parentSize: CGSize { parentFrame.size }
    
    /// 父节点的Frame
    var parentFrame: CGRect {
        parent.or(.zero, else: \.frame)
    }
    
    /// 父节点的AnchorPoint
    var parentAnchorPoint: CGPoint? {
        guard let parent else { return nil }
        if let scene = parent as? SKScene {
            return scene.anchorPoint
        } else if let sprite = parent as? SKSpriteNode {
            return sprite.anchorPoint
        } else {
            return SKNode.defaultAnchorPoint
        }
    }
    
    /// 根据计算得出的anchorPoint
    var calculatedAnchorPoint: CGPoint {
        if let scene = self as? SKScene {
            return scene.anchorPoint.checked
        } else if let sprite = self as? SKSpriteNode {
            return sprite.anchorPoint.checked
        } else {
            return SKNode.defaultAnchorPoint
        }
    }
}

extension CGPoint {
    
    fileprivate var checked: CGPoint {
        let range = 0...1.0
        let x = range << x
        let y = range << y
        return CGPoint(x: x, y: y)
    }
}
