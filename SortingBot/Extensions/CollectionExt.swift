//
//  CollectionExt.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 08.12.2022.
//

import Foundation

extension Collection {
    @inlinable func isValid(position: Self.Index) -> Bool {
        return (startIndex..<endIndex) ~= position
    }
    
    @inlinable func isValid(bounds: Range<Self.Index>) -> Bool {
        return (startIndex..<endIndex) ~= bounds.upperBound
    }
    
    @inlinable subscript(safe position: Self.Index) -> Self.Element? {
        guard isValid(position: position) else { return nil }
        return self[position]
    }
    
    @inlinable subscript(safe bounds: Range<Self.Index>) -> Self.SubSequence? {
        guard isValid(bounds: bounds) else { return nil }
        return self[bounds]
    }
}

extension MutableCollection {
    @inlinable subscript(safe position: Self.Index) -> Self.Element? {
        get {
            guard isValid(position: position) else { return nil }
            return self[position]
        }
        set {
            guard isValid(position: position), let newValue = newValue else { return }
            self[position] = newValue
        }
    }
    @inlinable subscript(safe bounds: Range<Self.Index>) -> Self.SubSequence? {
        get {
            guard isValid(bounds: bounds) else { return nil }
            return self[bounds]
        }
        set {
            guard isValid(bounds: bounds), let newValue = newValue else { return }
            self[bounds] = newValue
        }
    }
}
