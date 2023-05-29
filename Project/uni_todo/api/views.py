import json
from django.db import connection, transaction
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
def list_universities(request):
    """Returns a list of universities from the database."""
    if request.method == 'GET':
        with connection.cursor() as cursor:
            # Execute the procedure to fetch universities
            cursor.execute("EXEC uni_tasks.ListUniversities")
            result = cursor.fetchall()
            
        universities = [{'id': row[0], 'name': row[1]} for row in result]
        return JsonResponse(universities, safe=False)
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def delete_task(request):
    """Soft deletes a task from the database."""
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))
        task_id = data.get('task_id')
        
        with connection.cursor() as cursor:
            # Execute the DeleteTask stored procedure
            cursor.execute("EXEC uni_tasks.DeleteTask @id=%s", [task_id])
        
        return JsonResponse({'message': 'Task deleted successfully.'})
    
    return JsonResponse({'error': 'Invalid request method.'})


@csrf_exempt
def associate_task_with_user(request):
    """Associates a task with a user."""
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))
        task_id = data.get('task_id')
        user_id = data.get('user_id')

        with connection.cursor() as cursor:
            # Execute the AssociateTaskWithUser stored procedure
            cursor.execute("EXEC uni_tasks.AssociateTaskWithUser @task_id=%s, @usr_id=%s", [task_id, user_id])
        
        return JsonResponse({'message': 'Task associated with user successfully.'})
    
    return JsonResponse({'error': 'Invalid request method.'})


@csrf_exempt
def follow_user(request):
    """Follows a user."""
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))

        follower_id = data.get('follower_id')
        followee_id = data.get('followee_id')

        with connection.cursor() as cursor:
            # Check if the user is already being followed
            cursor.execute("SELECT 1 FROM uni_tasks.follows WHERE usr_id_follower = %s AND usr_id_followee = %s",
                           [follower_id, followee_id])
            if cursor.fetchone() is None:
                # User is not already being followed, perform the follow operation
                cursor.execute("EXEC uni_tasks.FollowUser @follower_id=%s, @followee_id=%s",
                               [follower_id, followee_id])
                message = 'User followed successfully.'
            else:
                message = 'User is already being followed.'
        
        return JsonResponse({'message': message})
    
    return JsonResponse({'error': 'Invalid request method.'})


@csrf_exempt
def list_followees(request):
    """Returns a list of followees for a given user."""
    if request.method == 'GET':
        user_id = request.GET.get('user_id')
        with connection.cursor() as cursor:
            # Execute the ListFollowees stored procedure
            cursor.execute("EXEC uni_tasks.ListFollowees @usr_id=%s", [user_id])
            result = cursor.fetchall()
        followees = [{'id': row[0], 'name': row[1], 'uni_id': row[2]} for row in result]
        return JsonResponse(followees, safe=False)

    return JsonResponse({'error': 'Invalid request method.'})


@csrf_exempt
def list_followers(request):
    """Returns a list of followers for a given user."""
    if request.method == 'GET':
        user_id = request.GET.get('user_id')
        
        with connection.cursor() as cursor:
            # Execute the ListFollowers stored procedure
            cursor.execute("EXEC uni_tasks.ListFollowers @usr_id=%s", [user_id])
            result = cursor.fetchall()
        
        followers = [{'id': row[0], 'name': row[1], 'uni_id': row[2]} for row in result]
        return JsonResponse(followers, safe=False)
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def list_tasks(request):
    """Returns a list of tasks for a given user."""
    if request.method == 'GET':
        user_id = request.GET.get('user_id')
        is_public = request.GET.get('is_public', '0')

        
        with connection.cursor() as cursor:
            # Execute the ListTasks stored procedure
            cursor.execute("EXEC uni_tasks.ListTasks @usr_id=%s, @is_public=%s", [user_id, is_public])

            result = cursor.fetchall()
        

        tasks = []
        if result:
            columns = ['task_id', 'task_name', 'class_name', 'description', 'group', 'status', 'start_date', 'end_date', 'priority_lvl']

            for row in result:
                task = dict(zip(columns, row))
                tasks.append(task)
    
        return JsonResponse(tasks, safe=False)
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def create_task(request):
    """Creates a new task."""
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))

        task_name = data.get('task_name')
        class_id = data.get('class_id')
        description = data.get('description')
        group = data.get('group')
        status = data.get('status')
        start_date = data.get('start_date')
        end_date = data.get('end_date')
        priority_lvl = data.get('priority_lvl')
        is_public = data.get('is_public')
        user_id = data.get('user_id')

        with connection.cursor() as cursor:
            # Execute the NewTask stored procedure
            cursor.execute("EXEC uni_tasks.NewTask @task_name=%s, @class_id=%s, @description=%s, @group=%s, @status=%s, @start_date=%s, @end_date=%s, @priority_lvl=%s, @is_public=%s, @usr_id=%s", [task_name, class_id, description, group, status, start_date, end_date, priority_lvl, is_public, user_id])
        
        return JsonResponse({'message': 'Task created successfully.'})
    
    return JsonResponse({'error': 'Invalid request method.'})


