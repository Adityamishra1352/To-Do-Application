package com.to_do.to_do_application.controller;

import com.to_do.to_do_application.dto.TaskResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/tasks")
public class TaskRestController {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping
    public List<TaskResponse> getAllTasks(HttpSession httpSession){
        Integer userId=(Integer) httpSession.getAttribute("userId");

        if (userId == null) {
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED,
                    "Please login first"
            );
        }
        String sql="SELECT task_id, title, description, due_date, priority, category, status, CASE WHEN STATUS != 'COMPLETED' THEN DATEDIFF(due_date, CURDATE()) ELSE 0 END AS overdue_days FROM tasks where user_id = ? and del_flag = 'N' ORDER BY due_date ASC";
        return jdbcTemplate.query(sql, (rs,rowNum)->{
            TaskResponse task=new TaskResponse();
            task.setTaskId(rs.getInt("task_id"));
            task.setTaskTitle(rs.getString("title"));
            task.setTaskDescription(
                    rs.getString("description"));
            task.setTaskPriority(rs.getString("priority"));
            task.setTaskCategory(rs.getString("category"));
            task.setStatus(rs.getString("status"));

            return task;
        },
                userId);
    }
}
