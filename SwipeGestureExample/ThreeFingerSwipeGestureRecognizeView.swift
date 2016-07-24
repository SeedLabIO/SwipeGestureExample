//
//  ThreeFingersSwipeGestureRecognizeView.swift
//  SwipeGestureExample
//
//  Created by LiangAlen on 22/07/16.
//  Copyright © 2016 seedlab. All rights reserved.
//

import Cocoa

protocol ThreeFingersSwipeGestureRecognizeViewDelegate {
    func hanldeSwipeWithThreeFingers(delta: CGPoint)
}

class ThreeFingersSwipeGestureRecognizeView: CustomView {

    var delegate: ThreeFingersSwipeGestureRecognizeViewDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // http://stackoverflow.com/questions/7433120/nsresponder-swipewithevent-not-called
    //
    // To receive swipeWithEvent: messages, you have to ensure that the 3 finger swipe gesture is not mapped to anything that might cause a conflict. Go to System preferences -> Trackpad -> More Gestures, and set these preferences to one of the following:
    //
    // Swipe between pages:
    // - Swipe with two or three fingers, or
    // - Swipe with three fingers
    // Swipe between full-screen apps:
    // - Swipe left or right with four fingers

    override func swipeWithEvent(event: NSEvent) {
        let x = event.deltaX
        let y = event.deltaY

        if abs(x) > 0 || abs(y) > 0 {
            delegate?.hanldeSwipeWithThreeFingers(CGPointMake(x, y))
        }
    }
}
