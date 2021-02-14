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


    public override init() {
      super.init()
    }
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
      productsRequest?.cancel()
      productsRequestCompletionHandler = completionHandler

      productsRequest = SKProductsRequest(productIdentifiers: tipIDs)
      productsRequest!.delegate = self
      productsRequest!.start()
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()

        for p in products {
          print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
      print("Failed to load list of products.")
      print("Error: \(error.localizedDescription)")
      productsRequestCompletionHandler?(false, nil)
      clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
      productsRequest = nil
      productsRequestCompletionHandler = nil
    }
}
