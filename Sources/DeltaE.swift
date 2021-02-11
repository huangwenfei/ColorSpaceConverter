//
//  DeltaE.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/12/24.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

import Accelerate

/// For Lab Color
public struct DeltaE: ColorElement {
    
    public static let e: Double = 216.0 / 24389.0
    public static let k: Double = 24389.0 / 27.0
    
}

extension DeltaE {
    
    public static func cie1976(_ lhs: Lab, _ rhs: Lab) -> Double {
        
        /// - Tag: Calculates the Delta E (CIE1976) between `lab_color_vector` and all colors in `lab_color_matrix`.
        
        var vec1 = lhs.elements
        var vec2 = rhs.elements
        
        /// - Tag: lhs - rhs
        var subVecs = [Element](repeating: 0, count: vec1.count)
        /// c[i] = a[i] - b[i]
        vDSP_vsubD(
            &vec2, vDSP_Stride(1),
            &vec1, vDSP_Stride(1),
            &subVecs, vDSP_Stride(1),
            vDSP_Length(subVecs.count)
        )
        
        /// - Tag: pow(lhs - rhs)
        var count: Int32 = .init(subVecs.count)
        var pows = [Element](repeating: 0, count: subVecs.count)
        var exponents = [Element](repeating: 2, count: subVecs.count)
        /// output, exponent, input, count
        vvpow(&pows, &exponents, &subVecs, &count)
        
        /// - Tag: sum(pows)
        let sum = cblas_dasum(count, pows, 1)
        
        /// - Tag: sqrt(sum)
        return sqrt(sum)
    }
    
    public static func cie1994(_ lhs: Lab, _ rhs: Lab, kl: K = .default, kc: K = .default, kh: K = .default, k1: K1 = .graphicArts, k2: K2 = .graphicArts) -> Double {

        var lhsElements = lhs.elements
        var rhsElements = rhs.elements
        
        let c1: Double = {
            var willPow: Array = .init(lhsElements.dropFirst())
            let pows = Math.pow(values: &willPow, exponent: 2)
            return sqrt(Math.sum(pows))
        }()
        
        let c2: Double = {
            var willPow: Array = .init(rhsElements.dropFirst())
            let pows = Math.pow(values: &willPow, exponent: 2)
            return sqrt(Math.sum(pows))
        }()
        
        var deltaLab = Math.sub(&lhsElements, &rhsElements)
    
        let deltaL = deltaLab[0]
        let deltaC = c1 - c2
        deltaLab[0] = deltaC
        
        var pows = Math.pow(values: &deltaLab, exponent: 2)
        var sign: [Double] = [-1, 1, 1]
        let deltaHSq = Math.sum(Math.mul(&pows, &sign))

        let deltaH = sqrt(deltaHSq)

        let sl: Double = 1
        let sc = 1 + k1.rawValue * c1
        let sh = 1 + k2.rawValue * c1

        var lch = [deltaL, deltaC, deltaH]
        var params = [kl.rawValue * sl, kc.rawValue * sc, kh.rawValue * sh]

        var lchDiv = Math.div(&lch, &params)
        let lchPows = Math.pow(values: &lchDiv, exponent: 2)
        
        return sqrt(Math.sum(lchPows))
    }
        
    public static func cmc(_ lhs: Lab, _ rhs: Lab, cmc: CMC = .acceptability) -> Double {
        
        /// Calculates the Delta E (CIE1994) of two colors.

        var lhsElements = lhs.elements
        var rhsElements = rhs.elements
        
        let L = lhs.l
        let a = lhs.a
        let b = lhs.b

        let c1: Double = {
            var willPow: Array = .init(lhsElements.dropFirst())
            let pows = Math.pow(values: &willPow, exponent: 2)
            return sqrt(Math.sum(pows))
        }()
        
        let c2: Double = {
            var willPow: Array = .init(rhsElements.dropFirst())
            let pows = Math.pow(values: &willPow, exponent: 2)
            return sqrt(Math.sum(pows))
        }()

        var deltaLab = Math.sub(&lhsElements, &rhsElements)
    
        let deltaL = deltaLab[0]
        let deltaC = c1 - c2
        deltaLab[0] = deltaC

        var h1 = degrees(atan2(b, a))
        if h1 < 0 { h1 += 360 }
    
        let f = sqrt(pow(c1, 4) / (pow(c1, 4) + 1900.0))

        let t: Double
        if 164 <= h1 && h1 <= 345 {
            t = 0.56 + abs(0.2 * cos(radians(h1 + 168)))
        } else {
            t = 0.36 + abs(0.4 * cos(radians(h1 + 35)))
        }

        let sl: Double
        if L < 16 {
            sl = 0.511
        } else {
            sl = (0.040975 * L) / (1 + 0.01765 * L)
        }

        let sc = ((0.0638 * c1) / (1 + 0.0131 * c1)) + 0.638
        let sh = sc * (f * t + 1 - f)

        var pows = Math.pow(values: &deltaLab, exponent: 2)
        var sign: [Double] = [-1, 1, 1]
        let deltaHSq = Math.sum(Math.mul(&pows, &sign))

        let deltaH = sqrt(deltaHSq)
        
        var lch = [deltaL, deltaC, deltaH]
        var params = [cmc.pl * sl, cmc.pc * sc, sh]

        var lchDiv = Math.div(&lch, &params)
        let lchPows = Math.pow(values: &lchDiv, exponent: 2)
        
        return sqrt(Math.sum(lchPows))
    
    }
    
