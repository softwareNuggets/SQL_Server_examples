/*
===============================================================================
    Project:    SQL Server — Search All Text Columns
    Programmer: Scott Johnson
    Channel:    Software Nuggets
    YouTube:    https://www.youtube.com/softwareNuggets

    Purpose:
        Search every text column in the current database for West, East,
        North, or South.

        Return the schema, table, and column name when at least one value
        matches, along with the matching row count for each direction.

    Matching Rules:
        - Match complete values, ignoring case and surrounding spaces.
        - A column needs only one of the four values to qualify.
        - ' West ' matches; 'West Depot' does not.
        - Count matching rows, not occurrences within a row.

    Run Using:
        Devart dbForge Studio for SQL Server or
        SQL Server Management Studio (SSMS).

    Note:
        NOLOCK may read uncommitted data and miss or double-count rows.
        Remove this hint when accurate counts are required.
===============================================================================
*/

USE inventory;

    CREATE TABLE dbo.Warehouses
    (
        WarehouseID int PRIMARY KEY,
        WarehouseName nvarchar(80) NOT NULL,
        Region nvarchar(10) NOT NULL,
        Capacity int NOT NULL,
        IsActive bit NOT NULL
    );

    CREATE TABLE dbo.Suppliers
    (
        SupplierID int PRIMARY KEY,
        SupplierName nvarchar(80) NOT NULL,
        ServiceArea varchar(10) NOT NULL,
        LeadTimeDays int NOT NULL,
        IsPreferred bit NOT NULL
    );

    CREATE TABLE dbo.StorageBins
    (
        BinID int PRIMARY KEY,
        WarehouseID int NOT NULL,
        BinCode varchar(12) NOT NULL,
        AisleZone nchar(5) NOT NULL,
        MaxUnits int NOT NULL
    );

    CREATE TABLE dbo.ShippingRoutes
    (
        RouteID int PRIMARY KEY,
        RouteCode varchar(12) NOT NULL,
        DispatchDirection char(5) NOT NULL,
        TransitDays int NOT NULL,
        IsActive bit NOT NULL
    );

    CREATE TABLE dbo.Categories
    (
        CategoryID int PRIMARY KEY,
        CategoryName nvarchar(60) NOT NULL,
        Description nvarchar(160) NOT NULL,
        HandlingCode varchar(12) NOT NULL,
        IsActive bit NOT NULL
    );

    CREATE TABLE dbo.Products
    (
        ProductID int PRIMARY KEY,
        SKU varchar(20) NOT NULL UNIQUE,
        ProductName nvarchar(80) NOT NULL,
        CategoryID int NOT NULL,
        UnitCost decimal(10,2) NOT NULL
    );

    CREATE TABLE dbo.StockBalances
    (
        StockID int PRIMARY KEY,
        ProductID int NOT NULL,
        WarehouseID int NOT NULL,
        QuantityOnHand int NOT NULL,
        StockStatus nvarchar(20) NOT NULL
    );

    CREATE TABLE dbo.PurchaseOrders
    (
        PurchaseOrderID int PRIMARY KEY,
        SupplierID int NOT NULL,
        OrderNumber varchar(20) NOT NULL UNIQUE,
        OrderDate date NOT NULL,
        OrderStatus nvarchar(20) NOT NULL
    );

    CREATE TABLE dbo.PurchaseOrderLines
    (
        PurchaseOrderLineID int PRIMARY KEY,
        PurchaseOrderID int NOT NULL,
        ProductID int NOT NULL,
        QuantityOrdered int NOT NULL,
        LineNote nvarchar(120) NULL
    );

    CREATE TABLE dbo.StockMovements
    (
        MovementID int PRIMARY KEY,
        ProductID int NOT NULL,
        MovementType nvarchar(20) NOT NULL,
        QuantityChange int NOT NULL,
        MovementDate date NOT NULL
    );



   INSERT INTO dbo.Warehouses
        (WarehouseID, WarehouseName, Region, Capacity, IsActive)
    VALUES
        (1, N'Main Depot', N'West', 5000, 1),
        (2, N'Overflow Depot', N'East', 2500, 1),
        (3, N'Parts Depot', N'North', 3000, 1),
        (4, N'Bulk Depot', N'South', 7000, 1),
        (5, N'Reserve Depot', N'West', 1800, 1),
        (6, N'Seasonal Depot', N'East', 1200, 0);

    INSERT INTO dbo.Suppliers
        (SupplierID, SupplierName, ServiceArea, LeadTimeDays, IsPreferred)
    VALUES
        (1, N'Acme Industrial', N'West', 3, 1),
        (2, N'Bolt Supply', N'West', 5, 0),
        (3, N'Metro Packaging', N'East', 2, 1),
        (4, N'Precision Parts', N'North', 7, 1),
        (5, N'Value Hardware', N'East', 4, 0),
        (6, N'Prime Components', N'West', 6, 0);

    INSERT INTO dbo.StorageBins
        (BinID, WarehouseID, BinCode, AisleZone, MaxUnits)
    VALUES
        (1, 1, N'A-01', N'North', 100),
        (2, 1, N'A-02', N'South', 150),
        (3, 2, N'B-01', N'South', 200),
        (4, 2, N'B-02', N'North', 100),
        (5, 3, N'C-01', N'South', 250),
        (6, 3, N'C-02', N'North', 175);

    INSERT INTO dbo.ShippingRoutes
        (RouteID, RouteCode, DispatchDirection, TransitDays, IsActive)
    VALUES
        (1, N'RT-001', N'South', 1, 1),
        (2, N'RT-002', N'South', 2, 1),
        (3, N'RT-003', N'South', 3, 1),
        (4, N'RT-004', N'South', 1, 0),
        (5, N'RT-005', N'South', 4, 1),
        (6, N'RT-006', N'South', 2, 0);

    INSERT INTO dbo.Categories
        (CategoryID, CategoryName, Description, HandlingCode, IsActive)
    VALUES
        (1, N'Fasteners', N'Bolts, nuts, and washers', N'STANDARD', 1),
        (2, N'Hand Tools', N'Manual workshop tools', N'STANDARD', 1),
        (3, N'Safety Gear', N'Personal protective equipment', N'CLEAN', 1),
        (4, N'Packaging', N'Boxes and packing materials', N'DRY', 1),
        (5, N'Electrical', N'Wire and cable accessories', N'DRY', 1),
        (6, N'Adhesives', N'Glues and sealants', N'COOL', 1);

    INSERT INTO dbo.Products
        (ProductID, SKU, ProductName, CategoryID, UnitCost)
    VALUES
        (1, N'SKU-100', N'Hex Bolt', 1, 0.25),
        (2, N'SKU-101', N'Socket Wrench', 2, 18.5),
        (3, N'SKU-102', N'Safety Goggles', 3, 6.75),
        (4, N'SKU-103', N'Packing Box', 4, 1.2),
        (5, N'SKU-104', N'Cable Tie', 5, 0.08),
        (6, N'SKU-105', N'Epoxy Adhesive', 6, 8.95);

    INSERT INTO dbo.StockBalances
        (StockID, ProductID, WarehouseID, QuantityOnHand, StockStatus)
    VALUES
        (1, 1, 1, 1500, N'Available'),
        (2, 2, 1, 80, N'Available'),
        (3, 3, 2, 20, N'Low stock'),
        (4, 4, 2, 450, N'Available'),
        (5, 5, 3, 5000, N'Available'),
        (6, 6, 3, 0, N'Out of stock');

    INSERT INTO dbo.PurchaseOrders
        (PurchaseOrderID, SupplierID, OrderNumber, OrderDate, OrderStatus)
    VALUES
        (1, 1, N'PO-1001', N'2026-10-01', N'Received'),
        (2, 2, N'PO-1002', N'2026-10-02', N'Approved'),
        (3, 3, N'PO-1003', N'2026-10-03', N'Open'),
        (4, 4, N'PO-1004', N'2026-10-04', N'Received'),
        (5, 5, N'PO-1005', N'2026-10-05', N'Cancelled'),
        (6, 6, N'PO-1006', N'2026-10-06', N'Open');

    INSERT INTO dbo.PurchaseOrderLines
        (PurchaseOrderLineID, PurchaseOrderID, ProductID, QuantityOrdered, LineNote)
    VALUES
        (1, 1, 1, 2000, N'Standard delivery'),
        (2, 2, 2, 50, N'Use protective wrapping'),
        (3, 3, 3, 100, N'Inspect on arrival'),
        (4, 4, 4, 500, N'Keep dry'),
        (5, 5, 5, 10000, NULL),
        (6, 6, 6, 60, N'Store in a cool cabinet');

    INSERT INTO dbo.StockMovements
        (MovementID, ProductID, MovementType, QuantityChange, MovementDate)
    VALUES
        (1, 1, N'Receipt', 2000, N'2026-10-10'),
        (2, 1, N'Issue', -500, N'2026-10-11'),
        (3, 2, N'Receipt', 80, N'2026-10-12'),
        (4, 3, N'Receipt', 20, N'2026-10-13'),
        (5, 4, N'Receipt', 450, N'2026-10-14'),
        (6, 5, N'Receipt', 5000, N'2026-10-15');



