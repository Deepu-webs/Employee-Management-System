

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Create Account | Employee Management</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    min-height: 100vh;
    padding: 25px 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: Arial, Helvetica, sans-serif;
    background: linear-gradient(135deg, #0f172a, #1d4ed8, #6366f1);
}

.register-card {
    width: 100%;
    max-width: 460px;
    padding: 35px;
    background: #ffffff;
    border-radius: 20px;
    box-shadow: 0 20px 55px rgba(0, 0, 0, 0.25);
}

.logo {
    width: 62px;
    height: 62px;
    margin: 0 auto 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #dbeafe;
    color: #1d4ed8;
    border-radius: 18px;
    font-size: 30px;
}

h1 {
    margin: 0;
    text-align: center;
    color: #0f172a;
    font-size: 27px;
}

.subtitle {
    margin: 10px 0 25px;
    color: #64748b;
    text-align: center;
    font-size: 14px;
    line-height: 1.5;
}

label {
    display: block;
    margin: 17px 0 8px;
    color: #334155;
    font-size: 14px;
    font-weight: 600;
}

input {
    width: 100%;
    padding: 13px 14px;
    border: 1px solid #cbd5e1;
    border-radius: 9px;
    outline: none;
    font-size: 14px;
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
    border: none;
    background: transparent;
    color: #2563eb;
    font-size: 12px;
    font-weight: bold;
    cursor: pointer;
}

.hint {
    margin: 7px 0 0;
    color: #64748b;
    font-size: 12px;
}

.register-button {
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

.register-button:hover {
    background: #1d4ed8;
    transform: translateY(-1px);
}

.error {
    margin-bottom: 15px;
    padding: 12px;
    background: #fee2e2;
    color: #b91c1c;
    border: 1px solid #fecaca;
    border-radius: 8px;
    font-size: 13px;
}

.login-link {
    margin-top: 23px;
    text-align: center;
    color: #64748b;
    font-size: 14px;
}

.login-link a {
    color: #2563eb;
    font-weight: bold;
    text-decoration: none;
}

.login-link a:hover {
    text-decoration: underline;
}

.footer {
    margin-top: 24px;
    text-align: center;
    color: #94a3b8;
    font-size: 11px;
}

@media (max-width: 480px) {
    .register-card {
        padding: 27px 22px;
    }
}
</style>
</head>

<body>
<div class="register-card">

    <div class="logo" aria-hidden="true">&#128100;</div>

    <h1>Create Account</h1>
    <p class="subtitle">
        Join the Employee Management System<br>
        Fill in your details to get started.
    </p>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/register"
          method="post"
          onsubmit="return validateRegistration()">

        <label for="fullName">Full Name</label>
        <input
            type="text"
            id="fullName"
            name="fullName"
            placeholder="Enter your full name"
            maxlength="100"
            autocomplete="name"
            required>

        <label for="email">Email Address</label>
        <input
            type="email"
            id="email"
            name="email"
            placeholder="Enter your email address"
            maxlength="100"
            autocomplete="email"
            required>

        <label for="password">Create Password</label>
        <div class="password-box">
            <input
                type="password"
                id="password"
                name="password"
                placeholder="Create a strong password"
               
                maxlength="72"
                autocomplete="new-password"
                required>

            <button type="button"
                    class="toggle-password"
                    id="togglePassword"
                    onclick="togglePasswordVisibility()">
                SHOW
            </button>
        </div>

        <p class="hint">Password must contain 8–72 characters.</p>

        <button type="submit" class="register-button">
            Create Account &rarr;
        </button>
    </form>

    <div class="login-link">
        Already have an account?
        <a href="${pageContext.request.contextPath}/login.jsp">
            Sign In
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

function validateRegistration() {
    const name = document.getElementById("fullName").value.trim();
    const password = document.getElementById("password").value;

    if (name.length === 0 || name.length > 100) {
        alert("Please enter your full name (maximum 100 characters).");
        return false;
    }

    if (password.length < 8 || password.length > 72) {
        alert("Password must contain 8–72 characters.");
        return false;
    }

    return true;
}
</script>

</body>
</html>

