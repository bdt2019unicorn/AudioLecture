CREATE TABLE [dbo].[FundImportFileDetails] (
    [fundId]              INT NOT NULL,
    [taxableIncomeColumn] INT NULL,
    [tolWorkbookRow]      INT NULL,
    CONSTRAINT [PK_FundImportFileDetals] PRIMARY KEY CLUSTERED ([fundId] ASC)
);

