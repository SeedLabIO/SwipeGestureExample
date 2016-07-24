//
//  CustomView.swift
//  SwipeGestureExample
//
//  Created by LiangAlen on 22/07/16.
//  Copyright © 2016 seedlab. All rights reserved.
//

import Cocoa

class CustomView: NSView {

    // Just so we can set backgroundColor for NSView in Storyboard :-)

    @IBInspectable var backgroundColor: NSColor = NSColor.clearColor()

    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
    }

    override var wantsUpdateLayer: Bool {
        return true
    }

    override func updateLayer() {
        layer?.backgroundColor = backgroundColor.CGColor
    }
}
