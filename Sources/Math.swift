//
//  Math.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2021/1/11.
//  Copyright © 2021 黄文飞. All rights reserved.
//

import Foundation

import Accelerate

public struct Math {
    
    public static func sign(_ values: [Double]) -> [Double] {
        var result = [Double](repeating: 0, count: values.count)
        for (idx, value) in values.enumerated() {
            result[idx] = (value == 0 ? 0 : (value < 0 ? -1 : 1))
        }
        return result
    }
    
    public static func sum(_ values: [Double]) -> Double {
        cblas_dasum(.init(values.count), values, 1)
    }
    
    public static func pow(values: inout [Double], exponent: Double) -> [Double] {
        var values = values
        var count: Int32 = .init(values.count)
        var pows = [Double](repeating: 0, count: values.count)
        var exponents = [Double](repeating: exponent, count: values.count)
        /// output, exponent, input, count
        vvpow(&pows, &exponents, &values, &count)
        return pows
    }
    
    public static func sub(_ vec1: inout [Double], _ vec2: inout [Double]) -> [Double] {
        var subVecs = [Double](repeating: 0, count: vec1.count)
        /// c[i] = a[i] - b[i]
        vDSP_vsubD(
            &vec2, vDSP_Stride(1),
            &vec1, vDSP_Stride(1),
            &subVecs, vDSP_Stride(1),
            vDSP_Length(subVecs.count)
        )
        return subVecs
    }
    
    public static func mul(_ vec1: inout [Double], _ vec2: inout [Double]) -> [Double] {
        var result = [Double](repeating: 0, count: vec1.count)
        /// c[i] = a[i] * b[i]
        vDSP_vmulD(
            &vec1, vDSP_Stride(1),
            &vec2, vDSP_Stride(1),
            &result, vDSP_Stride(1),
            vDSP_Length(vec1.count)
        )
        return result
    }
    
    public static func mul(_ vec1: inout [Double], _ scalar: Double) -> [Double] {
        var scalar = scalar
        var result = [Double](repeating: 0, count: vec1.count)
        /// c[i] = a[i] * b
        vDSP_vsmulD(
            &vec1, vDSP_Stride(1),
            &scalar,
            &result, vDSP_Stride(1),
            vDSP_Length(result.count)
        )
        return result
    }
    
    public static func div(_ vec1: inout [Double], _ vec2: inout [Double]) -> [Double] {
        var result = [Double](repeating: 0, count: vec1.count)
        /// c[i] = a[i] / b[i]
        vDSP_vdivD(
            &vec2, vDSP_Stride(1),
            &vec1, vDSP_Stride(1),
            &result, vDSP_Stride(1),
            vDSP_Length(vec1.count)
        )
        return result
    }
    
    public static func div(_ vec1: inout [Double], _ scalar: Double) -> [Double] {
        var scalar = scalar
        var result = [Double](repeating: 0, count: vec1.count)
        /// c[i] = a[i] / b
        vDSP_vsdivD(
            &vec1, vDSP_Stride(1),
            &scalar,
            &result, vDSP_Stride(1),
            vDSP_Length(vec1.count)
        )
        return result
    }
    
}

extension Math {
    
    public typealias Element = ColorElement.Element
    
    internal typealias Vector = ColorElement.Vector
    internal typealias Matrix = ColorElement.Matrix
    
    internal static func mul(mat1: Matrix, vector: Vector) -> Vector {
        
        var a = mat1.values
        let m: Int32 = .init(mat1.rows)
        let n: Int32 = .init(mat1.columns)
        let lda = n
        
        let alpha: Double = 1
        let beta: Double = 0
        
        var x = vector.values
        let incx: Int32 = 1
        
        var y: [Element] = .init(repeating: 0, count: x.count)
        let incy: Int32 = 1
        
        /**
         DGEMV  performs one of the matrix-vector operations

            `y := alpha*A*x + beta*y`,   or   `y := alpha*A**T*x + beta*y`,

         where alpha and beta are scalars, x and y are vectors and A is an
         m by n matrix.
         */
        cblas_dgemv(
            CblasRowMajor, CblasNoTrans,
            m, n,
            alpha, &a, lda,
            &x, incx,
            beta, &y, incy
        )
        
        return (y, y.count)
        
    }
    
