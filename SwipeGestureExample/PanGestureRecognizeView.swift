//
//  PanGestureRecognizeView.swift
//  SwipeGestureExample
//
//  Created by LiangAlen on 24/07/16.
//  Copyright © 2016 seedlab. All rights reserved.
//

import Cocoa

protocol PanGestureRecognizeViewDelegate {
    func handlePanGestureRecognized(delta: CGPoint)
}

class PanGestureRecognizeView: CustomView, NSGestureRecognizerDelegate {

    var delegate: PanGestureRecognizeViewDelegate? = nil

    var startPoint: NSPoint? = nil
    var endPoint: NSPoint? = nil

    var delta: CGPoint {
        guard let start = startPoint, let end = endPoint else { return CGPointZero }
        return CGPointMake(end.x - start.x, end.y - start.y)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let panGestureRecognizer = NSPanGestureRecognizer.init(target: self, action: #selector(panGestureRecognized(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }

    func panGestureRecognized(sender: NSPanGestureRecognizer) {
        if sender.state == .Began {
            startPoint = sender.translationInView(self)
        }
        if sender.state == .Recognized {
            endPoint = sender.translationInView(self)
            delegate?.handlePanGestureRecognized(delta)
        }
    }

}
