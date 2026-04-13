select * from shifts      


select * from SUMMARY_SERVICE where summaryServiceId='563a82ed-861d-4a0e-8a57-64f6de2dde4a'


select sum(TransportIncome) from summary_service s
inner join buses b on s.busId = b.busId
inner join transport_companies t on b.transportCompanyId = t.transportCompanyId
where t.transportCompanyId = 'b2de18c9-b535-411b-985b-15abf4a168b9'
and ServicePaidToTransport=0
and ComplianceTransportCompanyApproved=1
and TransportBlockGroupStart>=202515
and TransportBlockGroupEnd<=202615


527.580.955--pendiente pago
1698915.00-- pagado


select * from transport_companies


1.698.915

413.882.070



select distinct s.*, r.Branch
--sum(ccs.ContingencyPassengers), t.BusinessName 
from summary_service s
inner join CLIENT_COMPANY_SERVICES ccs on s.summaryServiceId = ccs.summaryServiceId
inner join buses b on s.busId = b.busId
inner join transport_companies t on b.transportCompanyId = t.transportCompanyId
INNER JOIN ROUTE_ASSIGNMENT RA ON(S.RouteAssigmentId = RA.RouteAssigmentId)
INNER JOIN ROUTES R ON(RA.RouteId = R.RouteId)
where t.transportCompanyId = 'd1411d81-af8e-482c-82cb-164826141d82'
and 
ComplianceTransportCompanyApproved=1
and CAST(DATEADD(HOUR, -5, S.StartDate) AS DATE) BETWEEN '2025-04-10' AND '2025-11-30'
and r.RouteTypeDomainId=55
--group by t.BusinessName


select * from DOMAINS where Subdomain like 'Especial%'


select * from ROUTE_ASSIGNMENT where RouteAssigmentId='c3c78b54-f2ae-41f9-9326-5317d36d59f3'

select * from routes where routeId='77e93418-05d0-4fe2-a5c2-151496c01850'





select 
sum(ccs.ContingencyPassengers), c.BusinessName 
from summary_service s
inner join CLIENT_COMPANY_SERVICES ccs on s.summaryServiceId = ccs.summaryServiceId
inner join buses b on s.busId = b.busId
inner join transport_companies t on b.transportCompanyId = t.transportCompanyId
INNER JOIN ROUTE_ASSIGNMENT RA ON(S.RouteAssigmentId = RA.RouteAssigmentId)
INNER JOIN ROUTES R ON(RA.RouteId = R.RouteId)
inner join CLIENT_COMPANIES c on c.ClientCompanyId = ccs.ClientCompanyId
where --t.transportCompanyId = 'd1411d81-af8e-482c-82cb-164826141d82'
---and 
ComplianceTransportCompanyApproved=1
and CAST(DATEADD(HOUR, -5, S.StartDate) AS DATE) BETWEEN '2025-04-10' AND '2025-11-30'
--and r.RouteTypeDomainId=55
group by c.BusinessName
order by 1 desc