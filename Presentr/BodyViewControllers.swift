//
//  BodyViewControllers.swift
//  Presentr
//
//  Created by Karl Söderberg on 07/09/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit

extension TextViewModalBody: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.contains(placeholderText) {
            setUserInputText()
        } else if textView.text == "" {
            setplaceHolderText()
        } else {
            userInputText = textView.text
        }
    }
    
    private func setUserInputText() {
        textView.text = textView.text.substring(to: textView.text.index(after: textView.text.startIndex))
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    private func setplaceHolderText() {
        textView.text = placeholderText
        textView.textColor = #colorLiteral(red: 0.7370592952, green: 0.7370767593, blue: 0.7370672822, alpha: 1)
        textView.selectedRange = NSMakeRange(0, 0)
    }
}

public class TextViewModalBody: UIViewController {
    
    var placeholderText: String = " "
    public var userInputText: String?
    
    public static func create(text: String?, placeholder: String) -> TextViewModalBody {
        let viewController =  UIStoryboard(name: "Alert", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "TextViewBody") as! TextViewModalBody
        viewController.placeholderText = placeholder
        viewController.userInputText = text
        return viewController
    }
    
    @IBOutlet var textView: UITextView!
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.delegate = self
        textView.text = userInputText
        textView?.becomeFirstResponder()
        textViewDidChange(textView)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView?.resignFirstResponder()        
    }
}
