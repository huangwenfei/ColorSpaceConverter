//
//  DensityStandard.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2021/1/11.
//  Copyright © 2021 黄文飞. All rights reserved.
//

import Foundation

public struct DensityStandard {
    
    public internal(set) var values = [Double]()
    
    public init(values: Double...) {
        self.values = values
    }
    
    public var isNone: Bool {
        return values.count == 0
    }
    
}

extension DensityStandard {
    
    public static let visualDensityThresh = 0.08
    
    public static let none = DensityStandard()
    
}

extension DensityStandard {
    
    public static let ansiStatusARed: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.37,
        43.45,
        100.00,
        74.30,
        40.18,
        19.32,
        7.94,
        3.56,
        1.46,
        0.60,
        0.24,
        0.09,
        0.04,
        0.01,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let ansiStatusAGreen: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.04,
        6.64,
        60.53,
        100.00,
        80.54,
        44.06,
        16.63,
        4.06,
        0.58,
        0.04,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let ansiStatusABlue: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        4.00,
        65.92,
        100.00,
        81.66,
        41.69,
        10.96,
        0.79,
        0.04,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
}

extension DensityStandard {
    
    public static let ansiStatusERed: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.01,
        0.06,
        0.45,
        29.99,
        100.00,
        84.92,
        54.95,
        25.00,
        10.00,
        5.00,
        1.50,
        0.50,
        0.30,
        0.15,
        0.05,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let ansiStatusEGreen: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.01,
        1.00,
        5.00,
        27.99,
        68.08,
        92.04,
        100.00,
        87.90,
        66.07,
        41.98,
        21.98,
        8.99,
        2.50,
        0.70,
        0.09,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let ansiStatusEBlue: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.01,
        0.27,
        2.70,
        13.00,
        29.99,
        59.98,
        82.04,
        100.00,
        90.99,
        76.03,
        46.99,
        17.99,
        6.00,
        0.80,
        0.05,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
}

extension DensityStandard {
    
    public static let ansiStatusMRed: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.13,
        30.13,
        100.00,
        79.25,
        37.84,
        17.86,
        7.50,
        3.10,
        1.26,
        0.49,
        0.19,
        0.07,
        0.03,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let ansiStatusMGreen: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.01,
        0.16,
        1.43,
        6.37,
        18.71,
        42.27,
        74.47,
        100.00,
        98.86,
        65.77,
        28.71,
        8.22,
        1.49,
        0.17,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let ansiStatusMBlue: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.13,
        12.91,
        42.85,
        74.30,
        100.00,
        90.16,
        55.34,
        22.03,
        5.53,
        0.98,
        0.07,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
}

extension DensityStandard {
    
    public static let ansiStatusTRed: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.06,
        0.45,
        29.99,
        100.00,
        84.92,
        54.95,
        25.00,
        10.00,
        5.00,
        1.50,
        0.50,
        0.30,
        0.15,
        0.05,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let ansiStatusTGreen: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        1.00,
        5.00,
        27.99,
        68.08,
        92.04,
        100.00,
        87.90,
        66.07,
        41.98,
        21.98,
        8.99,
        2.50,
        0.70,
        0.09,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let ansiStatusTBlue: Self = Self(values:
        0.00,
        0.01,
        0.02,
        0.10,
        0.30,
        1.50,
        6.00,
        16.98,
        39.99,
        59.98,
        82.04,
        93.97,
        100.00,
        97.05,
        84.92,
        65.01,
        39.99,
        17.99,
        5.00,
        0.20,
        0.04,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
}

extension DensityStandard {
    
    public static let type1: Self = Self(values:
        0.00,
        0.00,
        0.01,
        0.04,
        0.72,
        28.84,
        100.00,
        28.84,
        0.72,
        0.04,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
    public static let type2: Self = Self(values:
        0.01,
        0.51,
        19.05,
        38.28,
        57.54,
        70.96,
        82.41,
        90.36,
        97.27,
        100.00,
        97.72,
        89.33,
        73.11,
        55.34,
        38.19,
        22.44,
        9.84,
        2.52,
        0.64,
        0.16,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
}

extension DensityStandard {
    
    public static let isoVisual: Self = Self(values:
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.01,
        0.02,
        0.08,
        0.28,
        0.65,
        1.23,
        2.22,
        3.82,
        6.58,
        10.99,
        18.88,
        32.58,
        50.35,
        66.83,
        80.35,
        90.57,
        97.50,
        100.00,
        97.50,
        90.36,
        79.80,
        67.14,
        53.83,
        39.17,
        27.10,
        17.30,
        10.30,
        5.61,
        3.09,
        1.54,
        0.80,
        0.42,
        0.22,
        0.11,
        0.05,
        0.03,
        0.01,
        0.01,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    )
    
}

