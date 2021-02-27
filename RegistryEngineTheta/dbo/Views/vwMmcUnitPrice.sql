CREATE VIEW dbo.vwMmcUnitPrice
AS
SELECT        f.fundId, f.fundName, f.fundCode, fb.endDate AS priceDate, fb.endUnitPrice AS navPrice, fb.endUnitPrice AS buyPrice, fb.endUnitPrice AS sellPrice, fb.endUnitAmount, 
                         (t.taxableIncomeAmount + ISNULL(fdr.taxableFDRIncome, 0)) / fb.endUnitAmount AS taxableIncomePerUnit, t.foreignTaxCredits / fb.endUnitAmount AS foreignTaxCreditsPerUnit, 
                         t.dividendWithholdingPayments / fb.endUnitAmount AS dividendWithholdingPaymentsPerUnit, t.RWT / fb.endUnitAmount AS ResidenceWithholdingTaxPerUnit, 
                         t.imputationCredits / fb.endUnitAmount AS imputationCreditsPerUnit
FROM            dbo.FundBalance AS fb INNER JOIN
                         dbo.Fund AS f ON f.fundId = fb.fundId INNER JOIN
                         dbo.FundTaxableIncome AS t ON t.fundid = fb.fundId AND t.valuationDate = fb.endDate LEFT OUTER JOIN
                         dbo.FundTaxableIncome AS fdr ON fdr.fundid = f.fundId AND fdr.valuationDate = dbo.fnGetPreviousValuationDate(t.valuationDate)

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "fb"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 271
               Bottom = 136
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 722
               Bottom = 136
               Right = 975
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fdr"
            Begin Extent = 
               Top = 6
               Left = 1013
               Bottom = 136
               Right = 1266
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vwMmcUnitPrice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vwMmcUnitPrice';