/*
    Search every text column in the current database for West, East,
    North, or South.

    Return a column when at least one of these four complete values exists.
    Count matching rows for each value, ignoring case and surrounding spaces.
    For example, ' west ' matches West; 'West Depot' does not.

    This section can be run independently of the sample-table setup above.
*/
SET NOCOUNT ON;

IF OBJECT_ID(N'tempdb..#ColumnsContainingAnyValue') IS NOT NULL
    DROP TABLE #ColumnsContainingAnyValue;

CREATE TABLE #ColumnsContainingAnyValue
(
    SchemaName      sysname NOT NULL,
    TableName       sysname NOT NULL,
    ColumnName      sysname NOT NULL,
    West_RowCount   bigint  NOT NULL,
    East_RowCount   bigint  NOT NULL,
    North_RowCount  bigint  NOT NULL,
    South_RowCount  bigint  NOT NULL
);

DECLARE
    @SchemaName sysname,
    @TableName  sysname,
    @ColumnName sysname,
    @Sql        nvarchar(max);

/*
    Find every character/text column in every user table.
    system_type_id also includes user-defined alias types based on text types.
*/
DECLARE ColumnCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT
    s.name,
    t.name,
    c.name
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
JOIN sys.columns AS c
    ON c.object_id = t.object_id
