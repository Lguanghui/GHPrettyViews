//
//  AlbumShadowView.swift
//  
//
//  Created by 梁光辉 on 2022/2/20.
//

import UIKit
import SnapKit

/// 影子视图的配置
@objcMembers
public class AlbumShadowViewConfig: NSObject {
    /// 每一层影子的边缘向内偏移量
    public var margin: CGFloat = 8.0
    /// 每一层影子的边缘向外偏移量
    public var offset: CGFloat = 6.0
    /// 影子数量
    public var count: Int = 2
    /// 影子背景颜色
    public var color: UIColor = .white
    /// 第一层影子透明度
    public var colorAlpha: CGFloat = 0.32
    /// 影子圆角
    public var cornerRadius: CGFloat = 6.0
    /// 在哪个方向添加影子
    public var orientation: ShadowOrientation = .bottom
    /// 颜色透明度递减值
    public var colorAlphaDecreasePercent: CGFloat = 0.0
    
    /// 是否在影子上添加外阴影
    public var shouldAddShadow: Bool = false
    public var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.02)
    public var shadowOffset: CGSize = CGSize(width: 0, height: 2)
    public var shadowOpacity: Float = 1.0
    public var shadowRadius: CGFloat = 4.0
    
    /// 朝向
    @objc public enum ShadowOrientation: Int {
        case top = 0
        case bottom
        case left
        case right
    }
    
    override public init() {
        super.init()
    }
    
    public convenience init(margin: CGFloat, offset: CGFloat, count: Int = 2, orientation: ShadowOrientation, color: UIColor, colorAlpha: CGFloat, cornerRadius: CGFloat = 6, colorAlphaDecreasePercent: CGFloat = 0.0, shouldAddShadow: Bool) {
        self.init()
        self.margin = margin
        self.offset = offset
        self.count = count
        self.orientation = orientation
        self.color = color
        self.colorAlpha = colorAlpha
        self.cornerRadius = cornerRadius
        self.colorAlphaDecreasePercent = colorAlphaDecreasePercent
        self.shouldAddShadow = shouldAddShadow
    }
}

/// 封面图 / 合集视图的影子效果。可添加在上下左右四个方向
@objcMembers
public class AlbumShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with config: AlbumShadowViewConfig, index: Int) {
        self.init()
        var alpha: CGFloat = config.colorAlpha - CGFloat(index - 1) * config.colorAlphaDecreasePercent
        if alpha < 0 {
            alpha = 0
        }
        backgroundColor = config.color.withAlphaComponent(alpha)
        layer.cornerRadius = config.cornerRadius
        
        if config.shouldAddShadow {
            let shadowLayer = CALayer()
            shadowLayer.shadowColor = config.shadowColor.cgColor
            shadowLayer.shadowOffset = config.shadowOffset
            shadowLayer.shadowRadius = config.shadowRadius
            shadowLayer.shadowOpacity = config.shadowOpacity
            layer.addSublayer(shadowLayer)
        }
    }
    
    /// 在目标视图上安装影子效果
    /// - Parameters:
    ///   - superView: 为了不影响目标视图的四周阴影效果，影子会添加在目标视图的父视图上
    ///   - targetView: 目标视图
    ///   - config: 配置
    public class func install(onSuperView superView: UIView, forTargetView targetView: UIView, withConfig config: AlbumShadowViewConfig) {
        if config.count < 1 {
            return
        }
        weak var lastView: UIView?
        // 默认添加在底部
        var inset = UIEdgeInsets(top: config.offset, left: config.margin, bottom: -config.offset, right: config.margin)
        switch config.orientation {
        case .top:
            inset = UIEdgeInsets(top: -config.offset, left: config.margin, bottom: config.offset, right: config.margin)
        case .left:
            inset = UIEdgeInsets(top: config.margin, left: -config.offset, bottom: config.margin, right: config.offset)
        case .right:
            inset = UIEdgeInsets(top: config.margin, left: config.offset, bottom: config.margin, right: -config.offset)
        default:
            inset = UIEdgeInsets(top: config.offset, left: config.margin, bottom: -config.offset, right: config.margin)
        }
        for i in 1...config.count {
            let shadowView = AlbumShadowView(with: config, index: i)
            superView.addSubview(shadowView)
            if lastView == nil {
                superView.insertSubview(shadowView, belowSubview: targetView)
                shadowView.snp.makeConstraints { make in
                    make.edges.equalTo(targetView).inset(inset)
                }
            } else if let lastView = lastView {
                superView.insertSubview(shadowView, belowSubview: lastView)
                shadowView.snp.makeConstraints { make in
                    make.edges.equalTo(lastView).inset(inset)
                }
            }
            lastView = shadowView
        }
    }
}
