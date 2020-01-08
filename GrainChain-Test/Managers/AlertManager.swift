//
//  AlertManager.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 07/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    private var alert = UIAlertController()
    private var spinner = UIActivityIndicatorView(style: .large)

    
    func showAlertWithOptions(with title: String, message: String, controller: UIViewController,
                             completion: @escaping (_ response: Bool) -> Void){
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (aler) in
            completion(false)
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(with title: String, message: String, placeholder: String
        ,controller: UIViewController, completion: @escaping (_ response: String?) -> Void){
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = placeholder
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
            guard let textField = self.alert.textFields?[0] else {
                completion(nil)
                return
            }
            
            completion(textField.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (aler) in
            completion(nil)
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showSpinner(view: UIView){
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func stopSpinner(){
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    private func addChoiceButtons(){
        
    }
    
    private func addOkButton(){
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
    }
}