WHERE t.is_ms_shipped = 0
  AND c.system_type_id IN (167, 175, 231, 239)    --varchar, char, nvarchar, nchar
ORDER BY
    s.name,
    t.name,
    c.column_id;

OPEN ColumnCursor;

FETCH NEXT FROM ColumnCursor
INTO @SchemaName, @TableName, @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    /*
        Object names cannot be supplied as ordinary SQL parameters.
        QUOTENAME safely inserts the schema, table, and column names.
        Normalize each value for case-insensitive, space-trimmed comparisons.
        COUNT_BIG avoids the integer overflow possible with SUM(int).
    */
    SET @Sql = N'
        INSERT INTO #ColumnsContainingAnyValue
        (
            SchemaName,
            TableName,
            ColumnName,
            West_RowCount,
            East_RowCount,
            North_RowCount,
            South_RowCount
        )
        SELECT
            @SchemaName,
            @TableName,
            @ColumnName,
            /* Count rows whose complete value is West. */
            COUNT_BIG(CASE
                WHEN txt.Value = N''WEST''
                THEN 1
            END),

            /* Count rows whose complete value is East. */
            COUNT_BIG(CASE
                WHEN txt.Value = N''EAST''
                THEN 1
            END),

            /* Count rows whose complete value is North. */
            COUNT_BIG(CASE
                WHEN txt.Value = N''NORTH''
                THEN 1
            END),

            /* Count rows whose complete value is South. */
            COUNT_BIG(CASE
                WHEN txt.Value = N''SOUTH''
                THEN 1
            END)

        /*
            NOLOCK can read uncommitted data and miss or double-count rows.
            Retained from your version for investigation/discovery.
            Remove this hint when accurate, committed-data counts are required.
        */
        FROM ' + QUOTENAME(@SchemaName) + N'.' + QUOTENAME(@TableName) + N' AS src WITH (NOLOCK)
        CROSS APPLY
        (
            VALUES
            (
                UPPER(LTRIM(RTRIM(CONVERT(nvarchar(max), src.' + QUOTENAME(@ColumnName) + N'))))
            )
        ) AS txt(Value)

        /* Keep this column when any of the four values exists. */
        HAVING
            COUNT_BIG(CASE
                WHEN txt.Value IN (N''WEST'', N''EAST'', N''NORTH'', N''SOUTH'')
                THEN 1
            END) > 0;';

    EXEC sys.sp_executesql
        @Sql,
        N'@SchemaName sysname, @TableName sysname, @ColumnName sysname',
        @SchemaName = @SchemaName,
        @TableName = @TableName,
        @ColumnName = @ColumnName;

    FETCH NEXT FROM ColumnCursor
    INTO @SchemaName, @TableName, @ColumnName;
END;

CLOSE ColumnCursor;
DEALLOCATE ColumnCursor;

/* Show every text column containing at least one complete direction value. */
SELECT
    SchemaName,
    TableName,
    ColumnName,
    West_RowCount,
    East_RowCount,
    North_RowCount,
    South_RowCount
FROM #ColumnsContainingAnyValue
ORDER BY
    SchemaName,
    TableName,
    ColumnName;
