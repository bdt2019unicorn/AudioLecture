CREATE TABLE [dbo].[ReportAnnualIR854InvestorCertificateJoint] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [memberid]       INT            NULL,
    [periodEndDate]  SMALLDATETIME  NULL,
    [name]           NVARCHAR (70)  NULL,
    [irNumber]       NVARCHAR (10)  NULL,
    [dob]            SMALLDATETIME  NULL,
    [contactAddress] NVARCHAR (255) NULL,
    [countryCode]    NCHAR (10)     NULL,
    [emailAddress]   NVARCHAR (255) NULL,
    [phoneNumber]    NVARCHAR (50)  NULL,
    CONSTRAINT [PK_ReportAnnualIR854InvestorCertificateJoint] PRIMARY KEY CLUSTERED ([id] ASC)
);

