//
//  UIVIewExtensions.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/25/21.
//

import UIKit

extension UIStackView {
    
    // Create HStack or VStack with preset values
    convenience init(axis: NSLayoutConstraint.Axis, views: [UIView], distribution: UIStackView.Distribution = .fillEqually, alignment: UIStackView.Alignment = .center, spacing: CGFloat = .zero) {
        
        self.init()
        self.axis = axis
        views.forEach { addArrangedSubview($0) }
        self.distribution = distribution
        self.spacing = spacing
        self.alignment = alignment
    }
}

extension UILabel {
    
    // Create UILabel with text
    convenience init(text: String?, fontStyle: UIFont = .systemFont(ofSize: 17)) {
        
        self.init()
        self.text = text
        self.font = fontStyle
    }
}

extension UIView {
    
    // Set all Autolayout constraints in one statement
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
            
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
