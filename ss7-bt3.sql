
-- 1. Tạo 4 bảng và chèn dữ liệu như hình dưới đây:
-- Tạo bảng Customer
CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25),
    cAge TINYINT
);

-- Tạo bảng Orders
CREATE TABLE Orders (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    constraint fk_Customer  FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- Tạo bảng Product
CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);

-- Tạo bảng OrderDetail
CREATE TABLE OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    constraint fk_orders   FOREIGN KEY (oID) REFERENCES Orders(oID),
    constraint fk_product FOREIGN KEY (pID) REFERENCES Product(pID)
);

-- Insert vào bảng Customer
INSERT INTO Customer (cID, Name, cAge)
VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

-- Insert vào bảng Orders
INSERT INTO Orders (oID, cID, oDate, oTotalPrice)
VALUES
(1, 1, '2006-03-21', NULL),
(2, 3, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

-- Insert vào bảng Product
INSERT INTO Product (pID, pName, pPrice)
VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

-- Insert vào bảng OrderDetail
INSERT INTO OrderDetail (oID, pID, odQTY)
VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(3, 1, 1),
(3, 5, 8),
(2, 4, 4),
(2, 3, 3);
-- 2. Hiển thị các thông tin gồm oID,cID, oDate, oTotalPrice của tất cả các hóa đơn trong bảng Orders, 
-- danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên như hình sau:

select * from Orders 
order by oDate desc;

-- 3 Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau:

select p.pName, p.pPrice
from Product p
where p.pPrice = (select max(pPrice) from Product);

-- 4. Hiển thị danh sách các khách hàng đã mua hàng, 
-- và danh sách sản phẩm được mua bởi các khách đó như sau:
select c.Name ,p.pName from Customer c
join Orders o on o.cID = c.cID
join OrderDetail od on od.oID = o.oID
join Product p on p.pID = od.pID;

-- 5 Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau

select c.Name from Customer c
where c.cID not in( select o.cID from Orders o );

-- 6. Hiển thị chi tiết của từng hóa đơn như sau :
select o.oID ,o.oDate ,od.odQTY, p.pName, p.pPrice 
from Orders o 
join OrderDetail od on od.oID = o.oID
join Product p on p.pID = od.pID;
 -- 7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn 
 -- (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. 
 -- Giá bán của từng loại được tính = odQTY*pPrice) như sau:
 select o.oID ,o.oDate, sum(odQTY*pPrice) as Total  from Orders o
 JOIN OrderDetail od ON o.oID = od.oID
 JOIN Product p ON od.pID = p.pID
 GROUP BY o.oID, o.oDate;
 
 -- 8. Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị như sau:
 create view Sales as
 select sum(od.odQTY*p.pPrice) as TotalRevenue from Orders o
 JOIN OrderDetail od ON o.oID = od.oID
 JOIN Product p ON od.pID = p.pID;
 -- Hiển thị tổng doanh thu của siêu thị
SELECT * FROM Sales;

-- 9  Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng. [1.5]
 
 --  Xóa các ràng buộc khóa ngoại
 alter table OrderDetail drop foreign key fk_orders;
 alter table OrderDetail drop foreign key fk_product;
 alter table Orders drop foreign key fk_Customer;
 -- Xóa khóa chính của các bảng
 alter table Customer drop primary key;
 alter table Orders drop primary key;
 alter table Product drop primary key;
 alter table OrderDetail drop primary key;
  
-- Kiểm tra cấu trúc bảng Orders
DESCRIBE Orders;
-- Kiểm tra cấu trúc bảng prodcut
DESCRIBE Product;
-- Kiểm tra cấu trúc bảng OrdersDetail
DESCRIBE OrderDetail;
-- Kiểm tra cấu trúc bảng CUSTOMER
DESCRIBE Customer;

-- 10. Tạo một trigger tên là cusUpdate trên bảng Customer,
-- sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo:
delimiter //
create trigger cusUpdate
after update on Customer
for each row 
begin
  -- Cập nhật cID trong bảng Orders khi cID của khách hàng bị thay đổi
  update Orders
  set cID = new.cID
  where cID = old.cID;
end //
delimiter ; 
SHOW TRIGGERS;
SHOW CREATE TRIGGER cusUpdate;
-- Chèn dữ liệu mẫu vào bảng Customer
INSERT INTO Customer (cID, Name, cAge)
VALUES (4, 'Anh Tuan', 30);

-- Chèn dữ liệu mẫu vào bảng Orders liên quan đến khách hàng cID = 4
INSERT INTO Orders (oID, cID, oDate, oTotalPrice)
VALUES (4, 4, '2024-07-20', 100);

-- Cập nhật cID trong bảng Customer
UPDATE Customer
SET cID = 5
WHERE cID = 4;

-- 11. Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm, 
-- strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số, 
-- và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail

delimiter //

create procedure delProduct(in productName varchar(25))
begin
-- Xóa các thông tin liên quan đến sản phẩm trong bảng OrderDetail
 delete from OrderDetail
 where pID in(
  select pID FROM Product
  where pName = productName
 );
   -- Xóa sản phẩm trong bảng Product
    DELETE FROM Product
    WHERE pName = productName;
end//
delimiter ; 

-- Gọi stored procedure để xóa sản phẩm có tên 'Dieu Hoa'
CALL delProduct('Dieu Hoa');

-- Kiểm tra bảng Product để đảm bảo sản phẩm đã bị xóa
SELECT * FROM Product;

-- Kiểm tra bảng OrderDetail để đảm bảo các thông tin liên quan đã bị xóa
SELECT * FROM OrderDetail;


