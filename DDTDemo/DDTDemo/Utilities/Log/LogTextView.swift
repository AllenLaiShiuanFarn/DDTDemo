//
//  LogTextView.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

class LogTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        textColor = .black
    }
}
