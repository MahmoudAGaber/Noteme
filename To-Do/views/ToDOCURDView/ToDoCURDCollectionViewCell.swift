//
//  ToDoCURDCollectionViewCell.swift
//  ToDo
//
//  Created by MAG on 08/08/2023.
//

import UIKit

class ToDoCURDCollectionViewCell: UICollectionViewCell {

    static var identifier = String(describing: ToDoCURDCollectionViewCell.self)


    func setupUI(_ colors: UIColor,isSelected: Bool){
         // Create a circular UIView
         let circleView = UIView()
         circleView.backgroundColor = colors // Customize the color
         circleView.layer.cornerRadius = 20
         circleView.translatesAutoresizingMaskIntoConstraints = false

        circleView.layer.borderWidth = isSelected ? 2 : 0
        circleView.layer.borderColor = isSelected ? UIColor.gray.cgColor : nil


         // Add the circle view to the cell's content view
         contentView.addSubview(circleView)

         // Set up constraints for the circle view
         NSLayoutConstraint.activate([
             circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
             circleView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8), // Customize the size
             circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor)
         ])
     }
}
