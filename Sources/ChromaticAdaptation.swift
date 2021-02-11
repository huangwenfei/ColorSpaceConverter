//
//  ChromaticAdaptation.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/12/24.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

import Accelerate

/// For XYZ Color
public struct ChromaticAdaptation {
    
    /**
     Applies a chromatic adaptation matrix to convert XYZ values between
     illuminants. It is important to recognize that color transformation results
     in color errors, determined by how far the original illuminant is from the
     target illuminant. For example, D65 to A could result in very high maximum
     deviance.

     An informative article with estimate average Delta E values for each
     illuminant conversion may be found at:

     http://brucelindbloom.com/ChromAdaptEval.html
     */
    public static func adaptation(forXyz xyz: inout XYZ, adaptation: ChromaticAdaptation.Adaptation = .bradford, illuminant: Illuminant) {
        
        guard let transformMatrix = adaptation.calculate(
            withOldIlluminant: xyz.illuminant, newIlluminant: illuminant
        ) else {
            #if DEBUG
            fatalError("Can not calculate transformMatrix.")
            #else
            xyz = .init()
            return
            #endif
        }

        /// Stuff the XYZ values into a NumPy matrix for conversion.
        let elements = xyz.elements
        
        /// Perform the adaptation via matrix multiplication.
        let resultMat = Math.mul(
            mat1: transformMatrix,
            mat2: (elements, elements.count, 1)
        ).values
        
        xyz = .init(array: resultMat)
        xyz.illuminant = illuminant
        
    }
    
    public static func adaptation(x: inout XYZ.Element, y: inout XYZ.Element, z: inout XYZ.Element, xyzIlluminant: Illuminant, adaptation: ChromaticAdaptation.Adaptation = .bradford, illuminant: Illuminant) {
        
        guard let transformMatrix = adaptation.calculate(
            withOldIlluminant: xyzIlluminant, newIlluminant: illuminant
        ) else {
            #if DEBUG
            fatalError("Can not calculate transformMatrix.")
            #else
            x = 0 ; y = 0; z = 0
            return
            #endif
        }

        /// Stuff the XYZ values into a NumPy matrix for conversion.
        let elements = [x, y, z]
        
        /// Perform the adaptation via matrix multiplication.
        let resultMat = Math.mul(
            mat1: transformMatrix,
            mat2: (elements, elements.count, 1)
        ).values
        
        x = resultMat[0]
        y = resultMat[1]
        z = resultMat[2]
        
    }
    
}

extension ChromaticAdaptation {
    
    public struct Adaptation {
        
        public internal(set) var values: [XYZ.Element] = []
        public let rows: Int = 3
        public let columns: Int = 3
        
        private init(values: [XYZ.Element]) {
            self.values = values
        }
        
        private init(arrayIter values: XYZ.Element...) {
            self.values = values
        }
        
        public static let xyzScaling: Self = .init(arrayIter:
            1.00000, 0.00000, 0.00000,
            0.00000, 1.00000, 0.00000,
            0.00000, 0.00000, 1.00000
        )
        
        public static let bradford: Self = .init(arrayIter:
            0.8951, 0.2664, -0.1614,
            -0.7502, 1.7135, 0.0367,
            0.0389, -0.0685, 1.0296
        )
        
        public static let vonKries: Self = .init(arrayIter:
            0.40024, 0.70760, -0.08081,
            -0.22630, 1.16532, 0.04570,
            0.00000, 0.00000, 0.91822
        )
        
        ///
        /// Calculate the correct transformation matrix based on origin and target
        /// illuminants. The observer angle must be the same between illuminants.
        ///
        /// See colormath.color_constants.ADAPTATION_MATRICES for a list of possible
        /// adaptations.
        ///
        /// Detailed conversion documentation is available at:
        /// http://brucelindbloom.com/Eqn_ChromAdapt.html
        ///
        public func calculate(withOldIlluminant oldIlluminant: Illuminant, newIlluminant: Illuminant) -> ColorElement.Matrix? {
            
            /// Get the appropriate transformation matrix, [MsubA].
            let mSharp = values

            /// In case the white-points are still input as strings
            /// Get white-points for illuminant
            let wpSrc = oldIlluminant.lamp.xyz.toArray
            let wpDst = newIlluminant.lamp.xyz.toArray
            let wpRows = wpSrc.count
            let wpColumns = 1

            /// Sharpened cone responses ~ rho gamma beta ~ sharpened r g b
            /// row-major ??? https://blog.csdn.net/u013608424/article/details/80118311
            /// A * X
            /// Y ← αAX + βY
            var rgbSrc = Math.mul(
                mat1: (mSharp, rows, columns),
                mat2: (wpSrc, wpRows, wpColumns)
            )
            
            var rgbDst = Math.mul(
                mat1: (mSharp, rows, columns),
                mat2: (wpDst, wpRows, wpColumns)
            )

            /// Ratio of whitepoint sharpened responses
            let count = rgbSrc.values.count
            var mRatDiagSrc: [XYZ.Element] = .init(repeating: 0, count: count)
            rgbSrc.values.withUnsafeMutableBufferPointer { src in
                rgbDst.values.withUnsafeMutableBufferPointer { dst in
                    vDSP_vdivD(
                        src.baseAddress!, vDSP_Stride(1),
                        dst.baseAddress!, vDSP_Stride(1),
                        &mRatDiagSrc, vDSP_Stride(1),
                        vDSP_Length(count)
                    )
                }
            }
            
            /// diagonal
            var mRatDiag: [XYZ.Element] = .init(repeating: 0, count: count * count)
            for (idx, value) in mRatDiagSrc.enumerated() {
                mRatDiag[(idx * wpRows) + idx] = value
            }
            
            guard let pinvResult = Math.pinv(
                (mSharp, rows, columns)
            ) else {
                #if DEBUG
                fatalError("Can not calculate sharp pinv.")
                #else
                return nil
                #endif
            }
            
            let pinvRat = Math.mul(
                mat1: pinvResult,
                mat2: (mRatDiag, count, count)
            )
            
            let mXfm = Math.mul(
                mat1: pinvRat,
                mat2: (mSharp, rows, columns)
            )
            
            return mXfm
            
        }
        
    }
    
}
