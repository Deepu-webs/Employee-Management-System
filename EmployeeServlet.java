
package com.jdbcapp.servlet;

import com.jdbcapp.model.Employee;
import com.jdbcapp.util.DBConnection;
import com.jdbcapp.algorithm.SearchAlgorithms;
import com.jdbcapp.util.SortAlgorithms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/employees")
public class EmployeeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean checkLogin(HttpServletRequest request,
                               HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkLogin(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if ("new".equals(action)) {
            request.getRequestDispatcher("/employee-form.jsp")
                   .forward(request, response);

        } else if ("edit".equals(action)) {
            editEmployee(request, response);

        } else if ("search".equals(action)) {
            searchEmployees(request, response);

        } else if ("sort".equals(action)) {
            sortEmployees(request, response);

        } else {
            listEmployees(request, response);
        }
    }

    // SEARCH USING LINEAR OR BINARY SEARCH
    private void searchEmployees(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        List<Employee> employees = new ArrayList<>();
        String searchId = request.getParameter("searchId");

        try {
            if (searchId == null || !searchId.matches("[1-9][0-9]*")) {
                throw new NumberFormatException();
            }

            int target = Integer.parseInt(searchId);

            String sql = "SELECT * FROM employees ORDER BY employee_id";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Employee e = new Employee();

                    e.setEmployeeId(rs.getInt("employee_id"));
                    e.setName(rs.getString("name"));
                    e.setSalary(rs.getDouble("salary"));
                    e.setDepartment(rs.getString("department"));
                    e.setCity(rs.getString("city"));
                    e.setMobile(rs.getString("mobile"));

                    employees.add(e);
                }
            }

            int[] ids = new int[employees.size()];

            for (int i = 0; i < employees.size(); i++) {
                ids[i] = employees.get(i).getEmployeeId();
            }

            String algorithm = request.getParameter("algorithm");
            int index;

            if ("binary".equals(algorithm)) {
                index = SearchAlgorithms.binarySearch(ids, target);
                request.setAttribute("algorithmName", "Binary Search");
            } else {
                index = SearchAlgorithms.linearSearch(ids, target);
                request.setAttribute("algorithmName", "Linear Search");
            }

            if (index >= 0) {
                Employee found = employees.get(index);
                employees.clear();
                employees.add(found);

                request.setAttribute("searchMessage",
                        "Employee found successfully.");
            } else {
                employees.clear();

                request.setAttribute("searchMessage",
                        "No employee found with ID " + target + ".");
            }

        } catch (NumberFormatException e) {
            employees.clear();
            request.setAttribute("error",
                    "Please enter a valid positive Employee ID.");

        } catch (SQLException e) {
            log("Employee search failed", e);
            employees.clear();
            request.setAttribute("error",
                    "Unable to search employees. Please try again.");
        }

        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/employees.jsp")
               .forward(request, response);
    }

    // SORT EMPLOYEES USING MERGE SORT OR QUICK SORT
    private void sortEmployees(HttpServletRequest request,
                               HttpServletResponse response)
            throws ServletException, IOException {

        List<Employee> employees = new ArrayList<>();

        String algorithm = request.getParameter("algorithm");
        String order = request.getParameter("order");

        String sql = "SELECT * FROM employees";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Employee e = new Employee();

                e.setEmployeeId(rs.getInt("employee_id"));
                e.setName(rs.getString("name"));
                e.setSalary(rs.getDouble("salary"));
                e.setDepartment(rs.getString("department"));
                e.setCity(rs.getString("city"));
                e.setMobile(rs.getString("mobile"));

                employees.add(e);
            }

            if ("quick".equals(algorithm)) {
                employees = SortAlgorithms.quickSortBySalary(employees);
                request.setAttribute("algorithmName", "Quick Sort");
            } else {
                employees = SortAlgorithms.mergeSortBySalary(employees);
                request.setAttribute("algorithmName", "Merge Sort");
            }

            if ("desc".equals(order)) {
                employees = SortAlgorithms.descending(employees);
            }

            request.setAttribute("sortMessage",
                    "Employees sorted successfully.");

        } catch (SQLException e) {
            log("Employee sorting failed", e);
            request.setAttribute("error",
                    "Unable to sort employee records.");
        }

        request.setAttribute("employees", employees);

        request.getRequestDispatcher("/employees.jsp")
               .forward(request, response);
    }

    // SAVE OR DELETE
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkLogin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteEmployee(request, response);

        } else if ("save".equals(action)) {
            saveEmployee(request, response);

        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // EDIT EMPLOYEE
    private void editEmployee(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            if (id <= 0) {
                throw new NumberFormatException();
            }

            String sql = "SELECT * FROM employees WHERE employee_id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Employee e = new Employee();

                        e.setEmployeeId(rs.getInt("employee_id"));
                        e.setName(rs.getString("name"));
                        e.setSalary(rs.getDouble("salary"));
                        e.setDepartment(rs.getString("department"));
                        e.setCity(rs.getString("city"));
                        e.setMobile(rs.getString("mobile"));

                        request.setAttribute("employee", e);
                    } else {
                        request.setAttribute("error",
                                "Employee record not found.");
                    }
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid employee ID.");

        } catch (SQLException e) {
            log("Unable to retrieve employee", e);
            request.setAttribute("error",
                    "Unable to retrieve employee.");
        }

        request.getRequestDispatcher("/employee-form.jsp")
               .forward(request, response);
    }

    // DISPLAY ALL EMPLOYEES
    private void listEmployees(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        List<Employee> employees = new ArrayList<>();

        String sql = "SELECT * FROM employees ORDER BY employee_id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Employee e = new Employee();

                e.setEmployeeId(rs.getInt("employee_id"));
                e.setName(rs.getString("name"));
                e.setSalary(rs.getDouble("salary"));
                e.setDepartment(rs.getString("department"));
                e.setCity(rs.getString("city"));
                e.setMobile(rs.getString("mobile"));

                employees.add(e);
            }

            request.setAttribute("employees", employees);

        } catch (SQLException e) {
            log("Unable to retrieve employee records", e);
            request.setAttribute("error",
                    "Unable to retrieve employee records.");
        }

        request.getRequestDispatcher("/employees.jsp")
               .forward(request, response);
    }

    // ADD OR UPDATE EMPLOYEE
    private void saveEmployee(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        String mode = request.getParameter("mode");
        boolean update = "update".equals(mode);

        String name = request.getParameter("name");
        String salaryText = request.getParameter("salary");
        String department = request.getParameter("department");
        String city = request.getParameter("city");
        String mobile = request.getParameter("mobile");

        int id = 0;
        double salary;

        try {
            if (update) {
                id = Integer.parseInt(request.getParameter("employeeId"));

                if (id <= 0) {
                    throw new NumberFormatException();
                }
            }

            salary = Double.parseDouble(salaryText);

        } catch (NumberFormatException | NullPointerException e) {
            request.setAttribute("error",
                    "Enter a valid employee ID and salary.");

            request.getRequestDispatcher("/employee-form.jsp")
                   .forward(request, response);
            return;
        }

        if (name == null || name.isBlank() || name.length() > 100
                || !Double.isFinite(salary) || salary <= 0
                || department == null
                || !department.trim().matches("[A-Za-z][A-Za-z &-]{0,99}")
                || city == null
                || !city.trim().matches("[A-Za-z][A-Za-z ]{1,49}")
                || mobile == null
                || !mobile.matches("\\d{10}")) {

            request.setAttribute("error",
                    "Please enter valid employee details.");

            request.getRequestDispatcher("/employee-form.jsp")
                   .forward(request, response);
            return;
        }

        String sql;

        if (update) {
            sql = "UPDATE employees SET name=?, salary=?, department=?, "
                + "city=?, mobile=? WHERE employee_id=?";
        } else {
            sql = "INSERT INTO employees "
                + "(name, salary, department, city, mobile) "
                + "VALUES(?,?,?,?,?)";
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setDouble(2, salary);
            ps.setString(3, department.trim());
            ps.setString(4, city.trim());
            ps.setString(5, mobile);

            if (update) {
                ps.setInt(6, id);

                if (ps.executeUpdate() == 0) {
                    request.setAttribute("error",
                            "Employee record not found.");
                    listEmployees(request, response);
                    return;
                }
            } else {
                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/employees");

        } catch (SQLException e) {
            log("Unable to save employee", e);
            request.setAttribute("error",
                    "Unable to save employee. Please check the database.");

            request.getRequestDispatcher("/employee-form.jsp")
                   .forward(request, response);
        }
    }

    // DELETE EMPLOYEE
    private void deleteEmployee(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        String idValue = request.getParameter("employeeId");

        try {
            if (idValue == null || !idValue.matches("[1-9][0-9]*")) {
                response.sendRedirect(request.getContextPath()
                        + "/employees?error=invalidId");
                return;
            }

            int employeeId = Integer.parseInt(idValue);

            String sql = "DELETE FROM employees WHERE employee_id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, employeeId);

                int rowsDeleted = ps.executeUpdate();

                if (rowsDeleted > 0) {
                    response.sendRedirect(request.getContextPath()
                            + "/employees?deleted=1");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/employees?error=notFound");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/employees?error=invalidId");

        } catch (SQLException e) {
            throw new IOException(
                    "Unable to delete employee from database.", e);
        }
    }
}
