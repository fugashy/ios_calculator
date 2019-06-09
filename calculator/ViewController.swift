//
//  ViewController.swift
//  calculator
//
//  Created by fukukazu kawata on 2019/06/08.
//  Copyright © 2019 fugashy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var calculator:Calculator = Calculator()
    
    // 計算結果表示ラベル
    @IBOutlet weak var result: UILabel!
    
    // ビュー表示後処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // 数値ボタン押下イベント
    @IBAction func receivedValues(_ sender: UIButton) {
        // tagの値と数値が一致しているので，そのまま追加する
        self.result.text = self.calculator.InsertValue(value: sender.tag)
    }
    
    @IBAction func reveivedOperators(_ sender: UIButton) {
        // ボタン別に入力する演算子文字列を変える
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
        self.result.text = self.calculator.InsertOperator(op: operator_string)
    }
    
    @IBAction func receivedPerformances(_ sender: UIButton) {
        if sender.tag == 14 {
            self.result.text = self.calculator.Execute()
        } else if sender.tag == 15 {
            self.result.text = self.calculator.Reset()
        }
    }
}
