USE CompanyX;

SET NOCOUNT ON;

With baseTable as 
(select H.SalesOrderID,SalesOrderDetailID,H.SalesOrderID+SalesOrderDetailID as DateID,UnitPrice,UnitPriceDiscount,UnitPriceDiscount*OrderQty as ExtendedDiscount, P.StandardCost, P.StandardCost * OrderQty as ExtendedCost,LineTotal,H.OrderDate,H.DueDate,H.ShipDate,H.ModifiedDate
from (CompanyX.Sales.SalesOrderDetail D JOIN CompanyX.Sales.SalesOrderHeader H ON (D.SalesOrderID = H.SalesOrderID)) JOIN CompanyX.Production.Product P ON (D.ProductID = P.ProductID)),
ProductKey as
(select SalesOrderID,SalesOrderDetailID,P.ProductIndex,P.ProductID 
from CompanyX.Sales.SalesOrderDetail D JOIN dbo.DimProduct P ON (D.ProductID=P.ProductID)),
PromoKey as
(select SalesOrderID,SalesOrderDetailID,P.PromotionKey, P.SpecialOfferID
from CompanyX.Sales.SalesOrderDetail D JOIN dbo.DimPromotion P ON (D.SpecialOfferID = P.SpecialOfferID)),
CustomerKey as
(select CustomerIndex,SalesOrderID, C.CustomerID
from dbo.DimCustomer C JOIN CompanyX.Sales.SalesOrderHeader H ON (C.CustomerID = H.CustomerID)),
KeyAddersFirst3 as 
(select CK.SalesOrderID,PK.SalesOrderDetailID,CK.CustomerIndex,PK.PromotionKey,PDK.ProductIndex,CK.CustomerID,PK.SpecialOfferID,PDK.ProductID
from (CustomerKey CK JOIN PromoKey PK ON CK.SalesOrderID = PK.SalesOrderID)
JOIN ProductKey PDK ON (PDK.SalesOrderDetailID = PK.SalesOrderDetailID and PDK.SalesOrderID = PK.SalesOrderID)),
/* join sales header with territoryID */
TerritoryAdder as (
select SH.SalesOrderID,T.TerritoryID,T.TerritoryIndex
from CompanyX.Sales.SalesOrderHeader SH join dbo.DimTerritory T on (SH.TerritoryID = T.TerritoryID)
),
/* join with reason*/
ReasonAdder as (
select SH.SalesOrderID,R.ReasonKey
from CompanyX.Sales.SalesOrderHeader SH join dbo.DimSalesReason R on (SH.SalesOrderID = R.SalesOrderID)
),
/* join with ShipMethod */
ShipMethodAdder as (
select H.SalesOrderID,S.ShipMethodIndex, S.ShipMethodID
from CompanyX.Sales.SalesOrderHeader H join dbo.DimShipMethod S on (H.ShipMethodID = S.ShipMethodID)
),
/*join first3 keys with territory keys together */
Key4 as (
select KA.*,TA.TerritoryIndex,TA.TerritoryID
from KeyAddersFirst3 KA
						join TerritoryAdder TA on (KA.SalesOrderID = TA.SalesOrderID)
),
/* join first4 with ReasonKey */
Key6 as (
	select Key4.*,DimSalesReason.ReasonKey
	from Key4 left join dbo.DimSalesReason on (Key4.SalesOrderID = DimSalesReason.SalesOrderID)
),
OrderDateKeyAdder as (
	select D.DateKey, H.SalesOrderID
	from CompanyX.Sales.SalesOrderHeader H join dbo.DimDate D on (H.OrderDate = D.Date)
),
ShipDateKeyAdder as (
	select D.DateKey, H.SalesOrderID
	from CompanyX.Sales.SalesOrderHeader H join dbo.DimDate D on (H.ShipDate = D.Date)
),
DueDateKeyAdder as (
	select D.DateKey, H.SalesOrderID
	from CompanyX.Sales.SalesOrderHeader H join dbo.DimDate D on (H.DueDate = D.Date)
),
DateKeyAdder as (
	select OrderDateKeyAdder.SalesOrderID, OrderDateKeyAdder.DateKey as OrderDateKey, ShipDateKeyAdder.DateKey as ShipDateKey, DueDateKeyAdder.DateKey as DueDateKey
	from OrderDateKeyAdder join ShipDateKeyAdder on (OrderDateKeyAdder.SalesOrderID = ShipDateKeyAdder.SalesOrderID)
						   join DueDateKeyAdder  on (OrderDateKeyAdder.SalesOrderID = DueDateKeyAdder.SalesOrderID)
),
Key7 as (
	select distinct Key6.*,ShipMethodAdder.ShipMethodIndex, OrderDateKey, ShipDateKey, DueDateKey
	from Key6 join ShipMethodAdder on (Key6.SalesOrderID = ShipMethodAdder.SalesOrderID)
			  join DateKeyAdder    on (Key6.SalesOrderID = DateKeyAdder.SalesOrderID)
)
insert into dbo.FactSales (
	SalesOrderID,SalesOrderDetail,ProductKey,PromotionKey,CustomerKey,TerritoryKey,SaleReasonKey,
	OrderQty,UnitPrice,UnitPriceDiscount,OrderDateKey,DueDateKey,ShipDateKey,
	Status,OnlineOrderFlag,TaxAllocated,Freight_Allocated,TotalDueTime,LineAmountSource,
	ShipMethodKey
)
select distinct Key7.SalesOrderID,Key7.SalesOrderDetailID,Key7.ProductID,Key7.PromotionKey,Key7.CustomerID,Key7.TerritoryID,Key7.ReasonKey,
D.OrderQty,D.UnitPrice,D.UnitPriceDiscount,Key7.OrderDateKey,Key7.DueDateKey,Key7.ShipDateKey,
H.Status,H.OnlineOrderFlag,H.TaxAmt,H.Freight,H.TotalDue,D.LineTotal,
Key7.ShipMethodIndex
from CompanyX.Sales.SalesOrderHeader H join CompanyX.Sales.SalesOrderDetail D on (H.SalesOrderID = D.SalesOrderID)
									   join Key7 on (H.SalesOrderID = Key7.SalesOrderID and D.SalesOrderDetailID = Key7.SalesOrderDetailID )

go
UPDATE dbo.FactSales
SET LineAmount_Gross = UnitPrice * OrderQty,
    LineDiscountAmount = UnitPrice * UnitPriceDiscount * OrderQty,
    LineAmount_Net = UnitPrice * (1-UnitPriceDiscount) * OrderQty;

UPDATE dbo.FactSales
Set TotalDue_Line = LineAmount_Net + TaxAllocated + Freight_Allocated
