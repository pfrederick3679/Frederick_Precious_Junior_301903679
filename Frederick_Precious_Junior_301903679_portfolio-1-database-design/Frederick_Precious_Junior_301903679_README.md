# Portfolio 1 — Database Design and Modelling

I organised the data into player, game, match, score. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| player | 2 |
| game | 2 |
| match | 2 |
| score | 2 |

The 29 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Frederick_Precious_Junior_301903679_Design.md)
- [ER diagram](Frederick_Precious_Junior_301903679_ERDiagram.md)
- [Normalisation](Frederick_Precious_Junior_301903679_Normalisation.md)
- [Schema](Frederick_Precious_Junior_301903679_Schema.sql)
- [Sample data](Frederick_Precious_Junior_301903679_SampleData.sql)
- [Constraint tests](Frederick_Precious_Junior_301903679_ConstraintTests.sql)
- [Table and constraint evidence](Frederick_Precious_Junior_301903679_screenshots)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

