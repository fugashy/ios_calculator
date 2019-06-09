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

/*
 電卓の計算をするクラス
 基本的に値や演算子を正しさを確かめつつ文字列として溜め込んでいく(計算過程を表示するのが主な目的)
 計算するときに値と演算子を分離して計算する
 乗算・除算の優先度が考えられていないのが課題
 */
class Calculator {
    
    private let operators:[String] = ["+", "-", "*", "/"]
    private let op_func_list:[(Double, Double) -> Double] = [plus, minus, multiple, division]
    
    // 公開インターフェース
    public func InsertValue(value: Int) -> String {
        // 過程に追加する
        // 無条件に入れてもとくに問題ない
        progress += String(value)
        
        return progress
    }

    public func InsertOperator(op: String) -> String {
        // 過程の末尾が四則演算子の場合は
        for reserved_op in operators {
            if progress.suffix(1) == reserved_op {
                return progress
            }
        }
        // 四則演算子以外は何もしない
        if !operators.contains(op) {
            return progress
        }
        
        progress += String(op)
        
        return progress
    }
    
    public func Execute() -> String {
        // 初期状態ならなにもしない
        if progress.isEmpty || progress == "0.0" {
           return progress
        }
        // 過程を解析して計算を実行する
        // String.splitやString.componentsでは複数のデリミタを扱うことができなかったため，
        // 地道にやることにする
        var values:[Double?] = []
        var ops:[(Double, Double) -> Double] = []
        var previous_op_index = progress.startIndex
        for ip in 0 ..< progress.count {
            let idp = progress.index(progress.startIndex, offsetBy: ip)
            // 最後の値の抽出
            if ip == progress.count - 1 {
                values.append(Double(progress[progress.index(after: previous_op_index) ... idp]))
                break
            }
            // 演算子の発見
            // 発見した位置を記憶して，それまでの値を抽出する
            for io in 0 ..< operators.count {
                if Character(operators[io]) == progress[idp] {
                    values.append(Double(progress[previous_op_index ..< idp]))
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
        
        progress = String(result)
        
        return progress
    }
    
    public func Reset() -> String {
        progress = "0.0"
        return progress
    }
    
    private var progress:String = ""
}
