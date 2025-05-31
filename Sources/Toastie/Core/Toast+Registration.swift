//===--- Toast+Registration.swift ---------------------------------===//

import Foundation
import SwiftUI

// MARK: - Toast Registration
public extension Toast {
    typealias Builder = () -> Toast
    
    private static var registeredToasts: [AnyHashable: Builder] = [:]
    private static let registrationQueue = DispatchQueue(label: "com.toastie.registeredToastsQueue")
    
    /// Registers a toast builder for a given ID
    /// 
    /// - Parameters:
    ///  - id: Unique identifier for the toast
    ///  - builder: Closure that returns a `Toast` instance
    static func register(id: some Hashable, _ builder: @escaping Builder) {
        registrationQueue.async(flags: .barrier) {
            registeredToasts[AnyHashable(id)] = builder
        }
    }
    
    /// Unregisters a toast for the given ID
    /// 
    /// - Parameters:
    /// - id: Unique identifier for the toast
    static func unregister(id: some Hashable) {
        registrationQueue.async(flags: .barrier) {
            registeredToasts.removeValue(forKey: AnyHashable(id))
        }
    }
    
    /// Checks if a toast is registered for the given ID
    /// 
    /// - Parameters:
    /// - id: Unique identifier for the toast
    /// - Returns: `true` if the toast is registered, otherwise `false`
    static func isRegistered(id: some Hashable) -> Bool {
        registrationQueue.sync {
            registeredToasts[AnyHashable(id)] != nil
        }
    }
    
    /// Clears all registered toasts.
    static func clearAll() {
        registrationQueue.async(flags: .barrier) {
            registeredToasts.removeAll()
        }
    }
    
    /// Creates a toast from a registered ID.
    ///
    /// - Parameter id: The identifier of the registered toast.
    /// - Returns: The toast if registered, `nil` otherwise.
    static func from(id: some Hashable) -> Toast? {
        registrationQueue.sync {
            registeredToasts[AnyHashable(id)]?()
        }
    }
}
