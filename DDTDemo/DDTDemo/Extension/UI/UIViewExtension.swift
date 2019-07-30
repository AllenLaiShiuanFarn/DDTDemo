//
//  UIViewExtension.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func addGradientLayer(with size: CGRect, colors: [UIColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = size
        gradientLayer.colors = colors.map { $0.cgColor }
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}

// MARK: - Auto Layout method version 3
extension UIView {
    typealias Constraint = (_ subview: UIView, _ superview: UIView) -> NSLayoutConstraint
    
    func addSubview(_ subview: UIView, constraints: [Constraint]) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(constraints.map { $0(subview, self) })
    }
    
    /// ex: subview.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant)
    /// - Parameter subviewKeyPath: subview's KeyPath
    /// - Parameter superviewKeyPath: superview's KeyPath
    /// - Parameter constant: anchors distance constant
    static func anchorConstraintEqual<LayoutAnchor, Axis>(
        from subviewKeyPath: KeyPath<UIView, LayoutAnchor>,
        to superviewKeyPath: KeyPath<UIView, LayoutAnchor>,
        constant: CGFloat = 0.0) -> Constraint where LayoutAnchor: NSLayoutAnchor<Axis> {
        return { subview, superview in
            subview[keyPath: subviewKeyPath]
                .constraint(equalTo: superview[keyPath: superviewKeyPath],
                            constant: constant)
        }
    }
    
    /// ex: subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant)
    /// - Parameter viewKeyPath: subview's and superview's KeyPath
    /// - Parameter constant: anchors distance constant
    static func anchorConstraintEqual<LayoutAnchor, Axis>(
        with viewKeyPath: KeyPath<UIView, LayoutAnchor>,
        constant: CGFloat = 0.0) -> Constraint where LayoutAnchor: NSLayoutAnchor<Axis> {
        return anchorConstraintEqual(from: viewKeyPath,
                                     to: viewKeyPath,
                                     constant: constant)
    }
    
    static func dimensionConstraintEqual<LayoutAnchor>(
        withViewKeyPath1 subviewKeyPath: KeyPath<UIView, LayoutAnchor>,
        subviewAnotherKeyPath: KeyPath<UIView, LayoutAnchor>,
        multiplier: CGFloat = 1.0) -> Constraint where LayoutAnchor: NSLayoutDimension {
        return { subview, _ in
            subview[keyPath: subviewKeyPath]
                .constraint(equalTo: subview[keyPath: subviewAnotherKeyPath],
                            multiplier: multiplier)
        }
    }
    
    static func dimensionConstraintEqual<LayoutAnchor>(
        with viewKeyPath: KeyPath<UIView, LayoutAnchor>,
        constant: CGFloat) -> Constraint where LayoutAnchor: NSLayoutDimension {
        return { subview, _ in
            subview[keyPath: viewKeyPath].constraint(equalToConstant: constant)
        }
    }
}

// MARK: - Auto Layout method version 2
extension UIView {
    enum Anchor {
        case topAnchorConstraint(equalToTop: NSLayoutYAxisAnchor, constant: CGFloat)
        case leadingAnchoConstraint(equalToLeading: NSLayoutXAxisAnchor, constant: CGFloat)
        case bottomAnchorConstraint(equalToBottom: NSLayoutYAxisAnchor, constant: CGFloat)
        case trailingAnchorConstraint(equalToTrailing: NSLayoutXAxisAnchor, constant: CGFloat)
        case widthAnchorConstraint(equalToWidth: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)
        case heightAnchorConstraint(equalToHeight: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)
        case horizontalAnchorConstraint(equalToHorizontal: NSLayoutXAxisAnchor, constant: CGFloat)
        case verticalAnchorConstraint(equalToVertical: NSLayoutYAxisAnchor, constant: CGFloat)
    }
    
    func anchor(_ anchors: [Anchor]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        anchors.forEach {
            switch $0 {
            case .topAnchorConstraint(let top, let constant):
                topAnchor.constraint(equalTo: top, constant: constant).isActive = true
            case .leadingAnchoConstraint(let leading, let constant):
                leadingAnchor.constraint(equalTo: leading, constant: constant).isActive = true
            case .bottomAnchorConstraint(let bottom, let constant):
                bottomAnchor.constraint(equalTo: bottom, constant: -constant).isActive = true
            case .trailingAnchorConstraint(let trailing, let constant):
                trailingAnchor.constraint(equalTo: trailing, constant: -constant).isActive = true
            case .widthAnchorConstraint(let width, let multiplier, let constant):
                widthAnchor.constraint(equalTo: width, multiplier: multiplier, constant: constant).isActive = true
            case .heightAnchorConstraint(let height, let multiplier, let constant):
                heightAnchor.constraint(equalTo: height, multiplier: multiplier, constant: constant).isActive = true
            case .horizontalAnchorConstraint(let horizontal, constant: let constant):
                centerXAnchor.constraint(equalTo: horizontal, constant: constant).isActive = true
            case .verticalAnchorConstraint(let vertical, constant: let constrant):
                centerYAnchor.constraint(equalTo: vertical, constant: constrant).isActive = true
            }
        }
    }
}

// MARK: - Auto Layout method version 1
extension UIView {
    struct AnchoredConstraints {
        var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let horizontal = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: horizontal).isActive = true
        }
        
        if let vertical = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: vertical).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        anchor(top: superview?.topAnchor,
               leading: superview?.leadingAnchor,
               bottom: superview?.bottomAnchor,
               trailing: superview?.trailingAnchor,
               padding: padding)
    }
    
    func anchorSize(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top,
         anchoredConstraints.leading,
         anchoredConstraints.bottom,
         anchoredConstraints.trailing,
         anchoredConstraints.width,
         anchoredConstraints.height].forEach { $0?.isActive = true }
        
        return anchoredConstraints
    }
}