    public static func cie2000(_ lhs: Lab, _ rhs: Lab, kl: K = .default, kc: K = .default, kh: K = .default) -> Double {
       
        /// Calculates the Delta E (CIE2000) of two colors.
       
        let lhsElements = lhs.elements
        let rhsElements = rhs.elements
        
        let L = lhs.l
        let a = lhs.a
        let b = lhs.b

        let avgLp = (L + rhs.l) / 2.0

        let c1: Double = {
            var willPow: Array = .init(lhsElements.dropFirst())
            let pows = Math.pow(values: &willPow, exponent: 2)
            return sqrt(Math.sum(pows))
        }()
        
        let c2: Double = {
            var willPow: Array = .init(rhsElements.dropFirst())
            let pows = Math.pow(values: &willPow, exponent: 2)
            return sqrt(Math.sum(pows))
        }()

        let avgC1C2 = (c1 + c2) / 2.0

        let G = 0.5 * (
            1 - sqrt(pow(avgC1C2, 7.0) / (pow(avgC1C2, 7.0) + pow(25.0, 7.0)))
        )

        let a1p = (1.0 + G) * a
        let a2p = (1.0 + G) * rhs.a

        let c1p = sqrt(pow(a1p, 2) + pow(b, 2))
        let c2p = sqrt(pow(a2p, 2) + pow(rhs.b, 2))

        let avgC1pC2p = (c1p + c2p) / 2.0

        var h1p = degrees(atan2(b, a1p))
        if h1p < 0 { h1p = 360 }

        var h2p = degrees(atan2(rhs.b, a2p))
        if h2p < 0 { h2p = 360 }

        let absH1pH2p: Double = abs(h1p - h2p) > 180 ? 360 : 0
        let avgHp = (absH1pH2p + h1p + h2p) / 2.0

        let T = (
            1
            - 0.17 * cos(radians(avgHp - 30))
            + 0.24 * cos(radians(2 * avgHp))
            + 0.32 * cos(radians(3 * avgHp + 6))
            - 0.2 * cos(radians(4 * avgHp - 63))
        )

        let diffH2pH1p = h2p - h1p
        var deltaHp = diffH2pH1p + ((abs(diffH2pH1p) > 180) ? 360 : 0)
        deltaHp -= ((h2p > h1p) ? 720 : 0)

        let deltaLp = rhs.l - L
        let deltaCp = c2p - c1p
        deltaHp = 2 * sqrt(c2p * c1p) * sin(radians(deltaHp) / 2.0)

        let sl = 1 + (
            (0.015 * pow(avgLp - 50, 2))
            / sqrt(20 + pow(avgLp - 50, 2.0))
        )
        let sc = 1 + 0.045 * avgC1pC2p
        let sh = 1 + 0.015 * avgC1pC2p * T

        let deltaRo = 30 * exp(-(pow(((avgHp - 275) / 25), 2.0)))
        let rc = sqrt(
            (pow(avgC1pC2p, 7.0))
            / (pow(avgC1pC2p, 7.0) + pow(25.0, 7.0))
        )
        let rt = -2 * rc * sin(2 * radians(deltaRo))

        return sqrt(
            pow(deltaLp / (sl * kl.rawValue), 2)
                + pow(deltaCp / (sc * kc.rawValue), 2)
                + pow(deltaHp / (sh * kh.rawValue), 2)
                + rt * (deltaCp / (sc * kc.rawValue)) * (deltaHp / (sh * kh.rawValue))
        )

    }
        
}

extension DeltaE {
    
    public enum K: Double {
        case `default` = 1
        case textiles = 2
    }
    
    public enum K1: Double {
        case graphicArts = 0.045
        case textiles = 0.048
    }
    
    public enum K2: Double {
        case graphicArts = 0.015
        case textiles = 0.014
    }
    
    public enum CMC {
        case acceptability
        case perceptability
        
        public var pl: Double {
            switch self {
            case .acceptability: return 2
            case .perceptability: return 1
            }
        }
        
        public var pc: Double {
            switch self {
            case .acceptability: return 1
            case .perceptability: return 1
            }
        }
    }
    
}
