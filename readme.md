# SQL Interview Notes - Subqueries, Joins & Derived Tables

> These notes are created while preparing for **Data Engineer / Data Architect / Cloud Data Engineer Interviews**.
>
> The goal is **not to memorize SQL**, but to understand the logic behind every query.

---

# Database Schema

## Table 1 - students

| Column | Data Type |
|---------|-----------|
| student_id | VARCHAR |
| name | VARCHAR |
| branch | VARCHAR |

Example Branches

- CS
- IT
- EE
- ME
- CE
- AI

---

## Table 2 - exam_scores

| Column | Data Type |
|---------|-----------|
| score_id | INT |
| student_id | VARCHAR |
| subject | VARCHAR |
| score | INT |
| exam_month | VARCHAR |

---

## Table 3 - projects

| Column | Data Type |
|---------|-----------|
| project_id | INT |
| student_id | VARCHAR |
| title | VARCHAR |
| marks | INT |

---

# SQL Logical Order of Execution

One of the most frequently asked interview questions.

Although we write SQL in one order, MySQL executes it logically in another order.

```
FROM

JOIN

ON

WHERE

GROUP BY

HAVING

SELECT

DISTINCT

ORDER BY

LIMIT
```

---

# Why Do We Use Aliases?

Instead of writing

```sql
students.student_id
```

we write

```sql
s.student_id
```

Example

```sql
FROM students s
```

Now

```sql
s.student_id
s.name
```

can be used.

## Why?

### 1. Improves Readability

Instead of

```sql
students.student_id
```

we write

```sql
s.student_id
```

---

### 2. Removes Ambiguity

Both tables may contain

```
student_id
```

Without aliases MySQL gets confused.

Example

```sql
students.student_id

exam_scores.student_id
```

Aliases solve this problem.

---

# Question 1

## Find students eligible for placement

### Placement Criteria

- At least one exam score >= 90
- At least one project marks >= 85

---

## Step 1

What do we need in the output?

```
student_id

name

branch
```

These columns exist inside

```
students
```

So our outer query starts with

```sql
FROM students s
```

---

## Step 2

Need students scoring >=90

Which table contains score?

```
exam_scores
```

Subquery

```sql
SELECT student_id
FROM exam_scores
WHERE score >=90;
```

Output

```
S101

S105

S106

S109
```

Notice

We selected

```
student_id
```

NOT score.

Because later

```
student_id

IN

student_id
```

is compared.

---

## Step 3

Need project marks >=85

```sql
SELECT student_id
FROM projects
WHERE marks>=85;
```

---

## Final Query

```sql
SELECT
    s.student_id,
    s.name,
    s.branch
FROM students s
WHERE s.student_id IN
(
    SELECT student_id
    FROM exam_scores
    WHERE score>=90
)
AND s.student_id IN
(
    SELECT student_id
    FROM projects
    WHERE marks>=85
);
```

---

# Why Use IN?

Because the subquery returns

```
Multiple Rows
```

Example

```
S101

S105

S106

S109
```

IN compares

```
One value

with

Multiple values
```

---

# Interview Questions

### Why IN instead of = ?

Because

```
=
```

works with one value only.

```
IN
```

works with multiple values.

---

### Can this be solved using JOIN?

Yes.

```sql
SELECT DISTINCT
    s.student_id,
    s.name,
    s.branch
FROM students s
JOIN exam_scores e
ON s.student_id=e.student_id
JOIN projects p
ON s.student_id=p.student_id
WHERE e.score>=90
AND p.marks>=85;
```

---

### Why DISTINCT?

One student can have

```
Math

Physics

SQL
```

Without DISTINCT

same student appears multiple times.

---

# Question 2

## Students Scoring Above Class Average

---

### Business Requirement

Print

```
Student Name

Student ID

Subject

Score
```

where

```
Student Score

>

Class Average
```

---

## Step 1

Need Name

```
students
```

Need Score

```
exam_scores
```

Therefore

Need JOIN.

---

## Step 2

Need Average Score

Average is not stored inside any table.

It must be calculated.

```sql
SELECT AVG(score)
FROM exam_scores;
```

Suppose output

```
84.7
```

---

## Final Query

```sql
SELECT
    s.name,
    s.student_id,
    e.subject,
    e.score
FROM students s
JOIN exam_scores e
ON s.student_id=e.student_id
WHERE e.score >
(
    SELECT AVG(score)
    FROM exam_scores
);
```

---

# Why Use Subquery?

Because

```
Average

must be calculated first.

Then

each student's score

is compared with it.
```

