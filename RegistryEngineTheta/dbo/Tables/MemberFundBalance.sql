CREATE TABLE [dbo].[MemberFundBalance] (
    [id]                 INT             IDENTITY (1, 1) NOT NULL,
    [addedDate]          DATETIME        CONSTRAINT [DF_MemberFundBalance_addedDate] DEFAULT (getdate()) NOT NULL,
    [fundId]             INT             NOT NULL,
    [memberId]           INT             NOT NULL,
    [startDate]          DATE            NOT NULL,
    [endDate]            DATE            NOT NULL,
    [startUnitAmount]    DECIMAL (18, 4) NOT NULL,
    [transferUnitAmount] DECIMAL (18, 4) NOT NULL,
    [endUnitAmount]      DECIMAL (18, 4) NOT NULL,
    CONSTRAINT [PK_MemberFundBalance] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_MemberFundBalance_Fund] FOREIGN KEY ([fundId]) REFERENCES [dbo].[Fund] ([fundId])
);


GO
CREATE NONCLUSTERED INDEX [ix_MemberFundBalance_memberIdEndDate]
    ON [dbo].[MemberFundBalance]([memberId] ASC, [endDate] ASC);

