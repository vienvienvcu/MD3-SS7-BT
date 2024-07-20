use md3_ss02;
create table class (
  classId int auto_increment primary key,
  className varchar(50)
);

create table subjects(
   subjectId int auto_increment primary key,
   subjectName varchar(50)
);

create table students(
   studentId int auto_increment primary key,
   studentName varchar(50),
   age int,
   email varchar(100)
);

create table marks (
   mark int,
   subject_id int,
   student_id int,
   primary key(subject_id,student_id),
   constraint fk_subject foreign key(subject_id) references subjects(subjectId),
   constraint fk_student foreign key(student_id) references students(studentId)
);

create table classStudent(
   studentId int,
   classId int,
   constraint fk_student_class foreign key(studentId) references students(studentId),
   constraint fk_class foreign key(classId) references class(classId)
);
 
 select * from students;
 insert into students(studentName,age,email) values 
('Nguyen Quang An', 18, 'an@yahoo.com'),
('Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
('Nguyen Van Quyen', 19, 'quyen'),
('Pham Thanh Binh', 25, 'binh@com'),
('Nguyen Van Tai Em', 30, 'taiem@sport.vn');

select * from class ;
insert into class(className) values 
('C0706L'),
('C0708G');

select * from subjects ;
insert into subjects(subjectName) values
('SQL'),
('JAVA'),
('C#'),
('VISUAL BASIC');

select * FROM marks;
INSERT INTO marks (mark, subject_id, student_id) VALUES
(8, 1, 1),
(4, 2, 1),
(7, 1, 3),
(3, 1, 4),
(5, 2, 5),
(8, 3, 3),
(1, 3, 5),
(3, 2, 4);

select * FROM classStudent;
insert into classStudent(studentId,classId) values
(1,1),
(2,1),
(3,2),
(4,2),
(5,2);
-- Hien thi danh sach tat ca cac hoc vien
select * from students;

-- Hien thi danh sach tat ca cac mon hoc
select * from subjects;

-- Tính điểm trung bình của từng sinh viên
select s.studentId,s.studentName, avg(m.mark) as avg_mark 
from students s
join marks m on s.studentId =  m.student_id 
group by s.studentId,s.studentName;

-- Tính điểm trung bình của từng sinh viên va theo tung mon hoc

select s.studentId,s.studentName,sb.subjectName, avg(m.mark) as avg_mark 
from students s
join marks m on s.studentId =  m.student_id 
join subjects sb on  m.subject_id = sb.subjectId
group by s.studentId,s.studentName,sb.subjectName;
 
 -- Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
 select sb.subjectId,sb.subjectName,s.studentName, m.mark as max_mark
 from marks m
 join subjects sb on sb.subjectId =  m.subject_id
 join students s on s.studentId = m.student_id
 where m.mark = (select max(m2.mark)
			    from marks m2
                where m2.subject_id = m.subject_id
 );
 -- Danh so thu tu cua diem theo chieu giam
 select sb.subjectName, m.mark as sort_mark
 from marks m
 join subjects sb on sb.subjectId = m.subject_id
 order by m.mark desc;
 -- Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh 7
 
 alter table subjects
 modify column subjectName varchar(255);
 -- show kieu du lieu trong  table khi dieu chinh du lieu
 describe subjects;
 
 -- 8.Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjectssubjects
 update subjects
 set subjectName = concat('Day la mon hoc', subjectName);
 select * from subjects;
 
 -- 9. Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
 
alter table students
add constraint check_age
check (age >15 and age < 50);
-- 10. Loai bo tat ca quan he giua cac bang
-- Xóa ràng buộc khóa ngoại trong bảng marks:
SHOW CREATE TABLE marks;

alter table marks
drop foreign key fk_subject;
alter table marks
drop foreign key fk_student;

-- Xóa ràng buộc khóa ngoại trong bảng classStudent:
alter table classStudent
drop foreign key fk_student_class;

alter table classStudent
drop foreign key fk_class;
SHOW CREATE TABLE classStudent;
 -- 11. Xoa hoc vien co StudentID la 1
 -- Xóa các bản ghi liên quan trong bảng marks
DELETE FROM marks WHERE student_id = 1;
select * from marks;
-- Xóa các bản ghi liên quan trong bảng classStudent
DELETE FROM classStudent WHERE studentId = 1;
select * from classStudent;
select * from students;
delete  from students
where studentId = 1;
-- 12. Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
alter table students
add column status bit default 1;
select * from students;
-- 13.Cap nhap gia tri Status trong bang Student thanh 0
update students
set status = 0;
select * from students;



