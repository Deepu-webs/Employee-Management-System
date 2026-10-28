
<%@ page import="com.jdbcapp.model.Employee" %>
<%
    Employee e = (Employee) request.getAttribute("employee");
    boolean edit = e != null;
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%= edit ? "Edit Employee" : "Add Employee" %></title>
<style>
* { box-sizing: border-box; }
body {
    margin: 0; font-family: Arial, sans-serif;
    background: #f1f5f9; color: #1e293b;
}
.container {
    max-width: 650px; margin: 40px auto; padding: 30px;
    background: white; border-radius: 14px;
    box-shadow: 0 8px 25px rgba(0,0,0,.08);
}
h2 { margin-top: 0; color: #0f172a; }
.subtitle { color: #64748b; margin-bottom: 25px; }
label { display: block; margin: 16px 0 7px; font-weight: 600; }
input {
    width: 100%; padding: 12px; border: 1px solid #cbd5e1;
    border-radius: 7px; font-size: 15px;
}
input:focus {
    outline: 2px solid #93c5fd; border-color: #2563eb;
}
button, .cancel {
    display: inline-block; padding: 11px 18px; border: none;
    border-radius: 7px; font-weight: 600; cursor: pointer;
    text-decoration: none; font-size: 14px;
}
.save { background: #2563eb; color: white; margin-top: 24px; }
.cancel { background: #e2e8f0; color: #334155; margin-top: 24px; }
.error {
    background: #fee2e2; color: #991b1b;
    padding: 12px; border-radius: 7px;
}
.hint { color: #64748b; font-size: 12px; margin-top: 5px; }
</style>
</head>
<body>
<div class="container">
    <h2><%= edit ? "Edit Employee" : "Add New Employee" %></h2>
    <p class="subtitle">Enter the employee details below.</p>

    <% if (error != null) { %>
        <p class="error"><%= error %></p>
    <% } %>

    <form action="${pageContext.request.contextPath}/employees"
          method="post" onsubmit="return validateForm()">
        <input type="hidden" name="action" value="save">
        <input type="hidden" name="mode" value="<%= edit ? "update" : "insert" %>">

        <% if (edit) { %>
            <input type="hidden" name="employeeId" value="<%= e.getEmployeeId() %>">
            <p><strong>Employee ID:</strong> <%= e.getEmployeeId() %></p>
        <% } %>

        <label for="name">Employee Name</label>
        <input id="name" name="name" required maxlength="100"
               value="<%= edit ? e.getName() : "" %>"
               pattern="[A-Za-z][A-Za-z .'-]{0,99}"
               title="Enter a valid name using letters and spaces.">

        <label for="salary">Salary</label>
        <input id="salary" name="salary" type="number"
               min="0.01" step="0.01" required
               value="<%= edit ? e.getSalary() : "" %>">

        <label for="department">Department</label>
        <input id="department" name="department" required maxlength="100"
               value="<%= edit ? e.getDepartment() : "" %>"
               pattern="[A-Za-z][A-Za-z &-]{0,99}"
               title="Department must contain letters, spaces, ampersands or hyphens, not numbers.">
        <p class="hint">Letters, spaces, &amp; and hyphens only.</p>

        <label for="city">City</label>
        <input id="city" name="city" required maxlength="50"
               value="<%= edit ? e.getCity() : "" %>"
               pattern="[A-Za-z][A-Za-z ]{1,49}"
               title="City must contain letters and spaces only.">
        <p class="hint">Letters and spaces only.</p>

        <label for="mobile">Mobile Number</label>
        <input id="mobile" name="mobile" type="text"
               inputmode="numeric" maxlength="10"
               pattern="[0-9]{10}" required
               value="<%= edit ? e.getMobile() : "" %>"
               title="Enter exactly 10 digits.">

        <button class="save" type="submit">
            <%= edit ? "Update Employee" : "Save Employee" %>
        </button>
        <a class="cancel" href="${pageContext.request.contextPath}/employees">Cancel</a>
    </form>
</div>

<script>
function validateForm() {
    const department = document.getElementById("department").value.trim();
    const city = document.getElementById("city").value.trim();

    if (!/^[A-Za-z][A-Za-z &-]{0,99}$/.test(department)) {
        alert("Department cannot contain numbers or special characters other than & and hyphens.");
        return false;
    }
    if (!/^[A-Za-z][A-Za-z ]{1,49}$/.test(city)) {
        alert("City must contain letters and spaces only.");
        return false;
    }
    return true;
}

// Block numeric keystrokes in department and city fields.
["department", "city"].forEach(function(id) {
    document.getElementById(id).addEventListener("input", function() {
        const pattern = id === "city" ? /[^A-Za-z ]/g : /[^A-Za-z &-]/g;
        this.value = this.value.replace(pattern, "");
    });
});
</script>
</body>
</html>
