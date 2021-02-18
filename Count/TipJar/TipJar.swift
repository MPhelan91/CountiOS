//
//  TipJar.swift
//  Count
//
//  Created by Michael Phelan on 2/14/21.
//  Copyright © 2021 MichaelPhelan. All rights reserved.
//

import StoreKit

public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

public struct Store {
    public static let tipJar = TipJar()
}

public class TipJar: NSObject, SKProductsRequestDelegate {
    let tipIDs : Set<String> = [
        "com.MichaelPhelan.CountFit.SmallTip",
        "com.MichaelPhelan.CountFit.MediumTip",
        "com.MichaelPhelan.CountFit.LargeTip",
        "com.MichaelPhelan.CountFit.HugeTip"
    ]
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var productsRequest: SKProductsRequest?
    private var callBack : ((Bool,String)->Void)?
    
    public override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: tipIDs)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        //TODO: ERROR Handling
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

extension TipJar : SKPaymentTransactionObserver{
    public func setCallBack(_ callBack: @escaping (Bool, String)->Void){
        self.callBack = callBack
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                if(self.callBack != nil){
                    self.callBack!(true, transaction.payment.productIdentifier)
                }
                break
            case .failed:
                if(self.callBack != nil){
                    self.callBack!(false, transaction.payment.productIdentifier)
                }
                break
            default:
                break
            }
        }
    }
}
