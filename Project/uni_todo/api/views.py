from django.db import connection
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
        task_id = request.POST.get('task_id')
        
        with connection.cursor() as cursor:
            # Execute the DeleteTask stored procedure
            cursor.execute("EXEC uni_tasks.DeleteTask @id=%s", [task_id])
        
        return JsonResponse({'message': 'Task deleted successfully.'})
    
    return JsonResponse({'error': 'Invalid request method.'})


@csrf_exempt
def associate_task_with_user(request):
    """Associates a task with a user."""
    if request.method == 'POST':
        task_id = request.POST.get('task_id')
        user_id = request.POST.get('user_id')

        with connection.cursor() as cursor:
            # Execute the AssociateTaskWithUser stored procedure
            cursor.execute("EXEC uni_tasks.AssociateTaskWithUser @task_id=%s, @usr_id=%s", [task_id, user_id])
        
        return JsonResponse({'message': 'Task associated with user successfully.'})
    
    return JsonResponse({'error': 'Invalid request method.'})


@csrf_exempt
def follow_user(request):
    """Follows a user."""
    if request.method == 'POST':
        follower_id = request.POST.get('follower_id')
        followee_id = request.POST.get('followee_id')

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
    if request.method == 'POST':
        user_id = request.POST.get('user_id')

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
    if request.method == 'POST':
        user_id = request.POST.get('user_id')
        is_public = request.POST.get('is_public', False)
        is_public = bool(int(is_public)) if is_public.isdigit() else False
        
        with connection.cursor() as cursor:
            # Execute the ListTasks stored procedure
            cursor.execute("EXEC uni_tasks.ListTasks @usr_id=%s, @is_public=%s", [user_id, is_public])
            result = cursor.fetchall()
        
        tasks = []
        columns = [column[0] for column in cursor.description]
        
        for row in result:
            task = dict(zip(columns, row))
            tasks.append(task)
        
        return JsonResponse(tasks, safe=False)
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def create_task(request):
    """Creates a new task."""
    if request.method == 'POST':
        task_name = request.POST.get('task_name')
        class_id = int(request.POST.get('class_id'))
        description = request.POST.get('description')
        group = request.POST.get('group')
        status = request.POST.get('status')
        start_date = request.POST.get('start_date')
        end_date = request.POST.get('end_date')
        priority_lvl = int(request.POST.get('priority_lvl'))
        is_public = bool(int(request.POST.get('is_public')))
        usr_id = int(request.POST.get('usr_id'))

        with connection.cursor() as cursor:
            # Execute the NewTask stored procedure
            cursor.execute("EXEC uni_tasks.NewTask @task_name=%s, @class_id=%s, @description=%s, @group=%s, @status=%s, @start_date=%s, @end_date=%s, @priority_lvl=%s, @is_public=%s, @usr_id=%s", [task_name, class_id, description, group, status, start_date, end_date, priority_lvl, is_public, usr_id])
        
        return JsonResponse({'message': 'Task created successfully.'})
    
    return JsonResponse({'error': 'Invalid request method.'})


@csrf_exempt
def search_user(request):
    """Searches for a user by name or uni_id."""
    if request.method == 'POST':
        user_name = request.POST.get('user_name')
        usr_id = request.POST.get('usr_id')
        
        with connection.cursor() as cursor:
            # Execute the SearchUser stored procedure
            cursor.execute("EXEC uni_tasks.SearchUser @user_name=%s, @usr_id=%s", [user_name, usr_id])
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
def update_task_view(request):
    """Updates a task."""
    if request.method == 'POST':
        task_id = request.POST.get('task_id')
        task_name = request.POST.get('task_name')
        class_id = request.POST.get('class_id')
        description = request.POST.get('description')
        group = request.POST.get('group')
        status = request.POST.get('status')
        start_date = request.POST.get('start_date')
        end_date = request.POST.get('end_date')
        priority_lvl = request.POST.get('priority_lvl')
        is_public = request.POST.get('is_public')

        with connection.cursor() as cursor:
            # Execute the UpdateTask stored procedure
            cursor.execute("EXEC uni_tasks.UpdateTask @task_id=%s, @task_name=%s, @class_id=%s, @description=%s, @group=%s, @status=%s, @start_date=%s, @end_date=%s, @priority_lvl=%s, @is_public=%s",
                           [task_id, task_name, class_id, description, group, status, start_date, end_date, priority_lvl, is_public])
        
        return JsonResponse({'message': 'Task updated successfully.'})
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def register_user_view(request):
    """Registers a new user."""
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        with connection.cursor() as cursor:
            # Execute the RegisterUser stored procedure
            cursor.execute("EXEC uni_tasks.RegisterUser @username=%s, @password=%s, @register_result=OUTPUT",
                           [username, password])

            # Get the value of the output parameter
            register_result = cursor.output('register_result')

        return JsonResponse({'message': register_result})
    
    return JsonResponse({'error': 'Invalid request method.'})

@csrf_exempt
def login_user_view(request):
    """Logs in a user."""
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        with connection.cursor() as cursor:
            # Execute the LoginUser stored procedure
            cursor.execute("EXEC uni_tasks.LoginUser @username=%s, @password=%s, @login_result=OUTPUT",
                           [username, password])

            # Get the value of the output parameter
            login_result = cursor.output('login_result')

        return JsonResponse({'message': login_result})
    
    return JsonResponse({'error': 'Invalid request method.'})