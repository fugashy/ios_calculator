//
//  Model.swift
//  calculator
//
//  Created by fukukazu kawata on 2019/06/08.
//  Copyright © 2019 fugashy. All rights reserved.
//

import Foundation

private func plus(lhs: Double, rhs: Double) -> Double {
    return lhs + rhs
}
private func minus(lhs: Double, rhs: Double) -> Double {
    return lhs - rhs
}
private func multiple(lhs: Double, rhs: Double) -> Double {
    return lhs * rhs
}
private func division(lhs: Double, rhs: Double) -> Double {
    // swiftでは0で割っても例外にならない
    // その後の計算はすべてinfまたは-infになるがそれは仕方ないものとする
    return lhs / rhs
}

private let operators:[String] = ["+", "-", "*", "/"]
private let op_func_list:[(Double, Double) -> Double] = [plus, minus, multiple, division]

// 末尾が演算子かどうか
private func isSuffixOperator(string: String) -> Bool {
    for reserved_op in operators {
        if string.suffix(1) == reserved_op {
            return true
        }
    }
    return false
}

/*
 電卓の計算をするクラス
 基本的に値や演算子を正しさを確かめつつ文字列として溜め込んでいく(計算過程を表示するのが主な目的)
 計算するときに値と演算子を分離して計算する
 乗算・除算の優先度が考えられていないのが課題
 また，負の値や小数点を考慮できるようにする
 */
class Calculator {
    
    // 計算過程を文字列として保持する
    private var progress:String = "0.0"

    // 公開インターフェース
    public func InsertValue(value: Int) -> String {
        // 過程に追加する
        // 0の場合は付け足す意味はないので上書きする
        if Double(self.progress) == 0.0 {
            self.progress = String(value)
        } else {
            self.progress += String(value)
        }
        
        return self.progress
    }

    public func InsertOperator(op: String) -> String {
        // 過程の末尾が四則演算子の場合はなにもしない
        // TODO(fugashy) 負の値を入力するための処理を考える
        if isSuffixOperator(string: self.progress) {
            return self.progress
        }
        // 四則演算子以外は何もしない
        if !operators.contains(op) {
            return self.progress
        }
        
        self.progress += String(op)
        
        return self.progress
    }
    
    public func Execute() -> String {
        // 初期状態ならなにもしない
        if self.progress.isEmpty || Double(self.progress) == 0.0 {
           return self.progress
        } else if isSuffixOperator(string: self.progress) {
            return self.progress
        }
        // 過程を解析して計算を実行する
        // String.splitやString.componentsでは複数のデリミタを扱うことができなかったため，
        // 地道にやることにする
        var values:[Double?] = []
        var ops:[(Double, Double) -> Double] = []
        var previous_op_index = self.progress.startIndex
        for ip in 0 ..< self.progress.count {
            let idp = self.progress.index(self.progress.startIndex, offsetBy: ip)
            // 最後の値の抽出
            if ip == self.progress.count - 1 {
                values.append(Double(self.progress[self.progress.index(after: previous_op_index) ... idp]))
                break
            }
            // 演算子の発見
            // 発見した位置を記憶して，それまでの値を抽出する
            for io in 0 ..< operators.count {
                if Character(operators[io]) == self.progress[idp] {
                    values.append(Double(self.progress[previous_op_index ..< idp]))
                    ops.append(op_func_list[io])
                    previous_op_index = idp
                    break
                }
            }
        }
        // 計算の実行
        // 計算結果を後へ後へと引き継いでいく
        var operator_index = 0
        var result = values[0]!
        for iv in 1 ..< values.count {
            result = ops[operator_index](result, values[iv]!)
            operator_index += 1
        }
        
        self.progress = String(result)
        
        return self.progress
    }
    
    public func Reset() -> String {
        self.progress = "0.0"
        return self.progress
    }
    
    public func Backspace() -> String {
        // 空でない限り，一文字削除する
        if self.progress.count != 0 {
            // 最後のindexを得る
            let final_index = self.progress.index(self.progress.startIndex, offsetBy: self.progress.count - 1)
            // 最後のindexを含まないようにする
            self.progress = String(self.progress[self.progress.startIndex ..< final_index])
        }
        return self.progress
    }
}