@csrf_exempt
def search_user(request):
    """
    Searches for a user by name.
    Returns users and whether or not the current user can follow them.
    """
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))

        user_name = data.get('user_name')
        user_id = data.get('user_id')
        
        with connection.cursor() as cursor:
            # Execute the SearchUser stored procedure
            cursor.execute("EXEC uni_tasks.SearchUser @user_name=%s, @usr_id=%s", [user_name, user_id])
            result = cursor.fetchall()
        
        users = []
        for row in result:
            user = {
                'id': row[0],
                'name': row[1],
                'uni_id': row[2],
                'can_follow': bool(row[3])
            }
            users.append(user)
        
        return JsonResponse(users, safe=False)
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def update_task(request):
    """Updates a task."""
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))

        task_id = data.get('task_id')
        task_name = data.get('task_name')
        class_id = data.get('class_id')
        description = data.get('description')
        group = data.get('group')
        status = data.get('status')
        start_date = data.get('start_date')
        end_date = data.get('end_date')
        priority_lvl = data.get('priority_lvl')
        is_public = data.get('is_public')

        with connection.cursor() as cursor:
            # Execute the UpdateTask stored procedure
            cursor.execute("EXEC uni_tasks.UpdateTask @task_id=%s, @task_name=%s, @class_id=%s, @description=%s, @group=%s, @status=%s, @start_date=%s, @end_date=%s, @priority_lvl=%s, @is_public=%s",
                           [task_id, task_name, class_id, description, group, status, start_date, end_date, priority_lvl, is_public])
        
        return JsonResponse({'message': 'Task updated successfully.'})
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def register_user(request):
    """Registers a new user."""
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))

        username = data.get('username')
        password = data.get('password')
        uni_id = data.get('uni_id')

        with transaction.atomic():
            with connection.cursor() as cursor:
                # Execute the RegisterUser stored procedure
                cursor.execute("EXEC uni_tasks.RegisterUser @username=%s, @password=%s, @uni_id=%s", [username, password, uni_id])

                # Fetch last inserted user id
                user_id = cursor.execute("SELECT MAX(id) AS last_user_id FROM uni_tasks._user").fetchone()[0]


        return JsonResponse({'user_id': user_id})
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def login_user(request):
    """Logs in a user."""
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))

        username = data.get('username')
        password = data.get('password')

        with connection.cursor() as cursor:
            # Execute the LoginUser stored procedure with output parameter
            cursor.execute("""
                DECLARE @login_result BIT;
                EXEC uni_tasks.LoginUser @username=%s, @password=%s, @login_result = @login_result OUTPUT;
                SELECT @login_result;
            """, [username, password])
            
            # Fetch the output value
            login_result_value = cursor.fetchone()[0]

        return JsonResponse({'status': login_result_value})
    
    return JsonResponse({'error': 'Invalid request method.'})

# DEBUG
@csrf_exempt
def list_all_tasks(request):
    """Returns a list of all tasks."""
    if request.method == 'GET':
        with connection.cursor() as cursor:
            # Execute the ListAllTasks stored procedure
            cursor.execute("SELECT * FROM uni_tasks.task")

            result = cursor.fetchall()

        return JsonResponse(result, safe=False)

    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def list_all_users(request):
    """Returns a list of all users."""
    if request.method == 'GET':
        with connection.cursor() as cursor:
            # Execute the ListAllUsers stored procedure
            cursor.execute("SELECT * FROM uni_tasks._user")

            result = cursor.fetchall()

        users = []
        if result:
            columns = ['user_id', 'name', 'pass_hash', 'uni_id']

            # dont return pass_hash
            for row in result:
                user = dict(zip(columns, row))
                del user['pass_hash']
                users.append(user)
    
        return JsonResponse(users, safe=False)


    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def list_all_classes(request):
    """Returns a list of all classes."""
    if request.method == 'GET':
        with connection.cursor() as cursor:
            # Execute the ListAllClasses stored procedure
            cursor.execute("SELECT * FROM uni_tasks.class")

            result = cursor.fetchall()

        return JsonResponse(result, safe=False)

    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def list_all_associations(request):
    """Returns a list of all associations."""
    if request.method == 'GET':
        with connection.cursor() as cursor:
            # Execute the ListAllAssociations stored procedure
            cursor.execute("SELECT * FROM uni_tasks.assigned_to")

            result = cursor.fetchall()

        return JsonResponse(result, safe=False)

    return JsonResponse({'error': 'Invalid request method.'})
