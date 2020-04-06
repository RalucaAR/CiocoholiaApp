//
//  ProductViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 07/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var productFirstImage: UIImageView!
    
    @IBOutlet weak var productImageView: UIView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    var product : ProductModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if product != nil {
            self.productDescription.text = product.description
            self.productFirstImage.image = UIImage(named: product.image)
            self.productPrice.text = product.price
            self.navigationItem.title = product.name
            self.productFirstImage.applyshadowWithCorner(containerView: self.productImageView, cornerRadious: 10)
        }
        
      
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImageView {
func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
    containerView.clipsToBounds = false
    containerView.layer.shadowColor = UIColor.orange.cgColor
    containerView.layer.shadowOpacity = 1
    containerView.layer.shadowOffset = CGSize.zero
    containerView.layer.shadowRadius = 10
    containerView.layer.cornerRadius = cornerRadious
    containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
    self.clipsToBounds = true
    self.layer.cornerRadius = cornerRadious
}
}
