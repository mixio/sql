/// `DELETE ... FROM` query.
///
/// See `SQLDeleteBuilder`.
public protocol SQLDelete: SQLSerializable {
    /// See `SQLTableIdentifier`.
    associatedtype TableIdentifier: SQLTableIdentifier
    
    /// See `SQLExpression`.
    associatedtype Expression: SQLExpression
    
    /// Creates a new `SQLDelete`.
    static func delete(_ table: TableIdentifier) -> Self
    
    /// Identifier of table to delete from.
    var table: TableIdentifier { get set }
    
    /// If the `WHERE` clause is not present, all records in the table are deleted. If a WHERE clause is supplied,
    /// then only those rows for which the WHERE clause boolean expression is true are deleted. Rows for which
    /// the expression is false or NULL are retained.
    var predicate: Expression? { get set }
}

// MARK: Generic

/// Generic implementation of `SQLDelete`.
public struct GenericSQLDelete<TableIdentifier, Expression>: SQLDelete
    where TableIdentifier: SQLTableIdentifier, Expression: SQLExpression
{
    /// See `SQLDelete`.
    public static func delete(_ table: TableIdentifier) -> GenericSQLDelete<TableIdentifier, Expression> {
        return .init(table: table, predicate: nil)
    }
    
    /// See `SQLDelete`.
    public var table: TableIdentifier
    
    /// See `SQLDelete`.
    public var predicate: Expression?
    
    /// See `SQLSerializable`.
    public func serialize(_ binds: inout [Encodable], aliases: SQLTableAliases?) -> String {
        var sql: [String] = []
        sql.append("DELETE FROM")
        sql.append(table.serialize(&binds))
        if let predicate = self.predicate {
            sql.append("WHERE")
            sql.append(predicate.serialize(&binds))
        }
        return sql.joined(separator: " ")
    }
}
