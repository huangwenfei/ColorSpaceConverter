//
//  Density.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/12/24.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

/// For Spectral Color
public struct Density {
    
    public static func ansiDensity(color: Spectral, standard: DensityStandard = .none) -> Double {
        
//        Calculates density for the given Spectral using the spectral weighting
//        function provided. For example, .ansiStatusTRed. These may be found in `DensityStandards`.
//
//        @param Spectral color: The Spectral struct to calculate density for.
//        @param array standard: Swift array of filter of choice from `DensityStandards`.
//        @rtype: Double
//        @returns: The density value for the given color and density standard.
        
        /// - Tag: Load the spec_XXXnm attributes into a Numpy array.
        var sample = color.elements
        
        /// - Tag: Matrix multiplication
        var standardValues = standard.values
        let intermediate = Math.mul(&sample, &standardValues)

        /// - Tag: Sum the products.
        let numerator = Math.sum(intermediate)
        
        /// - Tag: This is the denominator in the density equation.
        let sumOfStandardWavelengths = Math.sum(standardValues)

        /// - Tag: This is the top level of the density formula.

        return -1.0 * log10(numerator / sumOfStandardWavelengths)
    }
    
    public static func autoDensity(color: Spectral) -> Double {
        
//        Given a SpectralColor, automatically choose the correct ANSI T filter.
//        Returns a tuple with a string representation of the filter the
//        calculated density.
//
//        @param Spectral color: The Spectral struct to calculate density for.
//        @rtype: Double
//        @returns: The density value, with the filter selected automatically.
       
        let blueDensity  = ansiDensity(color: color, standard: .ansiStatusTBlue)
        let greenDensity = ansiDensity(color: color, standard: .ansiStatusTGreen)
        let redDensity   = ansiDensity(color: color, standard: .ansiStatusTRed)

        let minDensity = min(blueDensity, greenDensity, redDensity)
        let maxDensity = max(blueDensity, greenDensity, redDensity)
        let densityRange = maxDensity - minDensity

        /// - Tag: See comments in DensityStandards for visualDensityThresh to  understand what this is doing.
        if densityRange <= DensityStandard.visualDensityThresh {
            return ansiDensity(color: color, standard: .isoVisual)
        } else if blueDensity > greenDensity && blueDensity > redDensity {
            return blueDensity
        } else if greenDensity > blueDensity && greenDensity > redDensity {
            return greenDensity
        } else {
            return redDensity
        }
    }
    
}
