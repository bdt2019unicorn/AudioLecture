﻿CREATE TABLE [dbo].[ReportAnnualTaxCertificate] (
    [id]                              INT           IDENTITY (1, 1) NOT NULL,
    [eoyDate]                         SMALLDATETIME NOT NULL,
    [addedDate]                       DATE          CONSTRAINT [DF_ReportAnnualTaxCertificate_addedDate] DEFAULT (getdate()) NULL,
    [isHidden]                        BIT           CONSTRAINT [DF_ReportAnnualTaxCertificate_isHidden] DEFAULT ((1)) NULL,
    [memberid]                        INT           NOT NULL,
    [pieId]                           INT           NULL,
    [vehicleType]                     VARCHAR (50)  NULL,
    [memberName]                      VARCHAR (250) NULL,
    [memberIrdNumber]                 INT           NULL,
    [street1]                         VARCHAR (200) NULL,
    [street2]                         VARCHAR (200) NULL,
    [suburb]                          VARCHAR (100) NULL,
    [city]                            VARCHAR (100) NULL,
    [postcode]                        VARCHAR (4)   NULL,
    [quarter1Date]                    SMALLDATETIME NOT NULL,
    [quarter1PIR]                     FLOAT (53)    NOT NULL,
    [quarter1TaxableIncome]           FLOAT (53)    NOT NULL,
    [quarter1Expenses]                FLOAT (53)    NOT NULL,
    [quarter1TotalTaxableIncome]      FLOAT (53)    NOT NULL,
    [quarter1TaxPayableBeforeCredits] FLOAT (53)    NOT NULL,
    [quarter1FTC]                     FLOAT (53)    NOT NULL,
    [quarter1IC]                      FLOAT (53)    NOT NULL,
    [quarter1DWP]                     FLOAT (53)    NOT NULL,
    [quarter1RWT]                     FLOAT (53)    NOT NULL,
    [quarter1TaxCredits]              FLOAT (53)    NOT NULL,
    [quarter1TaxPayableAfterCredits]  FLOAT (53)    NOT NULL,
    [quarter2Date]                    SMALLDATETIME NOT NULL,
    [quarter2PIR]                     FLOAT (53)    NOT NULL,
    [quarter2TaxableIncome]           FLOAT (53)    NOT NULL,
    [quarter2Expenses]                FLOAT (53)    NOT NULL,
    [quarter2TotalTaxableIncome]      FLOAT (53)    NOT NULL,
    [quarter2TaxPayableBeforeCredits] FLOAT (53)    NOT NULL,
    [quarter2FTC]                     FLOAT (53)    NOT NULL,
    [quarter2IC]                      FLOAT (53)    NOT NULL,
    [quarter2DWP]                     FLOAT (53)    NOT NULL,
    [quarter2RWT]                     FLOAT (53)    NOT NULL,
    [quarter2TaxCredits]              FLOAT (53)    NOT NULL,
    [quarter2TaxPayableAfterCredits]  FLOAT (53)    NOT NULL,
    [quarter3Date]                    SMALLDATETIME NOT NULL,
    [quarter3PIR]                     FLOAT (53)    NOT NULL,
    [quarter3TaxableIncome]           FLOAT (53)    NOT NULL,
    [quarter3Expenses]                FLOAT (53)    NOT NULL,
    [quarter3TotalTaxableIncome]      FLOAT (53)    NOT NULL,
    [quarter3TaxPayableBeforeCredits] FLOAT (53)    NOT NULL,
    [quarter3FTC]                     FLOAT (53)    NOT NULL,
    [quarter3IC]                      FLOAT (53)    NOT NULL,
    [quarter3DWP]                     FLOAT (53)    NOT NULL,
    [quarter3RWT]                     FLOAT (53)    NOT NULL,
    [quarter3TaxCredits]              FLOAT (53)    NOT NULL,
    [quarter3TaxPayableAfterCredits]  FLOAT (53)    NOT NULL,
    [quarter4Date]                    SMALLDATETIME NOT NULL,
    [quarter4PIR]                     FLOAT (53)    NOT NULL,
    [quarter4TaxableIncome]           FLOAT (53)    NOT NULL,
    [quarter4Expenses]                FLOAT (53)    NOT NULL,
    [quarter4TotalTaxableIncome]      FLOAT (53)    NOT NULL,
    [quarter4TaxPayableBeforeCredits] FLOAT (53)    NOT NULL,
    [quarter4FTC]                     FLOAT (53)    NOT NULL,
    [quarter4IC]                      FLOAT (53)    NOT NULL,
    [quarter4DWP]                     FLOAT (53)    NOT NULL,
    [quarter4RWT]                     FLOAT (53)    NOT NULL,
    [quarter4TaxCredits]              FLOAT (53)    NOT NULL,
    [quarter4TaxPayableAfterCredits]  FLOAT (53)    NOT NULL,
    [leftOverFTC]                     FLOAT (53)    CONSTRAINT [DF_ReportAnnualTaxCertificate_leftOverFTC_1] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ReportAnnualTaxCertificate] PRIMARY KEY CLUSTERED ([id] ASC)
);
