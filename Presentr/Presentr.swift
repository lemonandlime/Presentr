//
//  Presentr.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import Foundation
import UIKit

/**
 Basic Presentr type. Its job is to describe the 'type' of presentation. The type describes the size and position of the presented view controller.
 
 - Alert:      This is a small 270 x 180 alert which is the same size as the default iOS alert.
 - Popup:      This is a average/default size 'popup' modal.
 - TopHalf:    This takes up half of the screen, on the top side.
 - BottomHalf: This takes up half of the screen, on the bottom side.
 */
public enum PresentationType {

    case alert
    case popup
    case topHalf
    case bottomHalf

    /**
     Associates each Presentr type with a default transition type, in case one is not provided to the Presentr object.
     
     - returns: Return a 'TransitionType' which describes a system provided or custom transition animation.
     */
    func defaultTransitionType() -> TransitionType{
        switch self {
        case .alert, .popup, .bottomHalf:
            return .coverVertical
        case .topHalf:
            return .coverVerticalFromTop
        }
    }
}

public enum ButtonStackType {
    case horisontal
    case vertical
}

/**
 Describes the transition animation for presenting the view controller. Includes the default system transitions and custom ones.
 
 - CoverVertical:            System provided transition style. UIModalTransitionStyle.CoverVertical
 - CrossDissolve:            System provided transition style. UIModalTransitionStyle.CrossDissolve
 - FlipHorizontal:           System provided transition style. UIModalTransitionStyle.FlipHorizontal
 - CoverVerticalFromTop:     Custom transition animation. Slides in vertically from top.
 - CoverHorizontalFromLeft:  Custom transition animation. Slides in horizontally from left.
 - CoverHorizontalFromRight: Custom transition animation. Slides in horizontally from  right.
 */
public enum TransitionType{
    
    // System provided
    case coverVertical
    case crossDissolve
    case flipHorizontal
    // Custom
    case coverVerticalFromTop
    case coverHorizontalFromRight
    case coverHorizontalFromLeft
    
    /**
     Matches the 'TransitionType' to the system provided transition. If this returns nil it should be taken to mean that it's a custom transition, and should call the animation() method.
     
     - returns: UIKit transition style
     */
    func systemTransition() -> UIModalTransitionStyle?{
        switch self {
        case .coverVertical:
            return UIModalTransitionStyle.coverVertical
        case .crossDissolve:
            return UIModalTransitionStyle.crossDissolve
        case .flipHorizontal:
            return UIModalTransitionStyle.flipHorizontal
        default:
            return nil
        }
    }
    
    /**
     Associates a custom transition type to the class responsible for its animation.
     
     - returns: Object conforming to the 'PresentrAnimation' protocol, which in turn conforms to 'UIViewControllerAnimatedTransitioning'. Use this object for the custom animation.
     */
    func animation() -> PresentrAnimation?{
        switch self {
        case .coverVerticalFromTop:
            return CoverVerticalFromTopAnimation()
        case .coverHorizontalFromRight:
            return CoverHorizontalAnimation(fromRight: true)
        case .coverHorizontalFromLeft:
            return CoverHorizontalAnimation(fromRight: false)
        default:
            return nil
        }
    }
    
}


/// Main Presentr class. This is the point of entry for using the framework.
open class Presentr: NSObject {

    /// This must be set during initialization, but can be changed to reuse a Presentr object.
    open var presentationType: PresentationType
    
    /// The type of transition animation to be used to present the view controller. This is optional, if not provided the default for each presentation type will be used.
    open var transitionType: TransitionType?

    // MARK: Init
    
    public init(presentationType: PresentationType){
        self.presentationType = presentationType
    }
    
    open static func alertViewController(title: String, buttonStack: ButtonStackType, body: String) -> AlertViewController {
        let alertController = alertViewController(title: title, buttonStack: buttonStack)
        alertController.bodyText = body
        return alertController
    }
    
    open static func alertViewController(title: String, buttonStack: ButtonStackType,  bodyViewController: UIViewController) -> AlertViewController {
        let alertController = alertViewController(title: title, buttonStack: buttonStack)
        alertController.bodyViewController = bodyViewController
        return alertController
    }
    
    open static func alertViewController(title: String, buttonStack: ButtonStackType) -> AlertViewController {
        let bundle = Bundle(for: self)
        let alertController = UIStoryboard(name: "Alert", bundle: bundle).instantiateInitialViewController() as! AlertViewController
        alertController.titleText = title
        alertController.buttonStackType = buttonStack
        return alertController
    }
    
    // MARK: Private Methods

    /**
     Private method for presenting a view controller, using the custom presentation. Called from the UIViewController extension.
     
     - parameter presentingVC: The view controller which is doing the presenting.
     - parameter presentedVC:  The view controller to be presented.
     - parameter animated:     Animation boolean.
     - parameter completion:   Completion block.
     */
    fileprivate func presentViewController(presentingViewController presentingVC: UIViewController, presentedViewController presentedVC: UIViewController, animated: Bool, completion: (() -> Void)?){
        let transition = transitionType ?? presentationType.defaultTransitionType()
        if let systemTransition = transition.systemTransition(){
            presentedVC.modalTransitionStyle = systemTransition
        }
        presentedVC.transitioningDelegate = self
        presentedVC.modalPresentationStyle = .custom
        presentingVC.present(presentedVC, animated: animated, completion: nil)
    }

}

// MARK: - UIViewController extension to provide customPresentViewController(_:viewController:animated:completion:) method

public extension UIViewController {
    
    // Presents a modal with the viewController as content.
    func presentInModal(viewControllerToPresent: UIViewController,
                        title: String,
                        actions: [AlertAction]?,
                        buttonStack: ButtonStackType,
                        animated: Bool,
                        completion: (() -> Void)?) {
        
        let presentr = Presentr(presentationType: .alert)
        let alert = Presentr.alertViewController(title: title, buttonStack: buttonStack, bodyViewController: viewControllerToPresent)
        actions?.forEach({ (action) in
            alert.addAction(action)
        })
        presentr.presentViewController(presentingViewController: self,
                                       presentedViewController: alert,
                                       animated: animated,
                                       completion: completion)
    }
    // Presents a modal with the message as content.
    func presentInModal(message: String,
                        title: String,
                        actions: [AlertAction]?,
                        buttonStack: ButtonStackType,
                        animated: Bool,
                        completion: (() -> Void)?) {
        
        let presentr = Presentr(presentationType: .alert)
        let alert = Presentr.alertViewController(title: title, buttonStack: buttonStack, body: message)
        actions?.forEach({ (action) in
            alert.addAction(action)
        })
        presentr.presentViewController(presentingViewController: self,
                                       presentedViewController: alert,
                                       animated: animated,
                                       completion: completion)
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension Presentr: UIViewControllerTransitioningDelegate{
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController(presented, presenting: presenting ?? source)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return animation()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return animation()
    }
    
    // MARK: - Private Helper's
    
    fileprivate func presentationController(_ presented: UIViewController, presenting: UIViewController) -> PresentrController {
        let presentationController = PresentrController(presentedViewController: presented, presenting: presenting)
        presentationController.presentationType = presentationType
        return presentationController
    }
    
    fileprivate func animation() -> PresentrAnimation?{
        if let animation = transitionType?.animation() {
            return animation
        }else{
            return nil
        }
    }
    
}
