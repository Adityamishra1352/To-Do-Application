<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<title>To Do Application</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-B/GM4XqrwHnWXNOWMbloTmrYXZg10cakYGmpfsR/bbzQ6JAJI4ihuyADKLnBgrCe" crossorigin="anonymous">
<body>
<nav class="navbar md:navbar-expand bg-1 theme-accent">
    <div class="container-fluid">
        <a class="navbar-brand" href="home">ToDo Application</a>
        <button class="btn-icon navbar-toggler" type="button" data-bs-toggle="drawer" data-bs-target="#navbarDrawer" aria-controls="navbarDrawer" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" aria-hidden="true"></span>
        </button>
        <dialog class="drawer drawer-end" tabindex="-1" id="navbarDrawer" aria-labelledby="navbarDrawerLabel">
            <div class="drawer-header">
                <h5 class="drawer-title" id="navbarDrawerLabel">Menu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="drawer" aria-label="Close"></button>
            </div>
            <div class="drawer-body mb-2 md:mb-0">
                <ul class="nav navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="home">Home</a>
                    </li>
                    <li class="nav-item">
                        <button type="button" class="nav-link" data-bs-toggle="dialog" data-bs-target="#loginModal">
                            Login
                        </button>
                    </li>
                    <li class="nav-item">
                        <button type="button" class="nav-link" data-bs-toggle="dialog" data-bs-target="#signupModal">
                            Signup
                        </button>
                    </li>
                    <c:if test="${not empty sessionScope.userEmail}">
                        <li class="nav-item ms-3">
                    <span class="badge text-bg-success p-2">
                        Logged in as: ${sessionScope.name}
                    </span>
                        </li>
                    </c:if>
                </ul>
            </div>
        </dialog>
    </div>
</nav>
<c:if test="${not empty successMessage}">
    <div class="container mt-3">
        <div class="alert alert-success alert-dismissible fade show"
             role="alert">

                ${successMessage}

            <button type="button" class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>
    </div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="container mt-3">
        <div class="alert alert-danger alert-dismissible fade show"
             role="alert">

                ${errorMessage}

            <button type="button" class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>
    </div>
</c:if>

<div class="container d-flex justify-content-center">

    <div class="card p-4">
        <h4>Welcome to the To_do Application</h4>
    </div>

</div>
<div class="btn-group d-flex justify-content-center" role="group" aria-label="Accent theme example">
    <input type="button" class="btn-solid theme-accent" value = "Add Tasks">
    <input type="button" class="btn-solid theme-accent" value="View All Tasks" placeholder="View All Tasks">
</div>
<!-- Signup Modal -->
<dialog class="dialog dialog-slide-down" id="signupModal">
    <div class="dialog-header">
        <h1 class="dialog-title">Signup to the To Do Application</h1>
        <button type="button" class="btn-close" data-bs-dismiss="dialog" aria-label="Close"></button>
    </div>
        <form action="signup" method="post">
            <div class = "m-3">
                <label class="form-label">Name:</label>
                <input type = "text" class="form-control w-15" name = "name" placeholder="Enter your name" required>
            </div>
            <div class = "m-3">
                <label class="form-label">Email Address:</label>
                <input type = "text" class="form-control w-15" name = "email" placeholder="Enter your email address" required>
            </div>
            <div class = "m-3">
                <label class="form-label">Password:</label>
                <input type = "password" class="form-control w-15" name = "password" placeholder="Enter your password" required>
            </div>
            <div class="dialog-footer">
                <button type="button" class="btn-solid theme-secondary" data-bs-dismiss="dialog">Close</button>
                <input type="submit" class="btn-solid theme-primary" name="Submit">
            </div>
        </form>

</dialog>
<!-- Login Modal -->
<dialog class="dialog dialog-slide-down" id="loginModal">
    <div class="dialog-header">
        <h1 class="dialog-title">Login into the ToDo Application</h1>
        <button type="button" class="btn-close" data-bs-dismiss="dialog" aria-label="Close"></button>
    </div>
    <form action="login" method="post">
        <div class = "m-3">
            <label class="form-label">Email Address:</label>
            <input type = "text" class="form-control w-15" name = "email" placeholder="Enter your email address" required>
        </div>
        <div class = "m-3">
            <label class="form-label">Password:</label>
            <input type = "password" class="form-control w-15" name = "password" placeholder="Enter your password" required>
        </div>
        <div class="dialog-footer">
            <button type="button" class="btn-solid theme-secondary" data-bs-dismiss="dialog">Close</button>
            <input type="submit" class="btn-solid theme-primary" name="Submit">
        </div>
    </form>

</dialog>

</body>
<script type="module" src="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-1a/pXj49ZQ1aHEmrJ+gMw1otqoVsYwlEnlD8mIfY2TV03r20Y0CN7uqx1tQogjPL" crossorigin="anonymous"></script>
</html>