---

# Interview Questions

### Can this be solved using JOIN?

No.

JOIN combines tables.

Average is a calculated value.

Need

- Subquery

or

- Window Function

---

### Window Function Solution

```sql
SELECT *
FROM
(
SELECT *,
AVG(score) OVER() class_avg
FROM exam_scores
)t
WHERE score>class_avg;
```

---

# Question 3

## Placement using JOIN

```sql
SELECT
    s.name,
    e.score,
    p.marks
FROM students s
JOIN exam_scores e
ON s.student_id=e.student_id
JOIN projects p
ON s.student_id=p.student_id
WHERE e.score>=90
AND p.marks>=85;
```

---

# Why Three Joins?

Need

```
Name

↓

students

Score

↓

exam_scores

Marks

↓

projects
```

Need columns from all three tables.

Therefore

Need three-table JOIN.

---

# Interview Questions

### Why INNER JOIN?

Because

Only matching students are required.

---

### Can duplicates occur?

Yes.

Suppose

Student has

```
Math

Physics

SQL
```

One project

Result

```
3 Rows
```

Need

```
DISTINCT

or

GROUP BY
```

depending upon business requirement.

---

# Question 4

## Total Score & Number of Exams

Business Requirement

Display

- Student Name
- Branch
- Total Score
- Number of Exams Attempted

---

## Inner Query

```sql
SELECT
    student_id,
    SUM(score) total_score,
    COUNT(*) no_of_attempts
FROM exam_scores
GROUP BY student_id;
```

Output

|student_id|total_score|no_of_attempts|

This is a temporary result.

---

## Outer Query

```sql
SELECT
    s.name,
    s.branch,
    total_stats.total_score,
    total_stats.no_of_attempts
FROM
(
    SELECT
        student_id,
        SUM(score) total_score,
        COUNT(*) no_of_attempts
    FROM exam_scores
    GROUP BY student_id
) total_stats
JOIN students s
ON s.student_id=total_stats.student_id;
```

---

# What is total_stats?

```
Derived Table
```

A derived table is simply

```
Subquery inside FROM clause.
```

It behaves like a temporary table.

---

# Interview Questions

### Can this be solved using CTE?

Yes.

```sql
WITH total_stats AS
(
SELECT
    student_id,
    SUM(score) total_score,
    COUNT(*) no_of_attempts
FROM exam_scores
GROUP BY student_id
)

SELECT
    s.name,
    s.branch,
    total_stats.total_score,
    total_stats.no_of_attempts
FROM students s
JOIN total_stats
ON s.student_id=total_stats.student_id;
```

---

# Types of Subqueries

## 1. Scalar Subquery

Returns

```
One Row

One Column
```

Example

```sql
SELECT AVG(score)
FROM exam_scores;
```

---

## 2. Multi Row Subquery

Returns

```
Multiple Rows
```

Example

```sql
SELECT student_id
FROM exam_scores
WHERE score>=90;
```

Usually used with

- IN
- ANY
- ALL

---

## 3. Correlated Subquery

The inner query depends on the outer query.

Example

Find students scoring above their own branch average.

---

## 4. Derived Table

Subquery inside

```sql
FROM
```

Example

```sql
FROM
(
SELECT ...
) total_stats
```

---

# Common Interview Questions

### Difference between WHERE and HAVING?

WHERE filters rows.

HAVING filters groups.

---

### Difference between JOIN and Subquery?

JOIN combines tables.

Subquery generates data used by another query.

---

### Difference between IN and EXISTS?

IN compares values.

EXISTS checks whether matching rows exist.

---

### Can every Subquery be replaced by Window Function?

No.

Many aggregate-based subqueries can.

EXISTS, NOT EXISTS, IN and many correlated subqueries cannot always be replaced.

---

# Learning Strategy

Instead of memorizing SQL syntax

Follow this process

```
Read Question

↓

Write Pseudo Code

↓

Identify Required Columns

↓

Identify Required Tables

↓

Find Relationship

↓

Write SQL

↓

Execute

↓

Debug Errors

↓

Optimize
```

---

# Final Advice

The goal is not to memorize queries.

The goal is to understand

- Why JOIN?
- Why GROUP BY?
- Why Subquery?
- Why Aggregate?
- Why Derived Table?

Once the logic becomes clear,

writing SQL becomes much easier.

---

## Author

**Gurmukh Singh**

Preparing for

- Data Engineer
- Senior Data Engineer
- Data Architect
- Cloud Data Engineer Interviews

