//
//  ShowOrderInteractor.swift
//  CleanStore
//
//  Created by Pete Barnes on 3/17/19.
//  Copyright (c) 2019 Pete Barnes. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowOrderBusinessLogic {
    func doSomething(request: ShowOrder.Something.Request)
}

protocol ShowOrderDataStore {
    //var name: String { get set }
}

class ShowOrderInteractor: ShowOrderBusinessLogic, ShowOrderDataStore {
    var presenter: ShowOrderPresentationLogic?
    var worker: ShowOrderWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: ShowOrder.Something.Request) {
        worker = ShowOrderWorker()
        worker?.doSomeWork()
        
        let response = ShowOrder.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
