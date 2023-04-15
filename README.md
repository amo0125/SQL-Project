<h1>SQL Exercise</h1>

<p>Welcome to my SQL exercise! This exercise is designed to test your SQL skills and help you improve your ability to write queries.</p>

<h2>Instructions</h2>

<ol>
  <li>Download the file <code>exercise.sql</code> from the repository.</li>
  <li>Open the file in a SQL editor or command line tool, such as MySQL or PostgreSQL.</li>
  <li>Complete the exercises by writing SQL queries to extract the requested information.</li>
  <li>Save your queries to a new file.</li>
  <li>Upload your file to the repository or send it to the instructor.</li>
</ol>

<h2>Exercises</h2>

<p>Each exercise consists of a description of the requested information and a set of sample data. Your task is to write a SQL query that extracts the requested information from the data. Good luck!</p>

<h3>Exercise 1: Selecting Data</h3>

<p>Write a query that selects the name and age of all users from the <code>users</code> table:</p>

<pre><code>SELECT name, age
FROM users;
</code></pre>

<h3>Exercise 2: Filtering Data</h3>

<p>Write a query that selects the name and email of all users from the <code>users</code> table who have an age greater than 30:</p>

<pre><code>SELECT name, email
FROM users
WHERE age &gt; 30;
</code></pre>

<h3>Exercise 3: Joining Tables</h3>

<p>Write a query that selects the name and title of all employees and their corresponding departments from the <code>employees</code> and <code>departments</code> tables:</p>

<pre><code>SELECT employees.name, departments.title
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;
</code></pre>
