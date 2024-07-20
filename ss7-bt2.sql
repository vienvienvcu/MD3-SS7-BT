use md3_ss02;
create table Test (
  testId int auto_increment primary key,
  name varchar(20)
);
 create table Student(
  RN int auto_increment primary key,
  name varchar(20),
  age int
 );
 
 create table StudentTest(
 RN int,
 TestID int,
 Date date,
 Mark float,
 primary key (RN,TestID),
 constraint fk_Student foreign key(RN) references Student(RN),
 constraint fk_test foreign key(TestID) references Test(testId)
 );
 
 select * from Student;
 insert into Student(name,age) values
 ('nguyen hong ha', 20),
 ('truong ngoc anh', 30),
 ('tuan minh', 25),
 ('dan truong', 22);
 
 select * from Test;
  insert into Test(name) values
  ('EPC'),
  ('DWMX'),
  ('SQL1'),
  ('SQL2');
  
  select * from StudentTest;
  insert into StudentTest(RN,TestID,Date,Mark) values
  (1,1,'2006-7-17',8),
  (1,2,'2006-7-18',5),
  (1,3,'2006-7-19',7),
  (2,1,'2006-7-17',7),
  (2,2,'2006-7-18',4),
  (2,3,'2006-7-19',2),
  (3,1,'2006-7-17',10),
  (3,3,'2006-7-17',1);
  -- Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55
  alter table Student
  add constraint check_age check( age between 15 and 55);
  
  -- Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
  alter table Student
  add column status bit default 0;
  select * from Student;
  -- Thêm ràng buộc duy nhất cho cột name trên bảng Test
  alter table Test
  add constraint unique_name unique (name);
  select * from Test;

  -- Thử chèn một giá trị mới vào cột name
INSERT INTO Test(name) values ('NEW_NAME');
 -- Thử chèn một giá trị đã tồn tại vào cột name để kiểm tra ràng buộc duy nhất
insert into Test(name) values ('EPC');
-- show toan bo index trong bang test
 SHOW INDEXES FROM Test;
-- Xóa ràng buộc duy nhất (unique) trên bảng Test
 alter table Test
 drop index unique_name;
 -- Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi giống như hình sau
 select st.RN, st.TestID,s.name , t.name, st.Mark, st.Date 
 from StudentTest st
 join Student s on st.RN = s.RN
 join Test t on t.testId = st.TestID;
 
 -- 4. Hiển thị danh sách các bạn học viên chưa thi môn nào như hình sau:
 
 select s.RN ,s.name,s.age
 from Student s
 where s.RN not in(select distinct RN from StudentTest); -- distinct ử dụng kết hợp với lệnh SELECT để loại tất cả các bản sao của bản ghi và chỉ lấy các bản ghi duy nhất.
-- 5 Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi
 select st.RN, st.TestID,s.name , t.name, st.Mark , st.Date 
 from StudentTest st
 join Student s on st.RN = s.RN
 join Test t on t.testId = st.TestID
 where st.mark < 5;
 
 -- 6 Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi.
 select  s.RN, s.name AS student_name, avg(st.Mark ) as avg_mark
 from Student s
 join StudentTest st on st.RN = s.RN
 group by s.RN, s.name
 order by avg_mark desc;
 -- 7. Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
 select  s.RN, s.name AS student_name, avg(st.Mark ) as avg_mark
 from Student s
 join StudentTest st on st.RN = s.RN
 group by s.RN, s.name
 order by avg_mark desc
 limit 1;
 -- 8 Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học như sau:
 select  t.name, max(st.Mark ) as max_mark
 from StudentTest st
 join Test t on t.testId = st.TestID
 group by  t.name;
 -- Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên
 -- chưa thi môn nào thì phần tên môn học để Null như sau:
 SELECT 
    s.RN,
    s.name AS student_name,
    t.name AS test_name
FROM 
    Student s
LEFT JOIN 
    StudentTest st ON s.RN = st.RN
LEFT JOIN 
    Test t ON st.TestID = t.testId;

 -- 10. Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
 update Student 
 SET age = age+ 1;
 
 select * from Student;
 
 -- Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
 
 alter table Student
 ADD column Status_IN varchar(10) NOT NULL;
 
 -- Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, trường hợp còn lại nhận giá trị ‘Old’
 -- sau đó hiển thị toàn bộ nội dung bảng Student lên như sau
update Student
SET Status_IN = case 
when age <= 30 then 'Young'
when age > 30 then 'Old'
end;
select * from Student;

-- 13. Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi như sau:
 select st.RN, st.TestID,s.name , t.name, st.Mark , st.Date as test_date
 from StudentTest st
 join Student s on st.RN = s.RN
 join Test t on t.testId = st.TestID
 order by test_date asc  ;
 
 -- 14 Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5.
 -- Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
select  s.RN, s.name AS student_name, avg(st.Mark ) as avg_mark
 from Student s
 join 
 StudentTest st on st.RN = s.RN
 where 
 s.name like 't%'
 group by 
 s.RN, s.name
 having 
 avg_mark >=4.5;
 
 -- 16. Sủa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)
ALTER TABLE Student
 modify column name text;
 show create table Student;
 -- 17.Cập nhật (sử dụng phương thức write) cột name trong bảng student với yêu cầu sau:
 update Student
 SET name = case
   when age >20 then concat('old', name)
   else concat('yorng', name)
   end;
   select * from Student;
--  18. Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi

delete from Test
where testId not in(select distinct TestID from StudentTest);
select * from Test;
-- 19. Xóa thông tin điểm thi của sinh viên có điểm <5.
 delete from StudentTest 
 where mark < 5;
 select * from StudentTest;
    

 