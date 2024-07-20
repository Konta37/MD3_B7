create database student_test_data ;
use student_test_data;

create table test(
testID int primary key auto_increment,
Name varchar(255)
);

create table Student(
RN int primary key auto_increment,
Name varchar(255),
Age int,
Status bit default 1
);

create table StudentTest (
RN int,
TestID int,
Date date,
Mark double,

primary key (RN, TestID),
foreign key (RN) references Student(RN),
foreign key (TestID) references test(testID)
);

insert into Student (Name, Age) values
('Nguyen Hong Ha', 20),
('Truong Ngoc Anh',30),
('Tuan Minh',25),
('Dan Truong',22);

insert into Test(Name) values
('EPC'),
('DWMX'),
('SQL1'),
('SQL2');

INSERT INTO StudentTest (RN, TestID, Date, Mark) VALUES 
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 3, '2006-07-18', 1);

-- Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng
alter table Student
add constraint chk_age
check (Age >15 and Age < 55);

-- Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
update Student
set status = 0; 

-- Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
alter table Student
modify name varchar(255) unique;

-- Xóa ràng buộc duy nhất (unique) trên bảng Test
alter table Student
modify name varchar(255);

-- Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi
select student.name as 'Student Name',test.name as 'Test Name',  StudentTest.Mark, StudentTest.Date from StudentTest
join student on student.RN = StudentTest.RN
join test on test.testID = StudentTest.testID;

-- Hiển thị danh sách các bạn học viên chưa thi môn nào
select * from student
where RN not in (select distinct RN from StudentTest);

--  Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5) như sau
select student.name as 'Student Name', test.name as 'Test Name', StudentTest.Mark, StudentTest.Date from StudentTest
join student on student.RN = StudentTest.RN
join test on test.testID = StudentTest.testID
where StudentTest.Mark < 5
order by StudentTest.Mark desc;

-- Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi
select student.name as 'Student Name', avg(StudentTest.Mark) as 'Average' from StudentTest
join student on student.RN = StudentTest.RN
group by student.name
order by avg(StudentTest.Mark) desc;

-- Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau
SELECT student.name AS 'Student Name', AVG(StudentTest.Mark) AS 'Average Mark'
FROM StudentTest
JOIN Student ON Student.RN = StudentTest.RN
GROUP BY student.name
HAVING AVG(StudentTest.Mark) = (
    SELECT MAX(avg_mark)
    FROM (
        SELECT AVG(StudentTest.Mark) AS avg_mark
        FROM StudentTest
        GROUP BY RN
    ) AS avg_marks
);

-- Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học như sau
select test.name as 'Test Name', max(StudentTest.Mark) from StudentTest
join test on test.testID = StudentTest.testID
group by test.name;

-- Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null 
select student.name AS 'Student Name', test.name as 'Test Name' from Student
left join StudentTest on student.RN = StudentTest.RN
left join test on test.testID = StudentTest.testID;

select * from student;


--  Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi
SET SQL_SAFE_UPDATES = 0;
update student
set age = age +1;

-- Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student
alter table student
add column status_var varchar(10);

-- Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student lên
update student
set status_var = 'young' where age <30;
update student
set status_var = 'Old' where age >=30;

-- Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi như sau
select student.name as 'Student Name', test.name as 'Test Name', studentTest.mark, studentTest.Date from studentTest
join student on student.RN = StudentTest.RN
join test on test.testID = StudentTest.testID
order by studentTest.Date;

-- Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5. Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
select student.name as 'Student Name',student.age, avg(studentTest.mark) from studentTest
join student on student.RN = studentTest.RN
where student.name like 'T%' 
group by student.name
having
avg(studentTest.mark) >= 4.5;

-- Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng). Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1
SELECT 
    Student.RN AS 'Student ID',
    Student.name AS 'Student Name',
    Student.Age,
    AVG(StudentTest.Mark) AS 'Average Mark',
    RANK() OVER (ORDER BY AVG(StudentTest.Mark) DESC) AS 'Rank'
FROM 
    StudentTest
JOIN 
    Student ON Student.RN = StudentTest.RN
GROUP BY 
    Student.RN, Student.name, Student.Age
ORDER BY 
    'Rank';