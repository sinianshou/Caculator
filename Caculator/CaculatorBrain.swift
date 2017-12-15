//
//  CaculatorBrain.swift
//  Caculator
//
//  Created by Easer Liu on 13/11/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

import Foundation

class CaculatorBrain{
    
    private var accumulator = 0.0
    
    func setOperaned(operand: Double) {
        accumulator = operand
    }
    
    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    //+−×÷±√π
    var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(sqrt),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "=" : Operation.Equals
    ]
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var Pending: PendingBinaryOperationInfo?
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                Pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if Pending != nil {
            accumulator = Pending!.binaryFunction(Pending!.firstOperand, accumulator)
            Pending = nil
        }
    }
    
    var result: Double {
        get{
            return accumulator
        }
    }
}
