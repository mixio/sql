/// Types conforming to this protocol are capable of serializing to SQL.
/// They can optionally output zero or more binds. This is useful when types like
/// expressions must serialize value placeholders into a SQL string.
/// They can also optionally have a Table to Aliases Dictionary used to switch table names for table aliases in SQL expressions.
public protocol SQLSerializable {
    /// Serializes self into a SQL string. If the string contains value placeholders,
    /// each encodable value is appended to the binds array in the order it appears in the string.
    /// Add a `SQLTableAliases` dictionary to replace table names by table aliases in SQL expressions.
    func serialize(_ binds: inout [Encodable], aliases: SQLTableAliases?) -> String

    /// Serializes self into a SQL string. If the string contains value placeholders,
    /// each encodable value is appended to the binds array in the order it appears in the string.
    func serialize(_ binds: inout [Encodable]) -> String
}

// MARK : Convenience
extension SQLSerializable {
    /// Convenience method to use when table aliases are irrelevant.
    public func serialize(_ binds: inout [Encodable]) -> String {
        return serialize(&binds, aliases: nil)
    }
}

extension Array where Element: SQLSerializable {
    /// Convenience for serializing an array of `SQLSerializable` types into a string.
    public func serialize(_ binds: inout [Encodable], aliases: SQLTableAliases? = nil, joinedBy separator: String = ", ") -> String {
        return map { $0.serialize(&binds, aliases: aliases) }.joined(separator: separator)
    }
}
