
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Login | Employee Management</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    min-height: 100vh;
    font-family: Arial, Helvetica, sans-serif;
    background: linear-gradient(135deg, #0f172a, #1d4ed8, #6366f1);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.login-card {
    width: 100%;
    max-width: 420px;
    background: #ffffff;
    padding: 38px;
    border-radius: 20px;
    box-shadow: 0 20px 55px rgba(0, 0, 0, 0.25);
}

.logo {
    width: 65px;
    height: 65px;
    margin: 0 auto 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #dbeafe;
    color: #1d4ed8;
    border-radius: 18px;
    font-size: 30px;
    font-weight: bold;
}

h1 {
    margin: 0;
    text-align: center;
    color: #0f172a;
    font-size: 27px;
}

.subtitle {
    text-align: center;
    color: #64748b;
    font-size: 14px;
    margin: 10px 0 28px;
    line-height: 1.5;
}

label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #334155;
    margin: 18px 0 8px;
}

input {
    width: 100%;
    padding: 13px 14px;
    border: 1px solid #cbd5e1;
    border-radius: 9px;
    font-size: 15px;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
}

input:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.13);
}

.password-box {
    position: relative;
}

.password-box input {
    padding-right: 65px;
}

.toggle-password {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: #2563eb;
    font-size: 12px;
    font-weight: bold;
    cursor: pointer;
}

.login-button {
    width: 100%;
    margin-top: 25px;
    padding: 14px;
    border: none;
    border-radius: 9px;
    background: #2563eb;
    color: white;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: background 0.2s, transform 0.2s;
}

.login-button:hover {
    background: #1d4ed8;
    transform: translateY(-1px);
}

.error {
    padding: 12px;
    background: #fee2e2;
    color: #b91c1c;
    border: 1px solid #fecaca;
    border-radius: 8px;
    font-size: 13px;
    margin-bottom: 15px;
}

.success {
    padding: 12px;
    background: #dcfce7;
    color: #166534;
    border-radius: 8px;
    font-size: 13px;
    margin-bottom: 15px;
}

.register-link {
    margin-top: 23px;
    text-align: center;
    color: #64748b;
    font-size: 14px;
}

.register-link a {
    color: #2563eb;
    font-weight: bold;
    text-decoration: none;
}

.register-link a:hover {
    text-decoration: underline;
}

.footer {
    margin-top: 25px;
    text-align: center;
    font-size: 11px;
    color: #94a3b8;
}

@media (max-width: 480px) {
    .login-card {
        padding: 27px 22px;
    }
}
</style>
</head>

<body>
<div class="login-card">

    <div class="logo" aria-hidden="true">&#128100;</div>

    <h1>Welcome Back!</h1>
    <p class="subtitle">
        Sign in to access your<br>
        Employee Management System
    </p>

    <% if ("1".equals(request.getParameter("registered"))) { %>
        <div class="success">
            Registration successful! Please log in.
        </div>
    <% } %>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login"
          method="post">

        <label for="email">Email Address</label>
        <input
            type="email"
            id="email"
            name="email"
            placeholder="Enter your email address"
            maxlength="100"
            autocomplete="email"
            required>

        <label for="password">Password</label>
        <div class="password-box">
            <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter your password"
                autocomplete="current-password"
                required>

            <button type="button"
                    class="toggle-password"
                    id="togglePassword"
                    onclick="togglePasswordVisibility()">
                SHOW
            </button>
        </div>

        <button type="submit" class="login-button">
            Sign In &rarr;
        </button>
    </form>

    <div class="register-link">
        Don't have an account?
        <a href="${pageContext.request.contextPath}/register.jsp">
            Create Account
        </a>
    </div>

    <div class="footer">
        EMPLOYEE MANAGEMENT SYSTEM
    </div>
</div>

<script>
function togglePasswordVisibility() {
    const password = document.getElementById("password");
    const button = document.getElementById("togglePassword");

    if (password.type === "password") {
        password.type = "text";
        button.textContent = "HIDE";
    } else {
        password.type = "password";
        button.textContent = "SHOW";
    }
}
</script>

</body>
</html>
