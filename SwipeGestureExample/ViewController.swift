//
//  ViewController.swift
//  SwipeGestureExample
//
//  Created by LiangAlen on 22/07/16.
//  Copyright © 2016 seedlab. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var twoFingersSwipeView: TwoFingersSwipeGestureRecognizeView!
    @IBOutlet weak var swipeFromScrollView: SwipeTrackingFromScrollView!
    @IBOutlet weak var threeFingersSwipeView: ThreeFingersSwipeGestureRecognizeView!
    @IBOutlet weak var panGestureView: PanGestureRecognizeView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        twoFingersSwipeView.delegate = self
        swipeFromScrollView.delegate = self
        threeFingersSwipeView.delegate = self
        panGestureView.delegate = self
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: TwoFingersSwipeGestureRecognizeViewDelegate {

    func hanldeSwipeWithTwoFingers(delta: CGPoint) {
        print("Two fingers swipe \(delta.direction) (\(delta.description)).")
    }
}

extension ViewController: SwipeTrackingFromScrollViewDelegate {
    
    func hanldeSwipeTrackingFromScrollEvent(delta: CGPoint) {
        print("Swipe from scroll \(delta.direction) (\(delta.description)).")
    }
}

extension ViewController: ThreeFingersSwipeGestureRecognizeViewDelegate {

    func hanldeSwipeWithThreeFingers(delta: CGPoint) {
        print("Three fingers swipe \(delta.direction) (\(delta.description)).")
    }
}

extension ViewController: PanGestureRecognizeViewDelegate {

    func handlePanGestureRecognized(delta: CGPoint) {
        print("Pan gesture recognized \(delta.direction) (\(delta.description)).")
    }
}

extension CGPoint {

    var direction: String {
        if abs(x) > abs(y) {
            return x > 0 ? "right" : "left"
        } else {
            return y > 0 ? "up" : "down"
        }
    }

    var description: String {
        return "x: \(x), y: \(y)"
    }
}