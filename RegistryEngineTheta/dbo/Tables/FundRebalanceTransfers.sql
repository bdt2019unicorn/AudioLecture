CREATE TABLE [dbo].[FundRebalanceTransfers] (
    [fundId]                INT             NOT NULL,
    [valuationDate]         DATE            NOT NULL,
    [transferOutUnitAmount] DECIMAL (18, 4) NULL,
    [transferInUnitAmount]  DECIMAL (18, 4) NULL,
    [outflowTolUnitAmount]  DECIMAL (18, 4) NULL,
    [inflowTolUnitAmount]   DECIMAL (18, 4) NULL,
    [netTotalUnitFlow]      DECIMAL (18, 4) NULL,
    CONSTRAINT [PK_FundRebalanceTransfers] PRIMARY KEY CLUSTERED ([fundId] ASC, [valuationDate] ASC)
);

