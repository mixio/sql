/// The `CREATE TABLE` command is used to create a new table in a database.
///
/// See `SQLCreateTableBuilder`.
public protocol SQLCreateTable: SQLSerializable {
    /// See `SQLTableIdentifier`.
    associatedtype TableIdentifier: SQLTableIdentifier
    
    /// See `SQLColumnDefinition`.
    associatedtype ColumnDefinition: SQLColumnDefinition
    
    /// See `SQLTableConstraint`.
    associatedtype TableConstraint: SQLTableConstraint
    
    /// Creates a new `SQLCreateTable` query.
    static func createTable(_ table: TableIdentifier) -> Self
    
    /// If the "TEMP" or "TEMPORARY" keyword occurs between the "CREATE" and "TABLE" then the new table is created in the temp database.
    var temporary: Bool { get set }
    
    /// It is usually an error to attempt to create a new table in a database that already contains a table, index or view of the
    /// same name. However, if the "IF NOT EXISTS" clause is specified as part of the CREATE TABLE statement and a table or view
    /// of the same name already exists, the CREATE TABLE command simply has no effect (and no error message is returned). An
    /// error is still returned if the table cannot be created because of an existing index, even if the "IF NOT EXISTS" clause is
    /// specified.
    var ifNotExists: Bool { get set }
    
    /// Name of table to create.
    var table: TableIdentifier { get set }
    
    /// Columns to create.
    var columns: [ColumnDefinition] { get set }
    
    /// Table constraints, such as `FOREIGN KEY`, to add.
    var tableConstraints: [TableConstraint] { get set }
}

/// Generic implementation of `SQLCreateTable`.
public struct GenericSQLCreateTable<TableIdentifier, ColumnDefinition, TableConstraint>: SQLCreateTable
    where TableIdentifier: SQLTableIdentifier, ColumnDefinition: SQLColumnDefinition, TableConstraint: SQLTableConstraint
{
    /// Convenience alias for self.
    public typealias `Self` = GenericSQLCreateTable<TableIdentifier, ColumnDefinition, TableConstraint>
    
    /// See `SQLCreateTable`.
    public static func createTable(_ table: TableIdentifier) -> Self {
        return .init(temporary: false, ifNotExists: false, table: table, columns: [], tableConstraints: [])
    }
    
    /// See `SQLCreateTable`.
    public var temporary: Bool
    
    /// See `SQLCreateTable`.
    public var ifNotExists: Bool
    
    /// See `SQLCreateTable`.
    public var table: TableIdentifier
    
    /// See `SQLCreateTable`.
    public var columns: [ColumnDefinition]
    
    /// See `SQLCreateTable`.
    public var tableConstraints: [TableConstraint]
    
    /// See `SQLSerializable`.
    public func serialize(_ binds: inout [Encodable], aliases: SQLTableAliases?) -> String {
        var sql: [String] = []
        sql.append("CREATE")
        if temporary {
            sql.append("TEMPORARY")
        }
        sql.append("TABLE")
        if ifNotExists {
            sql.append("IF NOT EXISTS")
        }
        sql.append(table.serialize(&binds, aliases: aliases))
        let actions = columns.map { $0.serialize(&binds, aliases: aliases) } + tableConstraints.map { $0.serialize(&binds, aliases: aliases) }
        sql.append("(" + actions.joined(separator: ", ") + ")")
        return sql.joined(separator: " ")
    }
}
