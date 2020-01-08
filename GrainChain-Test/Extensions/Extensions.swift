//
//  Extensions.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 06/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import Foundation
import UIKit

//MARK: format enum
enum KindOfFormat {
    case full
    case time
    case interval
}

protocol Localizable {
    var localized: String { get }
}

//MARK: String extension
extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

//MARK: DateFormatter extension
extension DateFormatter {
    func getCurrentDateFormatter(type: KindOfFormat) {
        var format = ""
        switch type {
        case .full, .interval:
            format = "dd-MMM-yyy HH:mm:ss:mm"
        case .time:
            format = "HH:mm:ss"
        }
        
        self.dateFormat = format
    }
}

//MARK: Date extension
extension Date {
    func currentDateToStringFormated(type: KindOfFormat)->String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.getCurrentDateFormatter(type: type)
        
        switch type {
        case .full, .time:
            return dateFormatter.string(from: self)
        case .interval:
            return self.timeIntervalSince1970.description
        }
    }
    
    func getTime(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute,.second], from: self, to: date)
        return "\(components.hour ?? 0):\(components.minute ?? 0):\(components.second ?? 0)"
    }
}

//MARK: Doueble extension
extension Double{
    func metersToKilometers()-> Double{
        return self / 1000
    }
    
    func formateDistanceToString()-> String{
        let distance = NSString(format: "%.3f", self) as String
        return "\(distance) kms"
    }
}

//MARK: UIView extension
extension UIView {
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

//MARK: UILabel extension
extension UILabel {
    @IBInspectable var localizable: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

//MARK: UIButton extension
extension UIButton {
    @IBInspectable var localizable: String? {
        get { return nil }
        set(key) {
            setTitle("RECORD".localized ,for: .normal)
        }
    }
}
