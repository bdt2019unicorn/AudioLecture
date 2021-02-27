﻿CREATE TABLE [dbo].[ISIData] (
    [memberId]                        INT              NOT NULL,
    [fundId]                          INT              NOT NULL,
    [valuationDate]                   DATE             NOT NULL,
    [TotalUnitsOnIssue]               DECIMAL (38, 10) NULL,
    [InvestorUnitsHeld]               DECIMAL (38, 10) NULL,
    [BasePrice]                       DECIMAL (38, 10) NULL,
    [EntryPrice]                      DECIMAL (38, 10) NULL,
    [ExitPrice]                       DECIMAL (38, 10) NULL,
    [TaxableIncome]                   DECIMAL (18, 2)  NULL,
    [NonTaxableIncome]                DECIMAL (18, 2)  NULL,
    [ForeignTaxCredits]               DECIMAL (18, 2)  NULL,
    [DividendWithholdingPayments]     DECIMAL (18, 2)  NULL,
    [ResidentWithholdingTax]          DECIMAL (18, 2)  NULL,
    [ImputationCredits]               DECIMAL (18, 2)  NULL,
    [FormationLossesUsed]             DECIMAL (18, 2)  NULL,
    [LandLossesUsed]                  DECIMAL (18, 2)  NULL,
    [DeductibleExpenses]              DECIMAL (18, 2)  NULL,
    [InvestorAccountRebates]          DECIMAL (18, 2)  NULL,
    [InvestorAccountExpenses]         DECIMAL (18, 2)  NULL,
    [CPU_TaxableIncome]               DECIMAL (38, 10) NULL,
    [CPU_NonTaxableIncome]            DECIMAL (38, 10) NULL,
    [CPU_ForeignTaxCredits]           DECIMAL (38, 10) NULL,
    [CPU_DividendWithholdingPayments] DECIMAL (38, 10) NULL,
    [CPU_ResidentWithholdingTax]      DECIMAL (38, 10) NULL,
    [CPU_ImputationCredits]           DECIMAL (38, 10) NULL,
    [CPU_FormationLossesUsed]         DECIMAL (38, 10) NULL,
    [CPU_LandLossesUsed]              DECIMAL (38, 10) NULL,
    [CPU_DeductibleExpenses]          DECIMAL (38, 10) NULL,
    [CPU_InvestorAccountRebates]      DECIMAL (38, 10) NULL,
    [CPU_InvestorAccountExpenses]     DECIMAL (38, 10) NULL,
    CONSTRAINT [PK_ISIData] PRIMARY KEY CLUSTERED ([memberId] ASC, [fundId] ASC, [valuationDate] ASC)
);
