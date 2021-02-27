CREATE TABLE [dbo].[ValuationPeriod] (
    [id]                      INT      IDENTITY (1, 1) NOT NULL,
    [addedDate]               DATETIME CONSTRAINT [DF_RebalancePeriod_addedDate] DEFAULT (getdate()) NULL,
    [valuationDate]           DATE     NULL,
    [isMonthEnd]              BIT      CONSTRAINT [DF_ValuationPeriod_isMonthEnd] DEFAULT ((0)) NULL,
    [isPublic]                BIT      CONSTRAINT [DF_ValuationPeriod_isPublic] DEFAULT ((0)) NULL,
    [rebalancingTransferDate] DATE     NULL,
    CONSTRAINT [PK_RebalancePeriod] PRIMARY KEY CLUSTERED ([id] ASC)
);

