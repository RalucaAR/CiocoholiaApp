//
//  ViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 04/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [CategoryModel] = []
    
    var productCategories: [String] = []
    var productImages: [String] = []
    var indicator: ProgressIndicator?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.black, msg: "Loading product categories...")
               self.view.addSubview(indicator!)
        initialiseLists()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getProductsFromDB(success: @escaping (Bool) -> Void) {
        indicator!.start()
        let ref = Firestore.firestore().collection(CollectionPaths.categories)
        ref.getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("Error getting documents!")
            } else {
                for document in querySnapshot!.documents {
                    self.indicator!.stop()
                    let category = CategoryModel()
                    category.image = document["image"] as? String
                    category.name   = document["name"] as? String
                    self.categories.append(category)
                }
                success(true)
            }
        }
    }
    
    func initialiseLists() {
        getProductsFromDB{(success) in
            if success {
                for prod in self.categories {
                    self.productImages.append(prod.image ?? "")
                    self.productCategories.append(prod.name ?? "")
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.categoryLabel.text = productCategories[indexPath.item]
        cell.categoryLabel.textColor = UIColor.orange
        
        ImageLoader.image(for:  NSURL(string: productImages[indexPath.item])! as URL) { (image) in
            cell.categoryImage.image = image
        }
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
    let padding: CGFloat =  95
    let collectionViewSize = collectionView.frame.size.width - padding
    let collectionViewHeigth = collectionView.frame.size.height
    return CGSize(width: collectionViewSize/2, height: collectionViewHeigth/6)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.orange.cgColor
        cell?.layer.borderWidth = 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "toCategoryTableViewSegue")
        {
            let nextScene = segue.destination as! UITableViewController
            let cell = sender as! UICollectionViewCell
            let index = self.collectionView.indexPath(for: cell)
            nextScene.title = self.productCategories[index?.row ?? 0] as String
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 0.5
    }



}