    internal static func mul(mat1: Matrix, mat2: Matrix) -> Matrix {
        
        /// - Tag: A
        var transValues = mat1.values
        let transM: Int32 = .init(mat1.rows)
        let transN: Int32 = .init(mat1.columns)
        let lda: Int32 = transN

        /// - Tag: B
        var values = mat2.values
//        let valueM: Int32 = .init(mat2.rows)
        let valueN: Int32 = .init(mat2.columns)
        let ldb: Int32 = valueN

        /// - Tag: C
        /// `resultMatrix = transMatrix * valueMatrix` -> `3 X 3 * 3 X 1`
        var resultMatrix = [Element](repeating: 0, count: .init(transM * valueN))
        let ldc = valueN

        /// `C := alpha * op( A ) * op( B ) + beta * C`
        let alpha: Double = 1.0
        let beta: Double = 0.0

        /// row-major ??? https://blog.csdn.net/u013608424/article/details/80118311
        cblas_dgemm(
            CblasRowMajor,
            CblasNoTrans, CblasNoTrans,
            transM, valueN, transN /* Or valueM */,
            alpha, &transValues, lda,
            &values, ldb,
            beta, &resultMatrix, ldc
        )
        
        return (resultMatrix, .init(transM), .init(valueN))
        
    }
    
    internal static func inv(_ mat: Matrix) -> Matrix? {
        
        /// - Tag: LU factorization
        var a = mat.values
        var m: __CLPK_integer = .init(mat.rows)
        var n: __CLPK_integer = .init(mat.columns)
        var lda: __CLPK_integer = n
        
        var ipiv: [__CLPK_integer] = .init(repeating: 0, count: .init(m * n))
        
        var info: __CLPK_integer = 0
        
        /**
         DGETRF computes an LU factorization of a general M-by-N matrix A
         using partial pivoting with row interchanges.

         The factorization has the form
            `A = P * L * U`
         where P is a permutation matrix, L is lower triangular with unit
         diagonal elements (lower trapezoidal if `m > n`), and U is upper
         triangular (upper trapezoidal if `m < n`).

         This is the right-looking Level 3 BLAS version of the algorithm.
         */
        dgetrf_(
            &m, &n,
            &a, &lda,
            &ipiv,
            &info
        )
        
        guard info == 0 else {
            #if DEBUG
            fatalError("Can not computes an LU factorization of a general M-by-N matrix.")
            #else
            return nil
            #endif
        }
        
        /// - Tag: Computes The Inverse
        #if false
        var lwork: __CLPK_integer = n * n
        #else
        var ispec: __CLPK_integer = 1
        var name: [Int8] = .init("dgetri".utf8CString)
        var opts: [Int8] = .init()
        var unused1: __CLPK_integer = -1
        var unused2 = unused1
        var unused3 = unused1
        let lworkNB = ilaenv_(
            &ispec,
            &name,
            &opts,
            &n, &unused1, &unused2, &unused3
        )
        var lwork = n * lworkNB
        #endif
        var work: [__CLPK_doublereal] = .init(repeating: 0, count: .init(lwork))
        
        /**
         DGETRI computes the inverse of a matrix using the LU factorization
         computed by DGETRF.

         This method inverts U and then computes inv(A) by solving the system
         inv(A)*L = inv(U) for inv(A).
         */
        dgetri_(
            &n,
            &a, &lda,
            &ipiv,
            &work, &lwork,
            &info
        )
        
        guard info == 0 else {
            #if DEBUG
            fatalError("Can not computes the inverse of a matrix.")
            #else
            return nil
            #endif
        }
        
        return (a, .init(m), .init(n))
        
    }
    
    internal static func transpose(_ mat: Matrix) -> Matrix {
        var source = mat.values
        var result = [Element](repeating: 0, count: source.count)
        vDSP_mtransD(
            &source, vDSP_Stride(1),
            &result, vDSP_Stride(1),
            vDSP_Length(mat.rows), vDSP_Length(mat.columns)
        )
        return (result, mat.columns, mat.rows)
    }

