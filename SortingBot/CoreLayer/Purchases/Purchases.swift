//
//  Purchases.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation
import StoreKit
import SwiftyReceiptValidator

typealias RequestProductsResult = Result<[SKProduct], Error>
typealias PurchaseProductResult = Result<Bool, Error>

typealias RequestProductsCompletion = (RequestProductsResult) -> Void
typealias PurchaseProductCompletion = (PurchaseProductResult) -> Void

class Purchases: NSObject {
    static let `default` = Purchases()

    private let productIdentifiers = Set<String>(arrayLiteral: "Remove_adds")
    private let receiptValidator = SwiftyReceiptValidator(configuration: .standard,
                                                          isLoggingEnabled: false)
    private let sharedSecret = "b72d47cb0f14445e9845730efbec15a2"

    private var products: [String: SKProduct]?
    private var productRequest: SKProductsRequest?
    private var productPurchaseCallback: ((PurchaseProductResult) -> Void)?

    func initialize(completion: @escaping RequestProductsCompletion) {
        requestProducts(completion: completion)
        SKPaymentQueue.default().add(self)
    }
    
    private var productsRequestCallbacks = [RequestProductsCompletion]()
    
    private func requestProducts(completion: @escaping RequestProductsCompletion) {
        guard productsRequestCallbacks.isEmpty else {
            productsRequestCallbacks.append(completion)
            return
        }
        
        productsRequestCallbacks.append(completion)
        
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
        
        self.productRequest = productRequest
    }
}

extension Purchases: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else {
            print("Found 0 products")

            productsRequestCallbacks.forEach { $0(.success(response.products)) }
            productsRequestCallbacks.removeAll()
            return
        }

        var products = [String: SKProduct]()
        for skProduct in response.products {
            print("Found product: \(skProduct.productIdentifier)")
            products[skProduct.productIdentifier] = skProduct
        }

        self.products = products

        productsRequestCallbacks.forEach { $0(.success(response.products)) }
        productsRequestCallbacks.removeAll()
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products with error:\n \(error)")
        productsRequestCallbacks.forEach { $0(.failure(error)) }
        productsRequestCallbacks.removeAll()
    }
}

// Покупка
extension Purchases {
    
    func purchaseProduct(productId: String, completion: @escaping (PurchaseProductResult) -> Void) {
        
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        guard let product = products?[productId] else {
            completion(.failure(PurchasesError.productNotFound))
            return
        }
        
        productPurchaseCallback = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases(completion: @escaping PurchaseProductCompletion) {
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        productPurchaseCallback = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension Purchases: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                let productId = transaction.payment.productIdentifier
                let validationRequest = SRVPurchaseValidationRequest(
                    productId: productId,
                    sharedSecret: sharedSecret
                )
                if finishTransaction(transaction) {
                    receiptValidator.validate(validationRequest) { result in
                        switch result {
                        case .success(let response):
                            print("Receipt validation was successfull with receipt response \(response)")
                            SKPaymentQueue.default().finishTransaction(transaction)
                            self.productPurchaseCallback?(.success(true))
                        case .failure(let error):
                            print("Receipt validation failed with error \(error.localizedDescription)")
                            self.productPurchaseCallback?(.failure(PurchasesError.unknown))
                        }
                        self.productPurchaseCallback = nil
                    }
                } else {
                    productPurchaseCallback?(.failure(PurchasesError.unknown))
                    productPurchaseCallback = nil
                }
            case .failed:
                productPurchaseCallback?(.failure(transaction.error ?? PurchasesError.unknown))
                SKPaymentQueue.default().finishTransaction(transaction)
                productPurchaseCallback = nil
            default:
                break
            }
        }
    }
    
}

extension Purchases {
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error)
    }
    
    func finishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
        let productId = transaction.payment.productIdentifier
        print("Product \(productId) successfully purchased")
        return true
    }
}
