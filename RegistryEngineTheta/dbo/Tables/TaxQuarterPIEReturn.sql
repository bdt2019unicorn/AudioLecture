CREATE TABLE [dbo].[TaxQuarterPIEReturn] (
    [id]                INT             IDENTITY (1, 1) NOT NULL,
    [addedDate]         DATETIME        CONSTRAINT [DF_TaxQuarterSummary_addedDate] DEFAULT (getdate()) NULL,
    [quarterDate]       DATE            NOT NULL,
    [memberid]          INT             NOT NULL,
    [pieId]             INT             NULL,
    [PIR]               DECIMAL (18, 2) CONSTRAINT [DF_TaxQuarterSummary_PIR] DEFAULT ((0)) NOT NULL,
    [taxPayable]        DECIMAL (18, 2) CONSTRAINT [DF_TaxQuarterSummary_taxPayment] DEFAULT ((0)) NOT NULL,
    [rebateFromIRD]     DECIMAL (18, 2) CONSTRAINT [DF_TaxQuarterSummary_rebateFromIRD] DEFAULT ((0)) NULL,
    [rebateFromIRDDate] DATE            NULL,
    [rebateFromPIE]     DECIMAL (18, 2) NULL,
    [rebateFromPIEDate] DATE            NULL,
    [paymentToIRD]      DECIMAL (18, 2) NULL,
    [paymentToIRDDate]  DATE            NULL,
    [paymentToPIE]      DECIMAL (18, 2) NULL,
    [paymentToPIEDate]  DATE            NULL,
    [UOMIPaidByIRD]     DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_TaxQuarterSummary] PRIMARY KEY CLUSTERED ([id] ASC)
);

