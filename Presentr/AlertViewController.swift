//
//  AlertViewController.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

public typealias AlertActionHandler = (() -> Void)

/// Describes each action that is going to be shown in the 'AlertViewController'
open class AlertAction{
    
    let title: String
    let style: AlertActionStyle
    let handler: AlertActionHandler?
    
    /**
     Initialized an 'AlertAction'
     
     - parameter title:   The title for the action, that will be used as the title for a button in the alert controller
     - parameter style:   The style for the action, that will be used to style a button in the alert controller.
     - parameter handler: The handler for the action, that will be called when the user clicks on a button in the alert controller.
     
     - returns: An inmutable AlertAction object
     */
    public init(title: String, style: AlertActionStyle, handler: AlertActionHandler?){
        self.title = title
        self.style = style
        self.handler = handler
    }
    
}

/**
 Describes the style for an action, that will be used to style a button in the alert controller.
 
 - Default:     Green text label. Meant to draw attention to the action.
 - Cancel:      Gray text label. Meant to be neutral.
 - Destructive: Red text label. Meant to warn the user about the action.
 */
public enum AlertActionStyle{
    
    case `default`
    case cancel
    case destructive
    
    /**
     Decides which color to use for each style
     
     - returns: UIColor representing the color for the current style
     */
    func color() -> UIColor{
        switch self {
        case .default:
            return PresentrConfiguration.defaultButtonColor
        case .cancel:
            return PresentrConfiguration.cancelButtonColor
        case .destructive:
            return PresentrConfiguration.destructiveButtonColor
        }
    }
    
    func textColor() -> UIColor{
        switch self {
        case .default:
            return PresentrConfiguration.defaultButtonTextColor
        case .cancel:
            return PresentrConfiguration.cancelButtonTextColor
        case .destructive:
            return PresentrConfiguration.defaultButtonTextColor
        }
    }
    
}

extension AlertViewController {
    
    func addKeyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillUpdate(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillUpdate(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillUpdate(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        contentViewBottomConstraint.constant = keyboardHeight + 20
        UIView.animate(withDuration: 0.1, animations: { 
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}

/// UIViewController subclass that displays the alert
open class AlertViewController: UIViewController {
    
    /// Text that will be used as the title for the alert
    open var titleText: String?
    /// Text that will be used as the body for the alert
    open var bodyText: String?
    
    open var bodyViewController: UIViewController?
    
    /// If set to false, alert wont auto-dismiss the controller when an action is clicked. Dismissal will be up to the action's handler. Default is true.
    open var autoDismiss: Bool = true
    /// If autoDismiss is set to true, then set this property if you want the dismissal to be animated. Default is true.
    open var dismissAnimated: Bool = true
    
    fileprivate var actions = [AlertAction]()
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bodyContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButtonWidthConstraint: NSLayoutConstraint!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        
        if actions.isEmpty{
            let okAction = AlertAction(title: "OK", style: .default, handler: nil)
            addAction(okAction)
        }
        
        contentView.layer.cornerRadius = PresentrConfiguration.cornerRadius
        contentView.layer.masksToBounds = true
        
        //setupFonts()
        setupLabels()
        setupButtons()
        setupBodyViewController()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open func updateViewConstraints() {
        if let constraint = firstButtonWidthConstraint {
            constraint.isActive = actions.count != 1
        }
        super.updateViewConstraints()
    }
    
    // MARK: AlertAction's
    
    /**
     Adds an 'AlertAction' to the alert controller. There can be maximum 2 actions. Any more will be ignored. The order is important.
     
     - parameter action: The 'AlertAction' to be added
     */
    open func addAction(_ action: AlertAction){
        guard actions.count < 2 else { return }
        actions += [action]
    }
    
    // MARK: Setup
    
    private func setupBodyViewController(){
        guard let bodyViewController = bodyViewController else { return }
        bodyViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(bodyViewController)
        bodyContentView.addSubview(bodyViewController.view)
        bodyContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[body]|",
                                                                      options: .alignAllCenterX,
                                                                      metrics: nil,
                                                                      views: ["body" : bodyViewController.view]))
        bodyContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[body]|",
                                                                      options: .alignAllCenterX,
                                                                      metrics: nil,
                                                                      views: ["body" : bodyViewController.view]))
        bodyViewController.didMove(toParentViewController: self)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    fileprivate func setupLabels(){
        titleLabel.text = titleText 
        if bodyViewController != nil {
            bodyLabel.removeFromSuperview()
        } else {
            bodyLabel.text = bodyText
        }
        
    }
    
    fileprivate func setupButtons(){
        guard let firstAction = actions.first else { return }
        apply(firstAction, toButton: firstButton)
        if actions.count == 2{
            let secondAction = actions.last!
            apply(secondAction, toButton: secondButton)
        }else{
            secondButton.removeFromSuperview()
        }
    }
    
    fileprivate func apply(_ action: AlertAction, toButton: UIButton){
        let title = action.title.uppercased()
        let style = action.style
        toButton.setTitle(title, for: UIControlState())
        toButton.backgroundColor = style.color()
        toButton.setTitleColor(style.textColor(), for: .normal)
    }
    
    // MARK: IBAction's
    
    @IBAction func didSelectFirstAction(_ sender: AnyObject) {
        guard let firstAction = actions.first else { return }
        if let handler = firstAction.handler {
            handler()
        }
        dismiss()
    }
    
    @IBAction func didSelectSecondAction(_ sender: AnyObject) {
        guard let secondAction = actions.last , actions.count == 2 else { return }
        if let handler = secondAction.handler {
            handler()
        }
        dismiss()
    }
    
    // MARK: Helper's
    
    func dismiss(){
        guard autoDismiss else { return }
        self.dismiss(animated: dismissAnimated, completion: nil)
    }
    
}

