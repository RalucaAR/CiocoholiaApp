//
//  ProductViewModel.swift
//  Project
//
//  Created by Inovium Digital Vision on 06/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class ProductViewModel {
    var levelsList: [ProductModel] = [ProductModel]()
    
    func getDataFromAPI(result: @escaping (Bool) -> ()) {
        let session: APIModel = APIModel()
        session.getProducts{ productsList, succeeded  in
            guard succeeded == true,
                let productsList = productsList else {
                
                    self.levelsList = [ProductModel]()
                result(false)
                return
            }
            
            self.levelsList = productsList
            result(true)
        }
    }

}
