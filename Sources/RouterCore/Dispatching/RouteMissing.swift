import func Foundation.NSLocalizedString

/// An error that occurs when no `Route` is registered for a `Routeable`.
///
/// Typically, this error is due to developer error. If you are no longer using the `Route` that is not present to
/// handle the `Routeable` that caused this error, consider deleting the `Route`.
public struct RouteMissing: Error {
    
    /// The erased `Routeable` that caused this error.
    public var routeable: AnyRouteable
    
    public init<R>(content: R) where R: Routeable {
        self.routeable = content.eraseToAnyRouteable()
    }
    
}

// MARK: - RouteMissing + CustomStringConvertible

extension RouteMissing: CustomStringConvertible {
    
    public var description: String {
        let format = NSLocalizedString(
            "ROUTE_MISSING_ERROR_DESCRIPTION_FORMAT",
            bundle: .module,
            comment: "Format string used to prepare error descriptions for missing route errors"
        )
        
        let contentTypeDescription = String(describing: type(of: routeable.erasedContent))
        return .localizedStringWithFormat(format, contentTypeDescription)
    }
    
}
