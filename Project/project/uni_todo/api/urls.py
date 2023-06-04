from django.urls import path
from . import views

urlpatterns = [
    path('list_universities', views.list_universities, name='list_universities'),
    path('delete_task', views.delete_task, name='delete_task'),
    path('associate_task_with_user', views.associate_task_with_user, name='associate_task_with_user'),
    path('follow_user', views.follow_user, name='follow_user'),
    path('unfollow_user', views.unfollow_user, name='unfollow_user'),
    path('list_followees', views.list_followees, name='list_followees'),
    path('list_followers', views.list_followers, name='list_followers'),
    path('list_tasks', views.list_tasks, name='list_tasks'),
    path('create_task', views.create_task, name='create_task'),
    path('get_user', views.get_user, name='get_user'),
    path('search_user', views.search_user, name='search_user'),
    path('update_task', views.update_task, name='update_task'),
    path('register_user', views.register_user, name='register_user'),
    path('login_user', views.login_user, name='login_user'),
    path('list_classes', views.list_classes, name='list_classes'),
]
