CREATE TABLE [dbo].[AssetClass] (
    [code]           NVARCHAR (2)   NOT NULL,
    [assetClassName] NVARCHAR (100) NULL,
    [listOrder]      INT            NULL,
    CONSTRAINT [PK_AssetClass] PRIMARY KEY CLUSTERED ([code] ASC)
);

