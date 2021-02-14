//
//  TipJarVM.swift
//  Count
//
//  Created by Michael Phelan on 2/14/21.
//  Copyright © 2021 MichaelPhelan. All rights reserved.
//

import Foundation
import StoreKit

class TipOption: Identifiable{
    var product: SKProduct
    init(_ skProd:SKProduct){
        product = skProd
    }
}

class TipJarVM : ObservableObject{
    @Published var tipOptions: [TipOption] = []
    
    init(){
        Store.tipJar.requestProducts{success, products in
            DispatchQueue.main.async {
                if(success){
                    self.tipOptions = products!.map{(skProd)->TipOption in return TipOption(skProd)}
                    self.tipOptions.sort{$0.product.price.decimalValue < $1.product.price.decimalValue}
                }
                else{
                    self.tipOptions = []
                }
            }
        }
    }
}
