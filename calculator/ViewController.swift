//
//  ViewController.swift
//  calculator
//
//  Created by fukukazu kawata on 2019/06/08.
//  Copyright © 2019 fugashy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 計算結果表示ラベル
    @IBOutlet weak var result: UILabel!
    
    // ビュー表示後処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("ViewController.viewDidLoad")
    }
    
    // 数値ボタン押下イベント
    @IBAction func receivedValues(_ sender: UIButton) {
        result.text = String(sender.tag)
    }
    
    @IBAction func reveivedOperators(_ sender: UIButton) {
        var operator_string = ""
        if sender.tag == 10 {
            operator_string = "/"
        } else if sender.tag == 11 {
            operator_string = "*"
        } else if sender.tag == 12 {
            operator_string = "-"
        } else if sender.tag == 13 {
            operator_string = "+"
        }
        result.text = operator_string
    }
    
    @IBAction func receivedPerformances(_ sender: UIButton) {
        print("receivedPerformances")
    }
}
