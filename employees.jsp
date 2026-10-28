
<%@ page import="java.util.List" %>
<%@ page import="com.jdbcapp.model.Employee" %>

<%
    @SuppressWarnings("unchecked")
    List<Employee> employees =
        (List<Employee>) request.getAttribute("employees");

    String userName = (String) session.getAttribute("userName");
    String error = (String) request.getAttribute("error");
    String searchMessage = (String) request.getAttribute("searchMessage");
    String algorithmName = (String) request.getAttribute("algorithmName");
    String ctx = request.getContextPath();

    String searchId = request.getParameter("searchId");
    String selectedAlgorithm = request.getParameter("algorithm");

    if (selectedAlgorithm == null) {
        selectedAlgorithm = "linear";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Employee Management</title>

<style>
* { box-sizing: border-box; }

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f1f5f9;
    color: #1e293b;
}

.header {
    background: #0f172a;
    color: white;
    padding: 20px 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
}

.header h2 { margin: 0; }

.header a {
    color: white;
    text-decoration: none;
}

.logout {
    background: #475569;
    padding: 9px 14px;
    border-radius: 6px;
}

.container {
    max-width: 1500px;
    margin: 35px auto;
    padding: 0 20px;
}

.toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 20px;
}

.toolbar h2 { margin: 0 0 6px; }

.muted { color: #64748b; }

.add {
    background: #2563eb;
    color: white;
    padding: 11px 16px;
    text-decoration: none;
    border-radius: 7px;
    font-weight: bold;
}

.search-card {
    background: white;
    padding: 20px;
    border-radius: 12px;
    margin-bottom: 20px;
    box-shadow: 0 5px 20px rgba(15,23,42,.06);
}

.search-card h3 {
    margin-top: 0;
    margin-bottom: 15px;
}

.search-form {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    align-items: center;
}

.search-form input,
.search-form select {
    padding: 12px;
    border: 1px solid #cbd5e1;
    border-radius: 7px;
    font-size: 15px;
}

.search-form input {
    flex: 1;
    min-width: 180px;
}

.search-form select {
    min-width: 170px;
    background: white;
}

.btn {
    display: inline-block;
    padding: 10px 15px;
    border: none;
    border-radius: 6px;
    color: white;
    text-decoration: none;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
}

.search-btn { background: #2563eb; }
.show-all { background: #475569; }

.table-card {
    background: white;
    border-radius: 12px;
    overflow-x: auto;
    box-shadow: 0 5px 20px rgba(15,23,42,.06);
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 800px;
}

th, td {
    padding: 15px 13px;
    text-align: left;
    border-bottom: 1px solid #e2e8f0;
}

th {
    background: #eaf0f8;
    color: #334155;
    font-size: 13px;
}

tbody tr:hover { background: #f8fafc; }

.edit { background: #16a34a; }
.delete { background: #dc2626; }

.actions {
    display: flex;
    align-items: center;
    gap: 8px;
}

.actions form { margin: 0; }

.alert {
    padding: 12px;
    background: #fee2e2;
    color: #991b1b;
    border-radius: 7px;
    margin-bottom: 15px;
}

.success {
    padding: 12px;
    background: #dcfce7;
    color: #166534;
    border-radius: 7px;
    margin-bottom: 15px;
}

.empty {
    text-align: center;
    padding: 35px;
    color: #64748b;
}

@media (max-width: 600px) {
    .container { padding: 0 12px; }
    .search-form { flex-direction: column; align-items: stretch; }
    .search-form input,
    .search-form select,
    .search-form button,
    .search-form a { width: 100%; text-align: center; }
}
</style>
</head>

<body>

<header class="header">
    <h2>Employee Management</h2>

    <div>
        Welcome,
        <strong><%= userName == null ? "User" : userName %></strong>
        &nbsp;&nbsp;
        <a class="logout" href="<%= ctx %>/logout">Logout</a>
    </div>
</header>

<main class="container">

    <div class="toolbar">
        <div>
            <h2>Employees</h2>
            <span class="muted">Manage your employee records</span>
        </div>

        <a class="add" href="<%= ctx %>/employees?action=new">
            + Add Employee
        </a>
    </div>

    <!-- Employee Search: DAA Module -->
    <div class="search-card">
        <h3>Employee Search - DAA Algorithms</h3>

        <form class="search-form"
              action="<%= ctx %>/employees"
              method="get">

            <input type="hidden" name="action" value="search">

            <input type="number"
                   name="searchId"
                   min="1"
                   placeholder="Enter Employee ID"
                   value="<%= searchId == null ? "" : searchId %>"
                   required>

            <select name="algorithm">
                <option value="linear"
                    <%= "linear".equals(selectedAlgorithm) ? "selected" : "" %>>
                    Linear Search
                </option>

                <option value="binary"
                    <%= "binary".equals(selectedAlgorithm) ? "selected" : "" %>>
                    Binary Search
                </option>
            </select>

            <button class="btn search-btn" type="submit">
                Search Employee
            </button>

            <a class="btn show-all" href="<%= ctx %>/employees">
                Show All
            </a>
        </form>
    </div>

    <% if (error != null) { %>
        <div class="alert"><%= error %></div>
    <% } %>

    <% if (searchMessage != null) { %>
        <div class="success">
            <%= searchMessage %>

            <% if (algorithmName != null) { %>
                | Algorithm: <%= algorithmName %>
            <% } %>
        </div>
    <% } %>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Salary</th>
                    <th>Department</th>
                    <th>City</th>
                    <th>Mobile</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
            <% if (employees != null && !employees.isEmpty()) {
                   for (Employee emp : employees) { %>

                <tr>
                    <td><%= emp.getEmployeeId() %></td>
                    <td><%= emp.getName() %></td>
                    <td><%= emp.getSalary() %></td>
                    <td><%= emp.getDepartment() %></td>
                    <td><%= emp.getCity() %></td>
                    <td><%= emp.getMobile() %></td>

                    <td>
                        <div class="actions">

                            <a class="btn edit"
                               href="<%= ctx %>/employees?action=edit&id=<%= emp.getEmployeeId() %>">
                                Edit
                            </a>

                            <form action="<%= ctx %>/employees"
                                  method="post"
                                  onsubmit="return confirm('Are you sure you want to delete this employee?');">

                                <input type="hidden"
                                       name="action"
                                       value="delete">

                                <input type="hidden"
                                       name="employeeId"
                                       value="<%= emp.getEmployeeId() %>">

                                <button class="btn delete" type="submit">
                                    Delete
                                </button>
                            </form>

                        </div>
                    </td>
                </tr>

            <%   }
               } else { %>

                <tr>
                    <td colspan="7" class="empty">
                        <% if (searchMessage != null) { %>
                            No matching employee found.
                        <% } else { %>
                            No employees found. Click Add Employee to create your first record.
                        <% } %>
                    </td>
                </tr>

            <% } %>
            </tbody>
        </table>
    </div>

</main>
</body>
</html>
