//
//  OrdersWorker.swift
//  CleanStore
//
//  Created by Pete Barnes on 3/17/19.
//  Copyright © 2019 Pete Barnes. All rights reserved.
//

import Foundation

class OrdersWorker
{
    var ordersStore: OrdersStoreProtocol
    init(ordersStore: OrdersStoreProtocol) {
        self.ordersStore = ordersStore
    }
    
    func fetchOrders(completionHandler: @escaping ([Order]) -> Void) {
        ordersStore.fetchOrders { (orders: () throws -> [Order]) -> Void in
            do {
                let orders = try orders()
                DispatchQueue.main.async {
                    completionHandler(orders)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
}

// MARK: - Orders store API

protocol OrdersStoreProtocol {
    
    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void)
}
