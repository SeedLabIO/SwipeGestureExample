//
//  TwoFingersSwipeGestureRecognizeView.swift
//  SwipeGestureExample
//
//  Created by LiangAlen on 22/07/16.
//  Copyright © 2016 seedlab. All rights reserved.
//

import Cocoa

protocol TwoFingersSwipeGestureRecognizeViewDelegate {
    func hanldeSwipeWithTwoFingers(delta: CGPoint)
}

class TwoFingersSwipeGestureRecognizeView: CustomView {

    var delegate: TwoFingersSwipeGestureRecognizeViewDelegate? = nil

    // Basically it's from
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/EventOverview/HandlingTouchEvents/HandlingTouchEvents.html#//apple_ref/doc/uid/10000060i-CH13-SW21

    var initialTouches = Array<NSTouch?>(count: 2, repeatedValue: nil)
    var currentTouches = Array<NSTouch?>(count: 2, repeatedValue: nil)

    var delta: CGPoint {
        guard let fingerAInitial = initialTouches[0],
            let fingerBInitial = initialTouches[1],
            let fingerACurrent = currentTouches[0],
            let fingerBCurrent = currentTouches[1] else {
                return CGPointZero
        }

        let fingerADeltaX = fingerACurrent.normalizedPosition.x - fingerAInitial.normalizedPosition.x
        let fingerADeltaY = fingerACurrent.normalizedPosition.y - fingerAInitial.normalizedPosition.y
        let fingerBDeltaX = fingerBCurrent.normalizedPosition.x - fingerBInitial.normalizedPosition.x
        let fingerBDeltaY = fingerBCurrent.normalizedPosition.y - fingerBInitial.normalizedPosition.y

        // We'll use sameSign(:,y:) to make sure we are dealing with two finger scroll
        // rather than zoom-in or zoom-out.
        func sameSign(x: CGFloat, y: CGFloat) -> Bool { return (((x >= 0) ? 1 : 0) ^ ((y < 0) ? 1 : 0)) != 0 }

        let deltaX = sameSign(fingerADeltaX, y: fingerBDeltaX) ? (abs(fingerADeltaX) > abs(fingerBDeltaX) ? fingerADeltaX : fingerBDeltaX) : 0
        let deltaY = sameSign(fingerADeltaY, y: fingerBDeltaY) ? (abs(fingerADeltaY) > abs(fingerBDeltaY) ? fingerADeltaY : fingerBDeltaY) : 0

        // In NSEvent, a non-0 deltaX will represent a horizontal swipe, 
        // -1 for swipe right and 1 for swipe left.
        // So we just using the negtive value of deltaX anyway.
        return CGPointMake(deltaX, deltaY)
    }

    let threshold: CGFloat = 0
    var isTracking = false

    override func awakeFromNib() {
        super.awakeFromNib()
        acceptsTouchEvents = true
    }

    override func touchesBeganWithEvent(event: NSEvent) {
        // Should use '.Began' or '.Touching' rather than '.Any',
        // but sometimes the phase is '.Unknown', so.. I just use '.Any' here anyway.
        let touches = event.touchesMatchingPhase(.Any, inView: self)
        if touches.count == 2 {
            let array = Array(touches)
            initialTouches[0] = array[0]
            initialTouches[1] = array[1]
            currentTouches[0] = initialTouches[0]
            currentTouches[1] = initialTouches[1]
        } else if touches.count == 2 {
            // More than 2 touches. Only track 2.
            if isTracking {
                cancelTracking()
            }
        }
    }

    override func touchesMovedWithEvent(event: NSEvent) {
        let touches = event.touchesMatchingPhase(.Touching, inView: self)
        if let fingerAInitial = initialTouches[0],
            let fingerBInitial = initialTouches[1]
            where touches.count == 2 {

            touches.forEach { touch in
                if touch.identity.isEqual(fingerAInitial.identity) {
                    currentTouches[0] = touch
                } else if touch.identity.isEqual(fingerBInitial.identity) {
                    currentTouches[1] = touch
                }
            }

            if !isTracking {
                isTracking = true
            }
        }
    }

    override func touchesEndedWithEvent(event: NSEvent) {
        if isTracking {
            if (abs(delta.x) > threshold || abs(delta.y) > threshold) {
                delegate?.hanldeSwipeWithTwoFingers(delta)
            }
            cancelTracking()
        }
    }

    override func touchesCancelledWithEvent(event: NSEvent) {
        if isTracking {
            cancelTracking()
        }
    }

    func cancelTracking() {
        initialTouches = initialTouches.map { _ in nil as NSTouch? }
        currentTouches = currentTouches.map { _ in nil as NSTouch? }
        isTracking = false
    }
}
