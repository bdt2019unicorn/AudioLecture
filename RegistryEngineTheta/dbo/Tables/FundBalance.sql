CREATE TABLE [dbo].[FundBalance] (
    [id]                 INT             IDENTITY (1, 1) NOT NULL,
    [addedDate]          DATETIME        CONSTRAINT [DF_FundBalance_addedDate] DEFAULT (getdate()) NULL,
    [fundId]             INT             NOT NULL,
    [startDate]          DATE            NULL,
    [endDate]            DATE            NULL,
    [startDollarAmount]  DECIMAL (18, 2) NULL,
    [startUnitPrice]     DECIMAL (18, 4) NULL,
    [startUnitAmount]    DECIMAL (18, 4) NULL,
    [transferUnitAmount] DECIMAL (18, 4) NULL,
    [endUnitAmount]      DECIMAL (18, 4) NULL,
    [endUnitPrice]       DECIMAL (18, 4) NULL,
    [endDollarAmount]    DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_FundBalance] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_FundBalance_Fund] FOREIGN KEY ([fundId]) REFERENCES [dbo].[Fund] ([fundId]),
    CONSTRAINT [IX_FundBalance_1] UNIQUE NONCLUSTERED ([fundId] ASC, [endDate] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_FundBalance]
    ON [dbo].[FundBalance]([fundId] ASC);

