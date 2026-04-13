SELECT --sum(NumberOpen), sum(NumberUnanswered), sum(NumberClosed) 
  FROM [dbo].[SUMMARY_TICKETS]
  where SummaryDate='2026-04-04'
  --where RouteId='c91ce421-c7f4-4878-a6b6-807b9505eef1'
  --order by SummaryDate desc


17	14	24
0	26	19
0	26	19
0	26	19
-----------
17  92. 81

select  DATEDIFF(SECOND,T.CreationDate, T.ClosingDate) / 3600.0 as DiffHours, TC.BusinessName
--, t.TicketId, t.CreationDate, t.ClosingDate
--T.*, DS.Subdomain 
from TICKETs T
INNER JOIN SUMMARY_SERVICE SS ON(T.SummaryServiceId = SS.SummaryServiceId)
INNER JOIN ROUTE_ASSIGNMENT RA ON(SS.RouteAssigmentId = RA.RouteAssigmentId)
INNER JOIN ROUTES R ON(RA.RouteId = R.RouteId)
INNER JOIN DOMAINS DS ON DS.DomainId=T.StateDomainId
INNER JOIN BUSES B ON SS.BusId = B.BusId
INNER JOIN TRANSPORT_COMPANIES TC ON B.TransportCompanyId = TC.TransportCompanyId
WHERE DS.SubDomain = 'CERRADO'
AND SS.ComplianceTransportCompanyApproved = 1
--where ss.ShiftId=1
--where R.RouteId='c91ce421-c7f4-4878-a6b6-807b9505eef1'
order by 2 desc


select * from SUMMARY_SERVICE where summaryserviceid='c3b0a815-c8b0-46f6-a594-0a425bbe55bc'

select * from ROUTE_ASSIGNMENT where routeassigmentid='38987498-7544-448b-83b9-2827df448ac9'


select * from SHIFTS


select * from ROUTES 
where Branch like '%Desampa%'


select * from routes where RouteId='c91ce421-c7f4-4878-a6b6-807b9505eef1'


select * from FREE_ZONE_PARAMETERS 
where ParameterId='DIAS_VENCIMIENTO_TICKETS'


select * from DOMAINS where DomainId=54

  SELECT --CAST(DATEADD(HOUR, FZ.TimeZone, MD.MissingDate) AS DATE) AS SummaryDate,
               T.FreeZoneId,
               B.TransportCompanyId,
               P.ClientCompanyId,
               R.RouteId,
               SS.ShiftId,
               R.RouteTypeDomainId,
               -- CERRADOS
               COUNT(CASE 
                        WHEN ST.Subdomain = 'CERRADO' --AND CAST(T.ClosingDate AS DATE)  <= CAST(MD.MissingDate AS DATE)
                        THEN 1 
                     END) AS NumberClosed,
               -- SIN RESPUESTA
               COUNT(CASE 
                        WHEN ST.Subdomain = 'ABIERTO' --AND CAST(T.CreationDate AS DATE)  <= CAST(MD.MissingDate AS DATE)
                        AND (X.HasAnswer = 0 OR X.Expired = 1)
                        THEN 1 
                     END) AS NumberUnanswered,
               -- ABIERTOS
               COUNT(CASE 
                        WHEN ST.Subdomain = 'ABIERTO' --AND CAST(T.CreationDate AS DATE)  <= CAST(MD.MissingDate AS DATE)
                        AND X.HasAnswer = 1
                        AND X.Expired = 0
                        THEN 1 
                     END) AS NumberOpen
        FROM TICKETS T
        INNER JOIN FREE_ZONES FZ ON(T.FreeZoneId = FZ.FreeZoneId)
        INNER JOIN PASSENGERS P ON T.PassengerId = P.PassengerId
        INNER JOIN SUMMARY_SERVICE SS ON(T.SummaryServiceId = SS.SummaryServiceId)
        INNER JOIN BUSES B ON(SS.BusId = B.BusId)
        INNER JOIN ROUTE_ASSIGNMENT RA ON(SS.RouteAssigmentId = RA.RouteAssigmentId)
        INNER JOIN ROUTES R ON(RA.RouteId = R.RouteId)
        INNER JOIN FREE_ZONE_PARAMETERS FZP ON(T.FreeZoneId = FZP.FreeZoneId AND FZP.ParameterId = 'DIAS_VENCIMIENTO_TICKETS')
        INNER JOIN DOMAINS ST ON(T.StateDomainId = ST.DomainId AND ST.Domain = 'ESTADO_TICKET')
        --CROSS JOIN #MissingDates MD
        OUTER APPLY 
        (
            SELECT 
                CASE WHEN EXISTS 
                (
                    SELECT 1
                    FROM TICKET_RESPONSES TR
                    WHERE TR.TicketId = T.TicketId
                    AND TR.UserId IS NOT NULL
                )
                THEN 1 ELSE 0 END AS HasAnswer,
                CASE WHEN CAST(DATEADD(HOUR, FZ.TimeZone, T.CreationDate) AS DATE) < DATEADD(DAY, -CAST(FZP.Value AS INT), CAST(DATEADD(HOUR, FZ.TimeZone, 0) AS DATE))
                THEN 1 ELSE 0 END AS Expired
        ) X
        where t.TicketId=95
        GROUP BY --CAST(DATEADD(HOUR, FZ.TimeZone, MD.MissingDate) AS DATE),
                 T.FreeZoneId,
                 B.TransportCompanyId,
                 P.ClientCompanyId,
                 R.RouteId,
                 SS.ShiftId,
                 R.RouteTypeDomainId



select * from shifts                 