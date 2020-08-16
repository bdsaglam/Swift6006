//
//  NewtonsMethod.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 16.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


enum NewtonSolverError: Error {
    case reachedMaxStep
}

// MARK: Newton's solver for integer

func solveNewton(
    updateFunction uf: (Int) -> (Int),
    initialGuess: Int,
    maxStep: Int = 1_000_000,
    consecutiveAbsTol: Int = 1
) throws -> Int
{
    var step = 0
    var x = initialGuess
    
    while true {
        let xnew = uf(x)
        
        if abs(xnew - x) <= consecutiveAbsTol { return xnew }
        
        x = xnew
        step += 1
        guard step < maxStep else {
            throw NewtonSolverError.reachedMaxStep
        }
    }
}

// MARK: Newton's solver for double

typealias UnivariateNumericFunction = (Double) -> (Double)

// This uses f(x) and its derivative df(x), and be aware that division is slow
func solveNewton(
    function f: UnivariateNumericFunction,
    derivateOfFunction df: UnivariateNumericFunction,
    initialGuess: Double,
    maxStep: Int = 1_000_000,
    atol: Double = 1e-6
) throws -> Double
{
    let fdf: UnivariateNumericFunction = { x in f(x) / df(x) }
    return try solveNewton(
        function: f,
        functionDividedByDerivate: fdf,
        initialGuess: initialGuess,
        maxStep: maxStep,
        atol: atol
    )
   
}

// This uses f(x) and fdf(x) = f(x)/df(x), since there is no division, it is better
func solveNewton(
    function f: UnivariateNumericFunction,
    functionDividedByDerivate fdf: UnivariateNumericFunction,
    initialGuess: Double,
    maxStep: Int = 1_000_000,
    atol: Double = 1e-6
) throws -> Double
{
    var step = 0
    var x = initialGuess
    
    while true {
        let y = f(x)
        if abs(y) < atol { return x }
        
        x = x - fdf(x)
        
        step += 1
        guard step < maxStep else {
            throw NewtonSolverError.reachedMaxStep
        }
    }
    
}

// This uses the update function, uf(x) = x - f(x)/d(fx)
// This is even better since update function is the final form and possibly most simplest
// However, since we don't have f(x) now, we cannot compute for absolute tolerance
func solveNewton(
    updateFunction uf: UnivariateNumericFunction,
    initialGuess: Double,
    maxStep: Int = 1_000_000,
    rtol: Double = 1e-6
) throws -> Double
{
    var step = 0
    var x = initialGuess
    
    while true {
        let xnew = uf(x)
        if abs(xnew/x - 1) < rtol { return xnew }
        
        x = xnew
        step += 1
        guard step < maxStep else {
            throw NewtonSolverError.reachedMaxStep
        }
    }
}
