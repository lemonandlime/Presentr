//
//  ViewController.swift
//  PresentrexampleSwift3
//
//  Created by Karl Söderberg on 05/09/16.
//  Copyright © 2016 LemonandLime. All rights reserved.
//

import UIKit
import Presentr

class ViewController: UIViewController {

    let placeholderText = "Type your message to the driver here"
    var userMessage = ""
    
    var presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    var alertController: AlertViewController = {
        
        let alertController = Presentr.alertViewController(title: "Message to driver", buttonStack: .horisontal, body: "This action can't be undone!, BUt if it could it would also mean that things could travel back in time trhu the ethernet cables.")
        let cancelAction = AlertAction(title: "CANCEL", style: .cancel) { alert in
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "SAVE", style: .default) { alert in
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction's
    
    @IBAction func alertDefault(_ sender: AnyObject) {
        presenter.presentationType = .alert
        presenter.transitionType = .coverVertical
        let fancyVC = storyboard?.instantiateViewController(withIdentifier: "Fancy")
        let cancelAction = AlertAction(title: "CANCEL", style: .cancel) { alert in
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "SAVE", style: .default) { alert in
            print("OK!!")
        }
        let otherAction = AlertAction(title: "OTHER", style: .cancel) { alert in
            print("OK!!")
        }
        
       let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.text = "Kalle"
        
        
        presentInModal(viewToPresent: label, title: "Fancy eh?", actions: [okAction, cancelAction, otherAction], buttonStack: .vertical, animated: true, completion: nil)
    }
    
    @IBAction func alertCustom(_ sender: AnyObject) {
        presenter.presentationType = .alert
        presenter.transitionType = .coverVertical
        let fancyVC = storyboard?.instantiateViewController(withIdentifier: "Fancy")
        let cancelAction = AlertAction(title: "CANCEL", style: .cancel) { alert in
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "SAVE", style: .default) { alert in
            print("OK!!")
        }
        let otherAction = AlertAction(title: "OTHER", style: .cancel) { alert in
            print("OK!!")
        }
        
        presentInModal(viewControllerToPresent: fancyVC!, title: "Fancy eh?", actions: [cancelAction, otherAction, okAction], buttonStack: .horisontal, animated: true, completion: nil)
 
    }
    
    @IBAction func popupDefault(_ sender: AnyObject) {
        presenter.presentationType = .popup
        presenter.transitionType = .coverVertical
        let textViewVC = TextViewModalBody.create(text: userMessage, placeholder: placeholderText)
        let saveAction = AlertAction(title: "SAVE CHANGED", style: .default) {
            self.userMessage = textViewVC.userInputText ?? ""
        }
        presentInModal(viewControllerToPresent: textViewVC, title: "Fancy eh?", actions: [saveAction], buttonStack: .horisontal, animated: true, completion: nil)

//        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func popupCustom(_ sender: AnyObject) {
        presenter.presentationType = .popup
        presenter.transitionType = .coverHorizontalFromRight
//        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfDefault(_ sender: AnyObject) {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverVertical
//        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfCustom(_ sender: AnyObject) {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverVerticalFromTop
//        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfDefault(_ sender: AnyObject) {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverVertical
//        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfCustom(_ sender: AnyObject) {
//        presenter.presentationType = .bottomHalf
//        presenter.transitionType = .coverHorizontalFromLeft
//        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    



}

