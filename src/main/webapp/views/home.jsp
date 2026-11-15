<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<title>To Do Application</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-B/GM4XqrwHnWXNOWMbloTmrYXZg10cakYGmpfsR/bbzQ6JAJI4ihuyADKLnBgrCe" crossorigin="anonymous">
<style>
    /* Dropdown styling */
    #priority, #category, #updateStatus {
        border-radius: 8px;
        padding: 10px 12px;
        border: 1px solid #ced4da;
        background-color: #ffffff;
        color: #212529;
        font-size: 15px;
        cursor: pointer;
    }

    /* Focus effect */
    #priority:focus, #category:focus, #updateStatus:focus {
        border-color: #86b7fe;
        box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.2);
        outline: none;
    }

    /* Individual options */
    #priority, #category, #updateStatus option {
        padding: 10px;
        background-color: #ffffff;
        color: #212529;
    }

    /* Priority colors */
    #priority option[value="HIGH"] {
        background-color: #dc3545;
        color: white;
    }

    #priority option[value="MEDIUM"] {
        background-color: #ffc107;
        color: black;
    }

    #priority option[value="LOW"] {
        background-color: #198754;
        color: white;
    }
</style>
</head>
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
                    <li class = "nav-item">
                    <button type="button"
                            class="btn btn-outline-primary"
                            onclick="enableNotifications()">
                        Enable Notifications
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
    <div class = "w-50">
    <button type="button" class="btn-solid theme-accent w-100 p-3" data-bs-toggle="dialog" data-bs-target="#addTaskModal">
        Add Tasks
    </button>
    </div>
    <form action="viewTasks" method="get" class = "w-50">
        <button type="submit" class="btn-solid theme-accent w-100 p-3">
            View All Tasks
        </button>
    </form>
</div>
<c:if test="${not empty sessionScope.userId}">
    <div class="container mt-4">

        <c:choose>

            <c:when test="${not empty tasks}">

                <div class="table-responsive">

                    <table class="table table-bordered table-hover align-middle">

                        <thead class="table-dark">
                        <tr>
                            <th>Task ID</th>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Due Date</th>
                            <th>Pending Days</th>
                            <th>Priority</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                        </thead>

                        <tbody>

                        <c:forEach var="task" items="${tasks}">

                            <tr>

                                <td>${task.task_id}</td>
                                <td>${task.title}</td>
                                <td>${task.description}</td>
                                <td>${task.due_date}</td>
                                <td>${task.overdue_days}</td>
                                <td>
                                    <c:choose>

                                        <c:when test="${task.priority == 'HIGH'}">
                                            <span class="badge bg-danger">HIGH</span>
                                        </c:when>

                                        <c:when test="${task.priority == 'MEDIUM'}">
                                            <span class="badge bg-warning text-dark">MEDIUM</span>
                                        </c:when>

                                        <c:when test="${task.priority == 'LOW'}">
                                            <span class="badge bg-success">LOW</span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="badge bg-secondary">
                                                    ${task.priority}
                                            </span>
                                        </c:otherwise>

                                    </c:choose>
                                </td>
                                <td>${task.category}</td>
                                <td>${task.status}</td>

                                <td>

                                    <form action="${pageContext.request.contextPath}/updateTaskStatus"
                                          method="post">

                                        <input type="hidden"
                                               name="taskId"
                                               value="${task.task_id}">

                                        <select name="status"
                                                class="form-select mb-2" id="updateStatus"
                                                required>

                                            <option value="PENDING"
                                                ${task.status == 'PENDING' ? 'selected' : ''}>
                                                Pending
                                            </option>

                                            <option value="IN_PROGRESS"
                                                ${task.status == 'IN_PROGRESS' ? 'selected' : ''}>
                                                In Progress
                                            </option>

                                            <option value="COMPLETED"
                                                ${task.status == 'COMPLETED' ? 'selected' : ''}>
                                                Completed
                                            </option>

                                        </select>

                                        <button type="submit"
                                                class="btn btn-primary bg-accent fg-contrast-accent">
                                            Update Status
                                        </button>

                                    </form>

                                </td>

                            </tr>

                        </c:forEach>

                        </tbody>

                    </table>

                </div>

            </c:when>

            <c:otherwise>

                <div class="alert alert-info">
                    You don't have any tasks yet!
                </div>

            </c:otherwise>

        </c:choose>

    </div>
