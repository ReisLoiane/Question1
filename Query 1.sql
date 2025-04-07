--Criando as tabelas
CREATE TABLE Students (
	Student_ID int PRIMARY KEY,
	Student_Name text NOT NULL,
    Enrolled_at date,
    Course_ID int
	)
INSERT INTO Students (Student_ID, Student_Name, Enrolled_at, Course_ID)
VALUES
(1, 'Ana', '2024-12-07', 12),
(2, 'Bernardo', '2024-11-07', 15),
(3, 'Maria', '2024-11-07', 12),
(4, 'Maia', '2024-11-15', 12),
(5, 'Fernando', '2024-12-07', 16),
(6, 'Ana B', '2024-12-05', 15),
(7, 'Cléo', '2024-11-18', 15),
(8, 'Júlio', '2024-11-15', 16),
(9, 'Pedro', '2024-11-15', 12),
(10, 'Raquel', '2024-12-01', 12),
(11, 'Carlos', '2024-11-15', 16),
(12, 'Otávio', '2024-12-01', 16),
(13, 'Luna', '2024-11-07',12),
(14, 'Aurora', '2024-11-15', 15),
(15, 'Noah','2024-11-20', 12),
(16, 'Davi', '2024-12-07',15),
(17, 'Gael', '2024-11-15', 12),
(18, 'Ravi', '2024-12-15', 15),
(19, 'Helena', '2024-11-18', 15),
(20,'Sophia', '2024-12-15', 16);

SELECT * FROM Students

CREATE TABLE Courses (
	Course_ID int primary key,
	Course_Name text,
	Price numeric(10,2),
	School_ID int
	);
	
INSERT INTO Courses (Course_ID, Course_Name, Price, School_ID)
VALUES
(12, 'Ciência de Dados', 2500.00, 10),
(15, 'Direito', 3000.00, 20),
(16, 'Estatística', 2000.00, 10);

SELECT * FROM Courses

CREATE TABLE Schools (
	School_ID int primary key,
	School_Name text
	);

INSERT INTO Schools (School_ID, School_Name)
VALUES
(10, 'Escola de Ciências Exatas'),
(20, 'Escola de Direito');

SELECT * FROM Schools

--a. Escreva uma consulta PostgreSQL para obter, por nome da escola e por dia, 
--a quantidade de alunos matriculados e o valor total das matrículas, tendo como 
--restrição os cursos que começam com a palavra “data”. Ordene o resultado do dia 
--mais recente para o mais antigo.

CREATE VIEW Q1A AS 
SELECT 
    s.School_Name AS "Nome da Escola",
    st.Enrolled_at AS "Data de Matrícula",
    COUNT(st.Student_ID) AS "Quantidade de Alunos",
    SUM(c.Price) AS "Valor Total das Matrículas"
FROM 
    Students st
JOIN 
    Courses c ON st.Course_ID = c.Course_ID
JOIN 
    Schools s ON c.School_ID = s.School_ID
WHERE 
    c.Course_Name ILIKE '%Dados%'
GROUP BY 
    s.School_Name, st.Enrolled_at
ORDER BY 
    st.Enrolled_at DESC;

SELECT * FROM Q1A

--b.Utilizando a resposta do item a, escreva uma consulta para obter, por escola e 
--por dia, a soma acumulada, a média móvel 7 dias e a média móvel 30 dias da quantidade de alunos.

CREATE VIEW Q1B
WITH daily_enrollments AS (
    SELECT 
        s.School_Name,
        st.Enrolled_at,
        COUNT(st.Student_ID) AS daily_students
    FROM 
        Students st
    JOIN 
        Courses c ON st.Course_ID = c.Course_ID
    JOIN 
        Schools s ON c.School_ID = s.School_ID
    GROUP BY 
        s.School_Name, st.Enrolled_at
)

SELECT 
    School_Name AS "Escola",
    Enrolled_at AS "Data",
    daily_students AS "Matrículas no Dia",
    SUM(daily_students) OVER (
        PARTITION BY School_Name 
        ORDER BY Enrolled_at
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS "Soma Acumulada",
    AVG(daily_students) OVER (
        PARTITION BY School_Name 
        ORDER BY Enrolled_at
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS "Média Móvel 7 Dias",
    AVG(daily_students) OVER (
        PARTITION BY School_Name 
        ORDER BY Enrolled_at
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS "Média Móvel 30 Dias"
FROM 
    daily_enrollments
ORDER BY 
    School_Name, Enrolled_at DESC;

SELECT * FROM Q1B

