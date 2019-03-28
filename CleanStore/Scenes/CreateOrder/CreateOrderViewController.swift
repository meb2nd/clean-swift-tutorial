//
//  CreateOrderViewController.swift
//  CleanStore
//
//  Created by Pete Barnes on 3/16/19.
//  Copyright (c) 2019 Pete Barnes. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CreateOrderDisplayLogic: class {
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
    func displayCreatedOrder(viewModel: CreateOrder.CreateOrder.ViewModel)
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel)
    func displayUpdatedOrder(viewModel: CreateOrder.UpdateOrder.ViewModel)
}

class CreateOrderViewController: UITableViewController, CreateOrderDisplayLogic {
    
    var interactor: CreateOrderBusinessLogic?
    var router: (NSObjectProtocol & CreateOrderRoutingLogic & CreateOrderDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CreateOrderInteractor()
        let presenter = CreateOrderPresenter()
        let router = CreateOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePickers()
        showOrderToEdit()
    }
    
    func configurePickers()
    {
        shippingMethodTextField.inputView = shippingMethodPicker
        expirationDateTextField.inputView = expirationDatePicker
    }
    
    func showOrderToEdit() {
        let request = CreateOrder.EditOrder.Request()
        interactor?.showOrderToEdit(request: request)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    // MARK: Text fields
    
    @IBOutlet var textFields: [UITextField]!
    
    // MARK: Shipping method
    
    @IBOutlet weak var shippingMethodTextField: UITextField!
    @IBOutlet var shippingMethodPicker: UIPickerView!
    
    // MARK: Expiration date
    
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet var expirationDatePicker: UIDatePicker!
    
    @IBAction func expirationDatePickerValueChanged(_ sender: Any) {
        
        let date = expirationDatePicker.date
        let request = CreateOrder.FormatExpirationDate.Request(date: date)
        interactor?.formatExpirationDate(request: request)
    }
    
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel) {
        
        let date = viewModel.date
        expirationDateTextField.text = date
    }
    
    // MARK: Display Created Order
    
    func displayCreatedOrder(viewModel: CreateOrder.CreateOrder.ViewModel) {
        if viewModel.order != nil {
            router?.routeToListOrders(segue: nil)
        } else {
            showOrderFailureAlert(title: "Failed to create order", message: "Please correct your order and submit again.")
        }
    }
    