</c:if>
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
<!-- Add Task Modal -->
<dialog class="dialog dialog-slide-down" id="addTaskModal">
    <c:if test="${empty sessionScope.userId}">

        <div class="alert theme-danger" role="alert">
            <p class="dialog-title">Kindly login first!</p>
            <button type="button" class="btn-close" data-bs-dismiss="dialog" aria-label="Close"></button>
        </div>

    </c:if>
    <c:if test="${not empty sessionScope.userId}">
    <div class="dialog-header">
        <h1 class="dialog-title">Add Tasks</h1>
        <button type="button" class="btn-close" data-bs-dismiss="dialog" aria-label="Close"></button>
    </div>
    <form action="addTask" method="post">
        <div class = "m-3">
            <label class="form-label">Task Title:</label>
            <input type = "text" class="form-control w-15" name = "taskTitle" placeholder="e.g. Complete Java assignment" required>
            <span> A short name describing what needs to be done.</span>
        </div>
        <div class = "m-3">
            <label class="form-label">Description</label>
            <input type = "text" class="form-control w-15" name = "taskDescription" placeholder="Add more details about this task...">
            <span>Optional details or instructions.</span>
        </div>
        <div class = "m-3">
            <label class="form-label">Due Date</label>
            <input type = "date" class="form-control w-15" name = "dueDate" placeholder="Select due date" required>
            <span>When should the task be complete?</span>
        </div>
        <div class="mb-3">
            <label for="priority" class="form-label">Priority</label><br>

            <select class="form-select" id="priority" name="taskPriority" required>
                <option value="" selected disabled>Select Priority</option>
                <option value="HIGH">High</option>
                <option value="MEDIUM">Medium</option>
                <option value="LOW">Low</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="category" class="form-label">Category</label><br>

            <select class="form-select" id="category" name="taskCategory" required>
                <option value="" selected disabled>Select Category</option>
                <option value="WORK">Work</option>
                <option value="PERSONAL">Personal</option>
                <option value="STUDY">Study</option>
                <option value="HEALTH">Health</option>
                <option value="OTHER">Other</option>
            </select>
        </div>
        <div class="dialog-footer">
            <button type="button" class="btn-solid theme-secondary" data-bs-dismiss="dialog">Close</button>
            <input type="submit" class="btn-solid theme-primary" name="Submit">
        </div>
    </form>
    </c:if>
</dialog>

</body>
<script>

    function enableNotifications() {

        if (!("Notification" in window)) {
            alert("Your browser does not support notifications.");
            return;
        }

        Notification.requestPermission().then(permission => {

            if (permission === "granted") {
                alert("Browser notifications enabled!");

                // Check reminders immediately
                checkDailyReminders();

            } else {
                alert("Please allow notifications in browser settings.");
            }

        });
    }

    function checkDailyReminders() {

        if (!("Notification" in window) ||
            Notification.permission !== "granted") {
            return;
        }

        fetch("${pageContext.request.contextPath}/dailyReminder")
            .then(response => {

                if (!response.ok) {
                    throw new Error("Failed to fetch reminders");
                }

                return response.json();
            })
            .then(tasks => {

                const today = new Date().toISOString().split("T")[0];

                tasks.forEach(task => {

                    const notificationKey =
                        "task_" + task.task_id + "_" + today;

                    if (localStorage.getItem(notificationKey)) {
                        return;
                    }

                    const dueDate = new Date(task.due_date)
                        .toLocaleDateString();

                    const notification = new Notification(
                        "To-Do Reminder",
                        {
                            body: task.title +
                                "\nDue date: " + dueDate +
                                "\nPlease complete this task!",
                        }
                    );

                    localStorage.setItem(notificationKey, "shown");

                    notification.onclick = function () {
                        window.focus();
                        notification.close();
                    };

                });

            })
            .catch(error => console.error("Reminder error:", error));
    }
    window.addEventListener("load", function () {

        checkDailyReminders();
        setInterval(checkDailyReminders, 60000);

    });

</script>
<script>window.addEventListener("load", checkDailyReminders);</script>
<script type="module" src="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-1a/pXj49ZQ1aHEmrJ+gMw1otqoVsYwlEnlD8mIfY2TV03r20Y0CN7uqx1tQogjPL" crossorigin="anonymous"></script>
</html>