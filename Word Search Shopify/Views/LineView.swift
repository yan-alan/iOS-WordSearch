//
//  LineView.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-13.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

/// A view consisting of a line going from the top left ot the bottom right
class DiagonalLineView: UIView {
    /// Creates a new view with given frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///Draws the line
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(3.0)
        context!.setStrokeColor(UIColor(hex: 0xDC4545, alpha: 0.6).cgColor)
        context?.move(to: CGPoint(x: 0, y: self.frame.size.height))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        context!.strokePath()
    }
    /// Sets up subviews and colours
    private func setupView() {
        backgroundColor = .clear
    }
}

/// A view consisting of a line going from the left to right, where y = 2
class HorizontalLineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///Draws the line
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(3.0)
        context!.setStrokeColor(UIColor(hex: 0xDC4545, alpha: 0.6).cgColor)
        context?.move(to: CGPoint(x: 0, y: 2))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: 2))
        context!.strokePath()
    }
    /// Sets up subviews and colours
    private func setupView() {
        backgroundColor = .clear
    }
}

/// A view consisting of a line going from the top to bottom, where x = 2
class VerticalLineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///Draws the line
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(3.0)
        context!.setStrokeColor(UIColor(hex: 0xDC4545, alpha: 0.6).cgColor)
        context?.move(to: CGPoint(x: 2, y: self.frame.size.height))
        context?.addLine(to: CGPoint(x: 2, y: 0))
        context!.strokePath()
    }
    /// Sets up subviews and colours
    private func setupView() {
        backgroundColor = .clear
    }
}
