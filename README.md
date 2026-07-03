# GROUP-WORK-31756-2025-31802-2025-31543-2025-32790-2025-
## 📌 Project Overview
This project is a simple database application built using **PL/SQL (Oracle)** as part of the Group Assignment III for the course **DPR400210: Database Programming**.  
It addresses a real‑world problem: **managing student course registrations** while preventing over‑enrolment and tracking student credit loads.

The solution demonstrates core database programming concepts including:
- Window Functions
- Anonymous PL/SQL Blocks
- Stored Procedures
- User‑defined Functions

---

## 🧩 Problem Statement
Universities often struggle with manual registration processes, which can lead to:
- Courses being overfilled beyond capacity.
- Duplicate registrations.
- Difficulty in calculating total credits per student.

Our system provides an automated, relational solution that:
1. Stores student, course, and registration data.
2. Enforces seat limits using transactional logic.
3. Ranks courses by popularity.
4. Computes total credit load per student.

---

## 🗄️ Database Schema
The database consists of three main tables:

### `students`
| Column        | Type          | Description                |
|---------------|---------------|----------------------------|
| student_id    | NUMBER (PK)   | Unique student identifier  |
| first_name    | VARCHAR2(50)  | Student’s first name       |
| last_name     | VARCHAR2(50)  | Student’s last name        |
| email         | VARCHAR2(100) | Unique email address       |
| enrolled_date | DATE          | Date of enrolment          |

### `courses`
| Column          | Type          | Description                     |
|-----------------|---------------|---------------------------------|
| course_id       | NUMBER (PK)   | Unique course identifier        |
| course_name     | VARCHAR2(100) | Full course title               |
| credits         | NUMBER(2)     | Credit value of the course      |
| max_seats       | NUMBER(3)     | Maximum capacity                |
| available_seats | NUMBER(3)     | Currently free seats (denormalised for performance) |

### `registrations`
| Column            | Type          | Description                         |
|-------------------|---------------|-------------------------------------|
| registration_id   | NUMBER (PK)   | Unique registration identifier      |
| student_id        | NUMBER (FK)   | References `students(student_id)`   |
| course_id         | NUMBER (FK)   | References `courses(course_id)`     |
| registration_date | DATE          | Date of registration                |
| grade             | NUMBER(5,2)   | Final grade (nullable)              |

> **Constraint:** A unique constraint on `(student_id, course_id)` prevents duplicate registrations.

---

## 🔧 PL/SQL Implementation

### 1. Window Function – Popularity Ranking
```sql
-- Ranks courses by number of enrolled students
SELECT course_id, course_name, 
       COUNT(student_id) AS enrolled,
       RANK() OVER (ORDER BY COUNT(student_id) DESC) AS popularity_rank
FROM courses c
LEFT JOIN registrations r USING(course_id)
GROUP BY course_id, course_name;
