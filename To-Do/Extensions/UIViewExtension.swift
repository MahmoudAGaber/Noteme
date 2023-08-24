//
//  UIViewExtension.swift
//  ToDo
//
//  Created by MAG on 07/08/2023.
//

import Foundation
import UIKit


extension UIView{
    @IBInspectable var cornerRaduis: CGFloat {
        get { return cornerRaduis }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
