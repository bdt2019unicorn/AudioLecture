CREATE TABLE [dbo].[MemberFundTransfer] (
    [id]                   INT             IDENTITY (1, 1) NOT NULL,
    [addedDate]            DATETIME        CONSTRAINT [DF_MemberFundTransfer_addedDate] DEFAULT (getdate()) NOT NULL,
    [fundId]               INT             NOT NULL,
    [memberId]             INT             NOT NULL,
    [valuationDate]        DATE            NOT NULL,
    [tolUnitAmount]        DECIMAL (18, 4) NOT NULL,
    [tolDollarAmount]      DECIMAL (18, 2) NOT NULL,
    [transferUnitAmount]   DECIMAL (18, 4) NOT NULL,
    [transferDollarAmount] DECIMAL (18, 2) NOT NULL,
    [tradeDate]            DATE            NULL,
    CONSTRAINT [PK_MemberFundTransfer] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_MemberFundTransfer_Fund] FOREIGN KEY ([fundId]) REFERENCES [dbo].[Fund] ([fundId]),
    CONSTRAINT [FK_MemberFundTransfer_MemberFundTransfer] FOREIGN KEY ([id]) REFERENCES [dbo].[MemberFundTransfer] ([id])
);

