//
//  ACADFreeVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import StoreKit

enum ServiceError: ErrorType {
    case Empty
    case Overload
}

class ACADFreeVC: UIViewController,SKProductsRequestDelegate,SKPaymentTransactionObserver {

    var statusOne = Bool()
    var statusTwo = Bool()
    var productIDs: Array<String!> = []
    var productsArray: Array<SKProduct!> = []
    var transactionInProgress = false
    
    @IBOutlet weak var adFreeTblView: UITableView!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()

    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Purchase Ad Free Version"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        statusOne = true
        self.productIDs.append("com.monthlyPaid")
        self.productIDs.append("com.yearlyPaid")
        requestProductInfo()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
        // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let adCell = tableView.dequeueReusableCellWithIdentifier("ACAdFreeTVCellID", forIndexPath: indexPath) as! ACAdFreeTVCell
        if indexPath.row == 0 {
            adCell.itemLabel.text = "$1 per Month"
            adCell.selectButton.selected = statusOne
        } else {
            adCell.itemLabel.text = "$5 per Year"
            adCell.selectButton.selected = statusTwo
        }
        
        return adCell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            statusOne = true
            statusTwo = false
        } else {
            statusTwo = true
            statusOne = false
        }
        adFreeTblView.reloadData()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            statusOne = false
        } else {
            statusTwo = false
        }
        adFreeTblView.reloadData()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 50))
        let label = UILabel(frame: CGRectMake(10, 10, tableView.bounds.size.width, 30))
        label.font = UIFont(name: "VarelaRound", size: 16)
        label.text = "Choose your Plan :"
        label.textColor = UIColor.blackColor()
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - UIButton Action Methods
    @IBAction func purchaseButtonAction(sender: UIButton) {
        if statusOne == true {
          purchaseProduct(0)
        } else {
           purchaseProduct(1)
        }
        
    }
    
    ////////////////// In App Purchase /////////////////
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productId = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productId as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func purchaseProduct(index : NSInteger) {
        if transactionInProgress {
            return
        }
        if self.productsArray.count > 0 {
            let payment = SKPayment(product: self.productsArray[index] as SKProduct)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
        }
    }
    
    //MARK:- StoreKit Delegate
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                if transaction.payment.productIdentifier == "com.monthlyPaid" {
                    callApiForPurchaseAdFree("monthly")
                } else if transaction.payment.productIdentifier == "com.yearlyPaid"{
                    callApiForPurchaseAdFree("yearly")
                }
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed");
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
        } else {
            AlertController.alert("Not Available", message: "No products to purchase.")
        }
    }
    

    //MARK:- Web API Methods
    func callApiForPurchaseAdFree(paymentType : String) {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACPaymentType] = paymentType
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/payment", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        AlertController.alert("", message: res.objectForKeyNotNull("responseMessage", expected: "") as! String, buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
                            if position == 0 {
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                        })
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
}