    private func showOrderFailureAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        showDetailViewController(alertController, sender: nil)
    }
    
    // MARK: - Create order
    
    // MARK: Contact info
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: Payment info
    @IBOutlet weak var billingAddressStreet1TextField: UITextField!
    @IBOutlet weak var billingAddressStreet2TextField: UITextField!
    @IBOutlet weak var billingAddressCityTextField: UITextField!
    @IBOutlet weak var billingAddressStateTextField: UITextField!
    @IBOutlet weak var billingAddressZIPTextField: UITextField!
    
    @IBOutlet weak var creditCardNumberTextField: UITextField!
    @IBOutlet weak var ccvTextField: UITextField!
    
    // MARK: Shipping info
    @IBOutlet weak var shipmentAddressStreet1TextField: UITextField!
    @IBOutlet weak var shipmentAddressStreet2TextField: UITextField!
    @IBOutlet weak var shipmentAddressCityTextField: UITextField!
    @IBOutlet weak var shipmentAddressStateTextField: UITextField!
    @IBOutlet weak var shipmentAddressZIPTextField: UITextField!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // MARK: Contact info
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let phone = phoneTextField.text!
        let email = emailTextField.text!
        // MARK: Payment info
        let billingAddressStreet1 = billingAddressStreet1TextField.text!
        let billingAddressStreet2 = billingAddressStreet2TextField.text!
        let billingAddressCity = billingAddressCityTextField.text!
        let billingAddressState = billingAddressStateTextField.text!
        let billingAddressZIP = billingAddressZIPTextField.text!
        let paymentMethodCreditCardNumber = creditCardNumberTextField.text!
        let paymentMethodCVV = ccvTextField.text!
        let paymentMethodExpirationDate = expirationDatePicker.date
        let paymentMethodExpirationDateString = ""
        // MARK: Shipping info
        let shipmentAddressStreet1 = shipmentAddressStreet1TextField.text!
        let shipmentAddressStreet2 = shipmentAddressStreet2TextField.text!
        let shipmentAddressCity = shipmentAddressCityTextField.text!
        let shipmentAddressState = shipmentAddressStateTextField.text!
        let shipmentAddressZIP = shipmentAddressZIPTextField.text!
        let shipmentMethodSpeed = shippingMethodPicker.selectedRow(inComponent: 0)
        let shipmentMethodSpeedString = ""
        // MARK: Misc
        var id: String? = nil
        var date = Date()
        var total = NSDecimalNumber.notANumber
        
        if let orderToEdit = interactor?.orderToEdit {
            id = orderToEdit.id
            date = orderToEdit.date
            total = orderToEdit.total
            let request = CreateOrder.UpdateOrder.Request(orderFormFields: CreateOrder.OrderFormFields(firstName: firstName, lastName:
                    lastName, phone: phone, email: email, billingAddressStreet1:
                    billingAddressStreet1, billingAddressStreet2: billingAddressStreet2, billingAddressCity: billingAddressCity, billingAddressState: billingAddressState, billingAddressZIP: billingAddressZIP,
                                                paymentMethodCreditCardNumber: paymentMethodCreditCardNumber, paymentMethodCVV:
                    paymentMethodCVV, paymentMethodExpirationDate: paymentMethodExpirationDate,
                                      paymentMethodExpirationDateString: paymentMethodExpirationDateString,
                                      shipmentAddressStreet1: shipmentAddressStreet1, shipmentAddressStreet2: shipmentAddressStreet2, shipmentAddressCity:
                    shipmentAddressCity, shipmentAddressState: shipmentAddressState,
                                         shipmentAddressZIP: shipmentAddressZIP, shipmentMethodSpeed: shipmentMethodSpeed, shipmentMethodSpeedString: shipmentMethodSpeedString,
                                                      id: id, date: date, total: total))
            interactor?.updateOrder(request: request)
        } else {
        let request = CreateOrder.CreateOrder.Request(orderFormFields:
            CreateOrder.OrderFormFields(firstName: firstName, lastName: lastName, phone: phone, email: email, billingAddressStreet1: billingAddressStreet1,
                billingAddressStreet2: billingAddressStreet2,
                billingAddressCity: billingAddressCity, billingAddressState:
                billingAddressState, billingAddressZIP: billingAddressZIP, paymentMethodCreditCardNumber: paymentMethodCreditCardNumber, paymentMethodCVV: paymentMethodCVV, paymentMethodExpirationDate: paymentMethodExpirationDate, paymentMethodExpirationDateString: paymentMethodExpirationDateString, shipmentAddressStreet1: shipmentAddressStreet1,
                                            shipmentAddressStreet2: shipmentAddressStreet2, shipmentAddressCity:
                shipmentAddressCity, shipmentAddressState: shipmentAddressState,
                                     shipmentAddressZIP: shipmentAddressZIP, shipmentMethodSpeed: shipmentMethodSpeed, shipmentMethodSpeedString: shipmentMethodSpeedString,
                                                  id: id, date: date, total: total))
        interactor?.createOrder(request: request)
        }
    }
    
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel) {
        let orderFormFields = viewModel.orderFormFields
        firstNameTextField.text = orderFormFields.firstName
        lastNameTextField.text = orderFormFields.lastName
        phoneTextField.text = orderFormFields.phone
        emailTextField.text = orderFormFields.email
        billingAddressStreet1TextField.text = orderFormFields.billingAddressStreet1
        billingAddressStreet2TextField.text = orderFormFields.billingAddressStreet2
        billingAddressCityTextField.text = orderFormFields.billingAddressCity
        billingAddressStateTextField.text = orderFormFields.billingAddressState
        billingAddressZIPTextField.text = orderFormFields.billingAddressZIP
        creditCardNumberTextField.text = orderFormFields.paymentMethodCreditCardNumber
        ccvTextField.text = orderFormFields.paymentMethodCVV
        shipmentAddressStreet1TextField.text = orderFormFields.shipmentAddressStreet1
        shipmentAddressStreet2TextField.text = orderFormFields.shipmentAddressStreet2
        shipmentAddressCityTextField.text = orderFormFields.shipmentAddressCity
        shipmentAddressStateTextField.text = orderFormFields.shipmentAddressState
        shipmentAddressZIPTextField.text = orderFormFields.shipmentAddressZIP
        shippingMethodPicker.selectRow(orderFormFields.shipmentMethodSpeed, inComponent: 0, animated: true)
        shippingMethodTextField.text = orderFormFields.shipmentMethodSpeedString
        expirationDatePicker.date = orderFormFields.paymentMethodExpirationDate
        expirationDateTextField.text = orderFormFields.paymentMethodExpirationDateString
    }
    
    func displayUpdatedOrder(viewModel: CreateOrder.UpdateOrder.ViewModel) {
        if viewModel.order != nil {
            router?.routeToShowOrder(segue: nil)
        } else {
            showOrderFailureAlert(title: "Failed to update order", message:
                "Please correct your order and submit again.")
        }
    }
    
    // MARK: CreateOrderViewController: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            for textField in textFields {
                if textField.isDescendant(of: cell) {
                    textField.becomeFirstResponder()
                }
            }
        }
    }
}

// MARK: CreateOrderViewController: UITextFieldDelegate

extension CreateOrderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let index = textFields.index(of: textField) {
            if index < textFields.count - 1 {
                let nextTextField = textFields[index + 1]
                nextTextField.becomeFirstResponder()
            }
        }
        return true
    }
}

// MARK: CreateOrderViewController: UIPickerViewDataSource

extension CreateOrderViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return interactor?.shippingMethods.count ?? 0
    }
}

// MARK: CreateOrderViewController: UIPickerViewDelegate

extension CreateOrderViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return interactor?.shippingMethods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shippingMethodTextField.text = interactor?.shippingMethods[row]
    }
}
