/// SQLTableAliases dictionary type to use in queries that require the use of Table aliases.
public typealias GenericSQLAliasIdentifier = GenericSQLIdentifier
public typealias SQLTableAliases = [GenericSQLTableIdentifier<GenericSQLIdentifier>:GenericSQLAliasIdentifier]

extension Dictionary where Key == GenericSQLTableIdentifier<GenericSQLIdentifier>, Value == GenericSQLAliasIdentifier {

    // Convenience initializer.
    init<T, A>(table: T, alias: A) where T: SQLTableIdentifier, A: SQLIdentifier {
        self = [table as! GenericSQLTableIdentifier<GenericSQLIdentifier>: alias as!  GenericSQLAliasIdentifier]
    }

    // Convenience subscript.
    public subscript<TableIdentifier>(table: TableIdentifier) -> Dictionary.Value? where TableIdentifier: SQLTableIdentifier {
        return self[table as! GenericSQLTableIdentifier<GenericSQLIdentifier>]
    }

}
