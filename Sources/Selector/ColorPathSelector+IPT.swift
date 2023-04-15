//
//  ColorPathSelector+IPT.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation
import Accelerate

extension ColorPathSelector {
    public struct IPTSelector {
        
        public typealias Element = ColorPathSelector.Element
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toXYZ.pathId: toXYZ
        ]
        
        public static let toXYZ: PathConverter = .init( .IPT ==> .XYZ ) {
            .init( Self.toXYZ(color: ($0.base as! IPT), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.IPTSelector {
    
    public static func toXYZ(color: IPT, infos: [AnyHashable: Any]?) -> XYZ {
        
        /// - Tag: Inv
        guard let lmsToIptInv = Math.inv(IPT.lmstoIptMatrices) else {
            #if DEBUG
            fatalError("lmsToIpt can not invertible.")
            #else
            return .init()
            #endif
        }

        /// - Tag: lmsToIptInv * iptValues
        let iptValues = color.elements
        
        let lmsValueMat = Math.mul(
            mat1: lmsToIptInv,
            mat2: .init(iptValues, iptValues.count, 1)
        )
        
        var lmsValues = lmsValueMat.values
        
        /// - Tag: Sign Lms
//        var signLmsValues = lmsValues.map { sign($0) }
        var signLmsValues = Math.sign(lmsValues)
        
        /// - Tag: ABS Lms
        let lmsCount = lmsValues.count
        var lmsCountInt32: Int32 = .init(lmsCount)
        var absLmsValues = [Element](repeating: 0, count: lmsCount)
        vvfabs(&absLmsValues, &lmsValues, &lmsCountInt32)
        
        var lmsPrimeTemp = [Element](repeating: 0, count: lmsCount)
        vDSP_vmulD(
            &signLmsValues, vDSP_Stride(1),
            &absLmsValues, vDSP_Stride(1),
            &lmsPrimeTemp, vDSP_Stride(1),
            vDSP_Length(lmsPrimeTemp.count)
        )
        
        var exponents = [Element](repeating: 1.0 / 0.43, count: lmsCount)
        
        var lmsPrime = [Element](repeating: 0, count: lmsCount)
        vvpow(&lmsPrime, &exponents, &lmsPrimeTemp, &lmsCountInt32)

        /// - Tag: Inv
        guard let xyzToLmsInv = Math.inv(IPT.xyzToLmsMatrices) else {
            #if DEBUG
            fatalError("xyzToLms can not invertible.")
            #else
            return .init()
            #endif
        }
        
        let xyzValues = Math.mul(
            mat1: xyzToLmsInv,
            mat2: .init(lmsPrime, lmsPrime.count, 1)
        ).values
        
        return .init(
            x: xyzValues[0], y: xyzValues[1], z: xyzValues[2],
            illuminant: .two(.d65)
        )
        
    }
    
}
