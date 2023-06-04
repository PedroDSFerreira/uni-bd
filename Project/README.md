# UniTask
## The Essential University Checklist

## Introduction


The aim of this platform is to build a web application that helps manage tasks for university students.

## Technologies used

### Frontend

- HTML
- CSS (Bootstrap)
- JavaScript (jQuery)

### Backend

- Django
- Microsoft SQL Server

## Requirements


To run the server, you need to have the following software installed:

- Docker
- Docker compose

## Getting Started

1. Clone the repository:
    
    ```bash
    git clone <repo-url>
    ```
    
2. Navigate to the `project` directory.
3. Build and run the Docker containers:
    
    ```bash
    docker compose up
    ```
    
    Now wait for 60 seconds for the containers to start up, and the DB to be seeded with data.
        
4. Once everything is up and running, you can access the web platform in your browser at **[http://localhost:8000/](http://localhost:8000/)**.

## API Endpoints

- `/list_universities`
- `/delete_task`
- `/associate_task_with_user`
- `/follow_user`
- `/unfollow_user`
- `/list_followees`
- `/list_followers`
- `/list_tasks`
- `/create_task`
- `/search_user`
- `/get_user`
- `/update_task`
- `/register_user`
- `/login_user`
- `/list_classes`

For more information on the API endpoints, please refer to the [secondary report](secondary-report.pdf)