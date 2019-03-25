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
    
    func createOrder(orderToCreate: Order, completionHandler: @escaping (Order?) -> Void) {
        ordersStore.createOrder(orderToCreate: orderToCreate) { (order: () throws -> Order?) -> Void in
            do {
                let order = try order()
                DispatchQueue.main.async {
                    completionHandler(order)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func updateOrder(orderToUpdate: Order, completionHandler: @escaping (Order?) -> Void) {
        ordersStore.updateOrder(orderToUpdate: orderToUpdate) { (order: () throws -> Order?) in
            do {
                let order = try order()
                DispatchQueue.main.async {
                    completionHandler(order)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
}

// MARK: - Orders store API

protocol OrdersStoreProtocol {
    
    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void)
    func createOrder(orderToCreate: Order, completionHandler: @escaping(() throws -> Order?) -> Void)
    func updateOrder(orderToUpdate: Order, completionHandler: @escaping (() throws -> Order?) -> Void)
}

// MARK: - Orders Store Error
enum OrdersStoreError: Equatable, Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

func ==(lhs: OrdersStoreError, rhs: OrdersStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b:
        return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b:
        return true
    case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b:
        return true
    case (.CannotDelete(let a), .CannotDelete(let b)) where a == b:
        return true
    default: return false
    }
}
