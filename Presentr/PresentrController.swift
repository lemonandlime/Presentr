//
//  PresentrPresentationController.swift
//  OneUP
//
//  Created by Daniel Lozano on 4/27/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

/// Presentr's custom presentation controller. Handles the position and sizing for the view controller's.
class PresentrController: UIPresentationController, UIAdaptivePresentationControllerDelegate {

    /// Presentation type must be passed in to make all the sizing and position decisions.
    var presentationType: PresentationType = .popup {
        didSet {
            if presentationType == .bottomHalf || presentationType == .topHalf {
                //removeCornerRadiusFromPresentedView()
            }
        }
    }

    fileprivate var chromeView = UIView()

    // MARK: Init
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupChromeView()
        //addCornerRadiusToPresentedView()
    }

    // MARK: Setup

    fileprivate func setupChromeView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        chromeView.addGestureRecognizer(tap)
        chromeView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        chromeView.alpha = 0
    }

    // MARK: Actions

    func chromeViewTapped(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }


}

// MARK: UIPresentationController

extension PresentrController {

    // MARK: Presentation
    
//    override var frameOfPresentedViewInContainerView: CGRect {
//        var presentedViewFrame = CGRect.zero
//        let containerBounds = containerView!.bounds
//
//        let size = self.size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
//        let center = calculateCenterPoint()
//        let origin = calculateOrigin(center, size: size)
//
//        presentedViewFrame.size = size
//        presentedViewFrame.origin = origin
//
//        return presentedViewFrame
//    }

//    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
//        let width = calculateWidth(parentSize)
//        let height = calculateHeight(parentSize)
//        return CGSize(width: CGFloat(width), height: CGFloat(height))
//    }

    override func containerViewWillLayoutSubviews() {
        chromeView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }

    // MARK: Animation

    override func presentationTransitionWillBegin() {
        chromeView.frame = containerView!.bounds
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, at: 0)

        if let coordinator = presentedViewController.transitionCoordinator {

            coordinator.animate(alongsideTransition: { context in
                self.chromeView.alpha = 1.0
                }, completion: nil)

        } else {
            chromeView.alpha = 1.0
        }
    }

    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {

            coordinator.animate(alongsideTransition: { context in
                self.chromeView.alpha = 0.0
                }, completion: nil)

        } else {
            chromeView.alpha = 0.0
        }
    }
}
