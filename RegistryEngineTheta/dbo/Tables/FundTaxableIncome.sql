CREATE TABLE [dbo].[FundTaxableIncome] (
    [valuationDate]               SMALLDATETIME NOT NULL,
    [fundid]                      INT           NOT NULL,
    [addedDate]                   DATETIME      CONSTRAINT [DF_FundTaxableIncome_addedDate] DEFAULT (getdate()) NULL,
    [totalGrossIncome]            FLOAT (53)    NULL,
    [totalDeductibleExpenses]     FLOAT (53)    NULL,
    [taxableIncomeAmount]         FLOAT (53)    NULL,
    [foreignTaxCredits]           FLOAT (53)    NULL,
    [imputationCredits]           FLOAT (53)    NULL,
    [dividendWithholdingPayments] FLOAT (53)    NULL,
    [RWT]                         FLOAT (53)    NULL,
    [FDROpeningBalance]           FLOAT (53)    CONSTRAINT [DF_AxysPortfolioTaxableIncome_FDROpeningBalance_2] DEFAULT ((0)) NULL,
    [FDRClosingDate]              DATE          NULL,
    [FDRNumberOfDays]             INT           NULL,
    [taxableFDRIncome]            FLOAT (53)    CONSTRAINT [DF_AxysPortfolioTaxableIncome_taxableFDRIncome_2] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_AxysPortfolioTaxableIncome] PRIMARY KEY CLUSTERED ([valuationDate] ASC, [fundid] ASC),
    CONSTRAINT [FK_FundTaxableIncome_Fund] FOREIGN KEY ([fundid]) REFERENCES [dbo].[Fund] ([fundId])
);

