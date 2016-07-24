//
//  SwipeTrackingFromScrollView.swift
//  SwipeGestureExample
//
//  Created by LiangAlen on 23/07/16.
//  Copyright © 2016 seedlab. All rights reserved.
//

import Cocoa

protocol SwipeTrackingFromScrollViewDelegate {
    func hanldeSwipeTrackingFromScrollEvent(delta: CGPoint)
}

class SwipeTrackingFromScrollView: CustomView {

    var delegate: SwipeTrackingFromScrollViewDelegate? = nil

    // It's from https://developer.apple.com/library/mac/releasenotes/Cocoa/AppKitOlderNotes.html

    override func wantsScrollEventsForSwipeTrackingOnAxis(axis: NSEventGestureAxis) -> Bool {
        return axis == .Horizontal
    }

    override func scrollWheel(theEvent: NSEvent) {

        // Not a gesture scroll event.
        if theEvent.phase == .None { return }
        // Not horizontal
        if abs(theEvent.scrollingDeltaX) <= abs(theEvent.scrollingDeltaY) { return }

        var animationCancelled = false

        theEvent.trackSwipeEventWithOptions(
            .LockDirection,
            dampenAmountThresholdMin: 1,
            max: 1) { (gestureAmount, phase, complete, stop) in

            if animationCancelled {
                stop.initialize(true)
            }

            if (phase == .Began) { }
            if (phase == .Ended || phase == .Cancelled) {
                self.delegate?.hanldeSwipeTrackingFromScrollEvent(CGPointMake(theEvent.scrollingDeltaX, theEvent.scrollingDeltaY))
                animationCancelled = true
            }
        }
    }

}
