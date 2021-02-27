CREATE TABLE [dbo].[FundTransactionOffsetLevy] (
    [id]                  INT             IDENTITY (1, 1) NOT NULL,
    [addedDate]           DATETIME        CONSTRAINT [DF_AxysPortfolioTransactionOffsetLevy_addedDate] DEFAULT (getdate()) NULL,
    [fundId]              INT             NULL,
    [valuationDate]       SMALLDATETIME   NULL,
    [inflowLevy]          FLOAT (53)      NULL,
    [outflowLevy]         FLOAT (53)      NULL,
    [inflowDollarAmount]  DECIMAL (18, 2) NULL,
    [outflowDollarAmount] DECIMAL (18, 2) NULL,
    [netType]             VARCHAR (50)    NULL,
    [adjustedInflowLevy]  FLOAT (53)      NULL,
    [adjustedOutflowLevy] FLOAT (53)      NULL,
    CONSTRAINT [PK_AxysPortfolioTransactionOffsetLevy] PRIMARY KEY CLUSTERED ([id] ASC)
);

