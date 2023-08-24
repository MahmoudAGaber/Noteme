//
//  CardView.swift
//  ToDo
//
//  Created by MAG on 07/08/2023.
//

import Foundation
import UIKit

class CardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }

    private func initialSetup(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.cornerRadius = 10
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        cornerRaduis = 10
    }
}
