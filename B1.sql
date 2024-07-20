create table Sudents(
StudentID int primary key auto_increment,
StudentName varchar(50),
Age int,
Email varchar(100)
);

create table Subjects(
SubjectID int primary key auto_increment,
SubjectName varchar(50)
);

create table Classes(
ClassID int primary key auto_increment,
ClassName varchar(50)
);

create table Marks(
Mark int,
SubjectID int,
StudentID int,
primary key (SubjectID,StudentID),
foreign key (SubjectID) references Subjects(SubjectID),
foreign key (StudentID) references Sudents(StudentID)
);

create table ClassStudent(
StudentID int,
ClassID int,
primary key(StudentID,ClassID),
foreign key (StudentID) references Sudents(StudentID),
foreign key (ClassID) references Classes(ClassID)
);

insert into Sudents(StudentName,Age,Email) values
('Nguyen Quang An', 18, 'an@yahoo.com'),
('Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
('Nguyen Van Quyen', 19, 'quyen@yahoo.com'),
('Pham Thanh Binh', 25, 'binh@gmail.com'),
('Nguyen Van Tai Em', 30, 'taiem@sport.com');

insert into Classes(ClassName) values
('C0706L'),('C0708G');

insert into ClassStudent(StudentID,ClassID) values
(1,1),(2,1),(3,2),(4,2),(5,2);

insert into Subjects(SubjectID,SubjectName) values
(1,'SQL'),
(2,'Java'),
(3,'C'),
(4,'Visual Basic');

insert into Marks(Mark,SubjectID,StudentID) values (3,2,4);

-- Hien thi danh sach tat ca cac hoc vien
select * from Sudents;

-- Hien thi danh sach tat ca cac mon hoc
select * from Subjects;

-- Tinh diem trung binh
select Subjects.SubjectName,  avg(Marks.Mark) from Marks 
join Sudents on Sudents.StudentID = Marks.StudentID
join Subjects on Subjects.SubjectID = Marks.SubjectID
group by Subjects.SubjectName;

-- Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
select Sudents.StudentName, Subjects.SubjectName, Marks.Mark from Sudents
join Marks on Marks.StudentID = Sudents.StudentID
join Subjects on Subjects.SubjectID = Marks.SubjectID
group by Sudents.StudentName, Subjects.SubjectName, Marks.Mark
order by Marks.Mark desc;

-- Danh so thu tu cua diem theo chieu giam
select Subjects.SubjectName, Marks.Mark from marks
join Subjects on Subjects.SubjectID;

-- Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh 7
alter table Subjects
MODIFY column SubjectName varchar(255);

describe Subjects;

select * from Subjects;

-- Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
UPDATE Subjects
SET SubjectName = CONCAT('Day la mon hoc ', SubjectName);

-- Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
alter table Sudents
add constraint chk_age
check (Age >15 and Age < 50);
-- check insert age 13
insert into sudents(StudentName,Age,Email) values
('Konta',13,'konta@gmail.com');

describe Sudents;

-- Loai bo tat ca quan he giua cac bang
alter table marks drop foreign key SubjectID;

-- delete student with id 1
select * from Sudents;

delete from Sudents where Sudents.StudentID = 1;

-- them 1 truong status trong student table default =1
alter table Sudents
add column status bit default 1;

-- Cap nhap gia tri Status trong bang Student thanh 0
update Sudents
set status = 0; 