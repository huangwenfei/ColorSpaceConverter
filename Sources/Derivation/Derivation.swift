//
//  Derivation.swift
//  ColorSpaceConverter
//
//  /colour/colour/models/rgb/derivation.py
//
//  Created by 黄文飞 on 2023/4/9.
//

import Foundation

public struct Derivation {
    
    /// primaries: `3 * 2`, whitepoint: `1 * 2`, result: `3 * 3`
    public static func normalisedPrimaryMatrix(primaries: ColorElement.Matrix, whitepoint: ColorElement.Matrix) -> ColorElement.Matrix {
        
        let z = xy2z(xy: primaries)
        
//        print()
//        print("z", z)
        
        let primaries = Math.transpose(combineH(xy: primaries, z: z))
        
//        print("primaries", primaries)
        
        let ones = ColorElement.Matrix(.init(repeating: 1, count: primaries.count), primaries.rows, primaries.columns)
        let primariesInv = Math.inv(primaries) ?? ones
//        print("primariesInv", primariesInv)
        
        let whitepoint = xyY.xy2xyz(xy: whitepoint).rowColumnSwitch()
//        print("whitepoint", whitepoint)
        
        let coefficients = Math.mul(mat1: primariesInv, mat2: whitepoint).rowColumnSwitch()
//        print("coefficients", coefficients)
        
        let coefficientsDiag = Math.diagflat(mat: coefficients)
//        print("coefficientsDiag", coefficientsDiag)
        
        let npm = Math.mul(mat1: primaries, mat2: coefficientsDiag)
        
        return npm
    }
    
    /// `3 * 2` -> `3 * 1`
    public static func xy2z(xy: ColorElement.Matrix) -> ColorElement.Matrix {

        var result = ColorElement.Matrix(
            .init(repeating: 0, count: xy.rows), xy.rows, 1
        )
        
        /// z = 1 - x - y
        for v in stride(from: 0, to: xy.values.count - 1, by: xy.columns) {
            result.values[v / xy.columns] = 1 - (
                xy.values[v ..< (v + xy.columns)].reduce(0, { $0 + $1 })
            )
        }
        
        return result
    }
    
    /// `3 * 2` + `3 * 1` -> `3 * 3`
    public static func combineH(xy: ColorElement.Matrix, z: ColorElement.Matrix) -> ColorElement.Matrix {
        
        precondition(xy.rows == z.rows)
        
        var result = ColorElement.Matrix(
            .init(repeating: 0, count: xy.rows * z.rows),
            xy.rows,
            z.rows
        )
        
        /// v :`0 -> 3 -> 6`
        /// subv: `0 -> 1 -> 2`
        for v in stride(from: 0, to: result.values.count - 1, by: xy.rows) {
            let subv = v / xy.rows
            
            let xyRange = v ..< (v + xy.columns)
            let xySubRange = (subv * xy.columns) ..< ((subv * xy.columns) + xy.columns)
            
            result.values.replaceSubrange(
                xyRange, with: xy.values[xySubRange]
            )
            
            let zRange = xyRange.upperBound ..< (xyRange.upperBound + z.columns)
            let zSubRange = (subv * z.columns) ..< ((subv * z.columns) + z.columns)
            
            result.values.replaceSubrange(
                zRange, with: z.values[zSubRange]
            )
        }
        
        return result
    }
    
}
