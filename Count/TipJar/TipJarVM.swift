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
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init(){
        Store.tipJar.setCallBack(self.onTryPurchaseResponse)
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
    
    public func onTryPurchaseResponse(_ success: Bool, _ prodId: String){
        if(success){
            self.alertTitle = "Thank You!"
            self.alertMessage = prodIdToMessage(prodId)
        } else{
            self.alertTitle = "Error"
            self.alertMessage = "Something went wrong. You weren't charged."
        }
        self.showAlert = true
    }
    
    private func prodIdToMessage(_ prodId: String) -> String{
        switch(prodId){
        case "com.MichaelPhelan.CountFit.SmallTip":
            return "Every little bit helps"
        case "com.MichaelPhelan.CountFit.MediumTip":
            return "Very Appreciated"
        case "com.MichaelPhelan.CountFit.LargeTip":
            return "You went above and beyond"
        case "com.MichaelPhelan.CountFit.HugeTip":
            return "I'm speechless"
        default:
            return ""
        }
    }
    
    public func tip(_ option: TipOption){
        Store.tipJar.buyProduct(option.product)
    }
    
    public func canTip() -> Bool{
        return Store.tipJar.canMakePayments()
    }
}
