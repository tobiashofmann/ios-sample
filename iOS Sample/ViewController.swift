//
//  ViewController.swift
//  EnBWUITest
//
//  Created by Tobias Hofmann on 17.07.18.
//  Copyright © 2018 itsfullofstars. All rights reserved.
//

import Alamofire
import os.log
import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    // MARK: Properties
    private var sum: Int = 0

    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnLoadData: UIButton!
    @IBOutlet weak var txtShowData: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Calculator

    public func doCalc(numberOne: Int, numberTwo: Int) {
        self.sum = numberOne + numberTwo
    }

    public func getSum() -> Int {
        return self.sum
    }


    // MARK: Actions

    @IBAction func navNext(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toDetail", sender: sender)
    }


    @IBAction func loadData(_ sender: UIButton) {
        self.readData()
    }

    // MARK: - Navigation

    @IBAction func unwindToMaster(sender: UIStoryboardSegue) {
        os_log("unwindToMaster", log: OSLog.default, type: .debug)

        if sender.source is DetailController {
            os_log("unwindToMain: DetailController", log: OSLog.default, type: .debug)
        } else {
            os_log("unwindToStart: error", log: OSLog.default, type: .debug)
        }
        print("unwindToMaster END")
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {
        case "toDetail":
            os_log("Navigating to Details", log: OSLog.default, type: .debug)

            guard segue.destination is DetailController else {
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // MARK: Private functions

    private func updateUI() {
        self.lblName.isHidden = true
        self.lblDescription.isHidden = true
        self.txtName.isHidden = true
        self.txtDescription.isHidden = true
    }

    private func readData() {

        var localFileUrl: NSURL
        var path: String?

        path = Bundle.main.path(forResource: "test", ofType: "json")
        localFileUrl = NSURL.fileURL(withPath: path!) as NSURL
        print(localFileUrl)

        let url=URL(fileURLWithPath: path!)

        print("url")
        print (url)

        //Alamofire.request("https://httpbin.org/get")
        Alamofire.request(url)

            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")

                    print("Request: \(String(describing: response.request))")   // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)")                         // response serialization result

                    if let jsonResponse = response.result.value {
                        print("JSON: \(jsonResponse)") // serialized json response
                    }

                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string

                        self.txtShowData.text = utf8Text

                        let json = JSON(response.result.value)
                        print("JSON: \(json)")

                        if let userName = json["a"]["name"].string {
                            print(userName)
                            OperationQueue.main.addOperation({
                                self.txtName.text = userName
                                self.txtName.isHidden = false
                                self.lblName.isHidden = false
                            })
                        }
                        if let description = json["a"]["desc"].string {
                            print(description)
                            OperationQueue.main.addOperation({
                                self.txtDescription.text = description
                                self.txtDescription.isHidden = false
                                self.lblDescription.isHidden = false
                            })
                        }
                    }

                case .failure(let error):
                    print(error)
                }

        }

    }

}

