import JJTools
/// `JOIN` clause.
public protocol SQLJoin: SQLSerializable {
    /// See `SQLJoinMethod`.
    associatedtype Method: SQLJoinMethod

    /// See `SQLTableIdentifier`.
    associatedtype TableIdentifier: SQLTableIdentifier

    /// See `SQLExpression`.
    associatedtype Expression: SQLExpression

    /// Creates a new `SQLJoin`.
    static func join(_ method: Method, _ table: TableIdentifier, _ expression: Expression, alias: GenericSQLIdentifier?) -> Self
}

// MARK: Generic

/// Generic implementation of `SQLJoin`.
public struct GenericSQLJoin<Method, TableIdentifier, Expression>: SQLJoin
    where Method: SQLJoinMethod, TableIdentifier: SQLTableIdentifier, Expression: SQLExpression
{
    /// See `SQLJoin`.
    public static func join(_ method: Method, _ table: TableIdentifier, _ expression: Expression, alias: GenericSQLIdentifier?) -> GenericSQLJoin<Method, TableIdentifier, Expression> {
        return .init(method: method, table: table, expression: expression, alias: alias)
    }

    /// See `SQLJoin`.
    public var method: Method

    /// See `SQLJoin`.
    public var table: TableIdentifier

    /// See `SQLJoin`.
    public var expression: Expression

    public var alias: GenericSQLIdentifier?

    /// See `SQLSerializable`.
    public func serialize(_ binds: inout [Encodable], aliases: SQLTableAliases?) -> String {
        var sql = [String]()
        sql.append(method.serialize(&binds, aliases: aliases))
        sql.append("JOIN")
        sql.append(table.serialize(&binds, aliases: aliases))
        if let alias = alias {
            sql.append("AS")
            sql.append(alias.serialize(&binds, aliases: aliases))
            sql.append("ON")
            let tableAliases = SQLTableAliases(table:table, alias:alias)
            jjprint(tableAliases)
            sql.append(expression.serialize(&binds, aliases: tableAliases))
       } else {
            sql.append("ON")
            sql.append(expression.serialize(&binds, aliases: aliases))
        }
        return  sql.joined(separator: " ")
    }
}
