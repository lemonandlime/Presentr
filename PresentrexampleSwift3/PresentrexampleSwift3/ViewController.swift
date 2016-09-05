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

    var presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    var alertController: AlertViewController = {
        let alertController = Presentr.alertViewController(title: "Message to driver", body: "This action can't be undone!")
        let cancelAction = AlertAction(title: "CANCEL", style: .cancel) { alert in
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "SAVE", style: .default) { alert in
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
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
        // For default transitions you do not need to set this, this is to reset it just in case it was already changed by another presentation below.
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func alertCustom(_ sender: AnyObject) {
        presenter.presentationType = .alert
        presenter.transitionType = .coverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func popupDefault(_ sender: AnyObject) {
        presenter.presentationType = .popup
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func popupCustom(_ sender: AnyObject) {
        presenter.presentationType = .popup
        presenter.transitionType = .coverHorizontalFromRight
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfDefault(_ sender: AnyObject) {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfCustom(_ sender: AnyObject) {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverVerticalFromTop
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfDefault(_ sender: AnyObject) {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfCustom(_ sender: AnyObject) {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    



}