    internal static func pinv(_ mat: Matrix) -> Matrix? {
        /// Final transformation matrix
        /// pinv( Compute the (Moore-Penrose) pseudo-inverse of a matrix. ):
        /// https://www.johndcook.com/blog/2018/05/05/svd/
        /// https://www.johndcook.com/blog/tag/linear-algebra/
        /// https://developer.apple.com/documentation/accelerate/veclib
        /// https://www.netlib.org/lapack/lapacke.html
        /// https://www.netlib.org/clapack/what/xxx.c
        /// https://www.netlib.org/lapack/explore-html/d4/d84/group__complex_g_esing_ga0ed22d535ec7d84e8bf4f2f885df8c5c.html
        /// https://github.com/openimaj/openimaj/blob/master/core/core-math/src/main/java/org/openimaj/math/matrix/PseudoInverse.java
        
        /// - Tag: Calculate SVD
        /**
         DGESVD computes the singular value decomposition (SVD) of a real
         M-by-N matrix A, optionally computing the left and/or right singular
         vectors. The SVD is written

              `A = U * SIGMA * transpose(V)`

         where SIGMA is an M-by-N matrix which is zero except for its
         min(m,n) diagonal elements, U is an M-by-M orthogonal matrix, and
         V is an N-by-N orthogonal matrix.  The diagonal elements of SIGMA
         are the singular values of A; they are real and non-negative, and
         are returned in descending order.  The first min(m,n) columns of
         U and V are the left and right singular vectors of A.

         Note that the routine returns `V**T`, not V.
         */
        
        let columnMajor = transpose(mat)
        
        var jobu: [Int8] = .init("A".utf8CString)
        var jobvt = jobu
        
        var a = columnMajor.values
        var m: __CLPK_integer = .init(columnMajor.rows)
        var n: __CLPK_integer = .init(columnMajor.columns)
        var lda = n
        
        let um = m
        let un = m
        var u: [__CLPK_doublereal] = .init(repeating: 0, count: .init(um * un))
        var ldu = un
        
        let sm = m
        let sn = n
        var s: [__CLPK_doublereal] = .init(repeating: 0, count: .init(sm * sn))
        
        let vtm = n
        let vtn = n
        var vt: [__CLPK_doublereal] = .init(repeating: 0, count: .init(vtm * vtn))
        var ldvt = vtn
        
        var lwork: __CLPK_integer = max(1, 3 * min(m, n) + max(m, n), 5 * min(m, n))
        var work: [__CLPK_doublereal] = .init(repeating: 0, count: .init(lwork))
        
        var info: __CLPK_integer = 0
        
        /// cloumn major
        dgesvd_(
            &jobu, &jobvt,
            &m, &n,
            &a, &lda,
            &s,
            &u, &ldu,
            &vt, &ldvt,
            &work, &lwork,
            &info
        )
        
        guard info == 0 else {
            #if DEBUG
            fatalError("Can not calculate matrix svd.")
            #else
            return nil
            #endif
        }
        
        /// row major - transppose -> column major
        /// column major - transppose -> row major
    //    print("u: ", transpose((u, .init(um), .init(un))))
    //    print("s: ", s) // transpose((s, .init(sm), .init(sn))))
    //    print("vt: ", transpose((vt, .init(vtm), .init(vtn))))
        
        /// - Tag: Calculate Pinv
        
        /// calculate sp
        var sp = [Element](repeating: 0, count: s.count)
        for (idx, value) in s.enumerated() {
            guard value > 0 else { continue }
            sp[(idx * .init(sm)) + idx] = 1 / value
        }
        
        /// calculate `v * sp * ut`, mul is row major
        
        let v_sp = mul(
            mat1: (vt, .init(vtm), .init(vtn)),
            mat2: (sp, .init(sn), .init(sm))
        )
        
        let v_sp_ut = mul(
            mat1: v_sp,
            mat2: (u, .init(um), .init(un))
        )
        
        return v_sp_ut
        
    }
    
}
