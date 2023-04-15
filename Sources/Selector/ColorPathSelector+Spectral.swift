//
//  ColorPathSelector+Spectral.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation
import Accelerate

extension ColorPathSelector {
    public struct SpectralSelector {
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toXYZ.pathId: toXYZ
        ]
        
        public static let toXYZ: PathConverter = .init( .Spectral ==> .XYZ ) {
            let color = $0.base as! Spectral
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            let xyz = Self.toXYZ(
                color: color,
                illuminant: illuminant.spectral ?? .default,
                infos: infos
            )
            return .init(xyz)
        }
        
    }
}

extension ColorPathSelector.SpectralSelector {
 
    /// need Illuminant
    public static func toXYZ(color: Spectral, illuminant: SpectralIlluminant? = nil, infos: [AnyHashable: Any]?) -> XYZ {

        guard color.illuminant.canToNormal else {
            #if DEBUG
            fatalError("Color \(color.illuminant) can not convert to normal illuminant.")
            #else
            return .init()
            #endif
        }
        
        /// - Tag: If the user provides an illuminant_override numpy array, use it.
        var referenceIllum: SpectralIlluminant
        if let illuminant = illuminant {
            
            guard illuminant.canToNormal else {
                #if DEBUG
                fatalError("Color \(illuminant) can not used to xyz color.")
                #else
                return .init()
                #endif
            }
            
            referenceIllum = illuminant
            
        } else {
            /// - Tag: Otherwise, look up the illuminant from known standards based on the value of 'illuminant' pulled from the SpectralColor object.
            referenceIllum = color.illuminant
        }
        
        /// - Tag: Get the spectral distribution of the selected standard observer.
        var stdObserverXyz = color.illuminant.angle.values
        
        /// - Tag: This is a NumPy array containing the spectral distribution of the color.
        var sample = color.elements

        /// - Tag: The denominator is constant throughout the entire calculation for X, Y, and Z coordinates. Calculate it once and re-use.
        let count = stdObserverXyz.y.count
        var denom = [Spectral.Element](repeating: 0, count: count)
        stdObserverXyz.y.withUnsafeMutableBufferPointer { angle in
            referenceIllum.lamp.values.withUnsafeMutableBufferPointer { lamp in
                vDSP_vmulD(
                    angle.baseAddress!, vDSP_Stride(1),
                    lamp.baseAddress!, vDSP_Stride(1),
                    &denom, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }

        /// - Tag: This is also a common element in the calculation whereby the sample
        /// - Tag: NumPy array is multiplied by the reference illuminant's power distribution
        /// - Tag: (which is also a NumPy array).
        var sampleByRefIllum = [Spectral.Element](repeating: 0, count: count)
        sample.withUnsafeMutableBufferPointer { color in
            referenceIllum.lamp.values.withUnsafeMutableBufferPointer { lamp in
                vDSP_vmulD(
                    color.baseAddress!, vDSP_Stride(1),
                    lamp.baseAddress!, vDSP_Stride(1),
                    &sampleByRefIllum, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }

        /// - Tag: Calculate the numerator of the equation to find X.
        var xNumerator = [Spectral.Element](repeating: 0, count: count)
        sampleByRefIllum.withUnsafeMutableBufferPointer { colorLamp in
            stdObserverXyz.x.withUnsafeMutableBufferPointer { angle in
                vDSP_vmulD(
                    colorLamp.baseAddress!, vDSP_Stride(1),
                    angle.baseAddress!, vDSP_Stride(1),
                    &xNumerator, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }
        
        var yNumerator = [Spectral.Element](repeating: 0, count: count)
        sampleByRefIllum.withUnsafeMutableBufferPointer { colorLamp in
            stdObserverXyz.y.withUnsafeMutableBufferPointer { angle in
                vDSP_vmulD(
                    colorLamp.baseAddress!, vDSP_Stride(1),
                    angle.baseAddress!, vDSP_Stride(1),
                    &yNumerator, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }
        
        var zNumerator = [Spectral.Element](repeating: 0, count: count)
        sampleByRefIllum.withUnsafeMutableBufferPointer { colorLamp in
            stdObserverXyz.z.withUnsafeMutableBufferPointer { angle in
                vDSP_vmulD(
                    colorLamp.baseAddress!, vDSP_Stride(1),
                    angle.baseAddress!, vDSP_Stride(1),
                    &zNumerator, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }
        
        let denomSum = cblas_dasum(.init(denom.count), denom, 1)
        let xNumeratorSum = cblas_dasum(.init(xNumerator.count), xNumerator, 1)
        let yNumeratorSum = cblas_dasum(.init(yNumerator.count), yNumerator, 1)
        let zNumeratorSum = cblas_dasum(.init(zNumerator.count), zNumerator, 1)
        
        let x = xNumeratorSum / denomSum
        let y = yNumeratorSum / denomSum
        let z = zNumeratorSum / denomSum

        return .init(
            x: x, y: y, z: z, illuminant: referenceIllum.normal!
        )
        
    }
    
}
