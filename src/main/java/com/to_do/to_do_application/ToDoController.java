package com.to_do.to_do_application;
import java.time.LocalDate;
import java.util.Map;
import java.util.List;

import jakarta.servlet.http.HttpSession;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.net.ssl.HttpsURLConnection;

@Controller
public class ToDoController {

    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    String sql;
    public ToDoController(JdbcTemplate jdbcTemplate, PasswordEncoder passwordEncoder){
        this.jdbcTemplate=jdbcTemplate;
        this.passwordEncoder=passwordEncoder;
    }
    @RequestMapping({"/", "home"})
    public String home(){
        System.out.println("Inside the home function");
        return "home";
    }

    @RequestMapping("signup")
    public String signup(@RequestParam String name,@RequestParam String email, @RequestParam String password, RedirectAttributes redirectAttributes){
        email=email.trim();

        if (email.isEmpty() || password.length()<8){
            redirectAttributes.addFlashAttribute("errorMessage", "Please enter a valid email address and password of atleast 8 characters.");
            return "redirect:/home";
        }
        try{
             String encodedPassword=passwordEncoder.encode(password);
             sql="INSERT INTO app_users (name, email, password_hash) VALUES (?,?,?)";
             jdbcTemplate.update(sql, name, email, encodedPassword);
             redirectAttributes.addFlashAttribute("successMessage", "Signup successful! You account has been created");
        }catch(DuplicateKeyException e){
            redirectAttributes.addFlashAttribute("errorMessage", "Email address already used.");
        }
        return "redirect:/home";
    }
    @PostMapping("login")
    public String login(@RequestParam String email, @RequestParam String password, HttpSession httpSession, RedirectAttributes redirectAttributes){
        email=email.trim();
        if(email.isEmpty() || password.length()<8){
            redirectAttributes.addFlashAttribute("errorMessage", "Email is empty or password less than 8 characters");
            return "redirect:/home";
        }
        sql="SELECT * FROM APP_USERS WHERE EMAIL=?";
        List<Map<String, Object>> users=jdbcTemplate.queryForList(sql,email);
        if(users.isEmpty()){
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid email address or password");
            return "redirect:/home";
        }
        Map<String, Object> user=users.get(0);
        String storedPassword=(String)user.get("password_hash");
        if(passwordEncoder.matches(password, storedPassword)){
            httpSession.setAttribute("userId", user.get("user_id"));
            httpSession.setAttribute("userEmail", email);
            httpSession.setAttribute("name", user.get("name"));
            redirectAttributes.addFlashAttribute("successMessage", "Login successful! Login successful");
        }else{
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid email address or password");
        }
        return "redirect:/home";
    }
    @PostMapping("addTask")
    public String addTask(@RequestParam String taskTitle, @RequestParam String taskDescription, @RequestParam LocalDate dueDate,
                          @RequestParam String taskPriority, @RequestParam String taskCategory, HttpSession session,
                          RedirectAttributes redirectAttributes){
        Object userIdObject=session.getAttribute("userId");
        if(userIdObject == null){
            redirectAttributes.addFlashAttribute("errorMessage", "Please login first to add a task!");
            return "redirect:/home";
        }
        int userId= ((Number)userIdObject).intValue();
        sql="INSERT INTO TASKS (user_id, title, description, due_date, priority, category) VALUES (?,?,?,?,?,?)";
        int rowsAffected=jdbcTemplate.update(sql, userId, taskTitle.trim(), taskDescription, dueDate, taskPriority, taskCategory);
        if(rowsAffected>0){
            redirectAttributes.addFlashAttribute("successMessage", "Task added Successfully");
        }else{
            redirectAttributes.addFlashAttribute("errorMessage", "Error while adding the task");
        }
        return "redirect:/home";
    }
    @RequestMapping("viewTasks")
    public String viewTasks(HttpSession session, Model model, RedirectAttributes redirectAttributes){
        Object userIdObject=session.getAttribute("userId");

        if(userIdObject==null){
            redirectAttributes.addFlashAttribute("errorMessage", "Kindly login to view the tasks");
            return "redirect:/home";
        }
        int userId= ((Number)userIdObject).intValue();
        sql="SELECT task_id, title, description, due_date, priority, category, status, CASE WHEN STATUS != 'COMPLETED' THEN DATEDIFF(due_date, CURDATE()) ELSE 0 END AS overdue_days FROM tasks where user_id = ? and del_flag = 'N' ORDER BY due_date ASC";
        List<Map<String, Object>> tasks = jdbcTemplate.queryForList(sql, userId);
        model.addAttribute("tasks", tasks);
        redirectAttributes.addFlashAttribute("viewTasksMessage", "Success");
        return "home";
    }
    @RequestMapping("updateTaskStatus")
    public String updateTaskStatus(@RequestParam int taskId, @RequestParam String status, HttpSession session, RedirectAttributes redirectAttributes){
        Object userIdObject = session.getAttribute("userId");
        if(userIdObject == null){
            redirectAttributes.addFlashAttribute("errorMessage", "Please login first.");
            return "redirect:/home";
        }
        int userId=((Number)userIdObject).intValue();
        if(!List.of("PENDING", "IN_PROGRESS", "COMPLETED").contains(status)){
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid task status.");
            return "redirect:/home";
        }
        sql="UPDATE tasks SET STATUS = ? WHERE user_id = ? and task_id = ?";
        int rowsAffected=jdbcTemplate.update(sql,status, userId, taskId);
        if(rowsAffected>0){
            redirectAttributes.addFlashAttribute("successMessage", "Status for the task updated successfully");
        }else{
            redirectAttributes.addFlashAttribute("errorMessage", "Task not found");
        }
        return "redirect:/home";
    }
    @RequestMapping("deleteTask")
    public String deleteTask(@RequestParam int taskId, HttpSession session, RedirectAttributes redirectAttributes){
        Object userIdObject= session.getAttribute("userId");
        if(userIdObject==null){
            redirectAttributes.addFlashAttribute("errorMessage", "Kindly login first!");
            return "redirect:/home";
        }
        int userId=((Number)userIdObject).intValue();
        sql="UPDATE tasks set del_flag = 'Y' WHERE user_id=? and task_id=?";
        int rowsAffected=jdbcTemplate.update(sql,userId, taskId);
        if(rowsAffected>0){
            redirectAttributes.addFlashAttribute("successMessage", "Task deleted successfully!!");
        }else{
            redirectAttributes.addFlashAttribute("errorMessage", "Task not found");
        }
        return "redirect:/home";
    }

    @GetMapping("/dailyReminder")
    @ResponseBody
    public List<Map<String, Object>> dailyReminder(HttpSession session) {

        Object userIdObject = session.getAttribute("userId");

        if (userIdObject == null) {
            return List.of();
        }

        int userId = ((Number) userIdObject).intValue();

        String sql = """
        SELECT task_id, title, due_date,
               DATEDIFF(due_date, CURDATE()) AS overdue_days
        FROM tasks
        WHERE user_id = ?
          AND status != 'COMPLETED'
          AND due_date <= CURDATE() AND DEL_FLAG = 'N'
        ORDER BY due_date ASC
        """;

        return jdbcTemplate.queryForList(sql, userId);
    }

}
