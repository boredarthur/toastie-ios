//===--- Toast+Registration.swift ---------------------------------===//

import Foundation
import SwiftUI

// MARK: - Toast Registration
public extension Toast {
    typealias Builder = () -> Toast
    
    private static var registeredToasts: [AnyHashable: Builder] = [:]
    
    /// Registers a toast builder for a given ID
    /// 
    /// - Parameters:
    ///  - id: Unique identifier for the toast
    ///  - builder: Closure that returns a `Toast` instance
    static func register(id: some Hashable, _ builder: @escaping Builder) {
        registeredToasts[AnyHashable(id)] = builder
    }
    
    /// Unregisters a toast for the given ID
    /// 
    /// - Parameters:
    /// - id: Unique identifier for the toast
    static func unregister(id: some Hashable) {
        registeredToasts.removeValue(forKey: AnyHashable(id))
    }
    
    /// Checks if a toast is registered for the given ID
    /// 
    /// - Parameters:
    /// - id: Unique identifier for the toast
    /// - Returns: `true` if the toast is registered, otherwise `false`
    static func isRegistered(id: some Hashable) -> Bool {
        registeredToasts[AnyHashable(id)] != nil
    }
    
    /// Clears all registered toasts.
    static func clearAll() {
        registeredToasts.removeAll()
    }
    
    /// Creates a toast from a registered ID.
    ///
    /// - Parameter id: The identifier of the registered toast.
    /// - Returns: The toast if registered, `nil` otherwise.
    static func from(id: some Hashable) -> Toast? {
        registeredToasts[AnyHashable(id)]?()
    }
}
