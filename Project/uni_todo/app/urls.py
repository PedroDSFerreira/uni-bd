from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='pages/index.html', extra_context={'title': 'Home'}), name='index'),
    path('my-tasks/', TemplateView.as_view(template_name='pages/my-tasks.html', extra_context={'title': 'My Tasks'}), name='my-tasks'),
    path('find/', TemplateView.as_view(template_name='pages/find.html', extra_context={'title': 'Find'}), name='find'),
    path('followers/', TemplateView.as_view(template_name='pages/followers.html', extra_context={'title': 'Followers'}), name='followers'),
    path('following/', TemplateView.as_view(template_name='pages/following.html', extra_context={'title': 'Following'}), name='following'),
    path('user/<int:pk>/', TemplateView.as_view(template_name='pages/user-tasks.html', extra_context={'title': 'User Tasks'}), name='user-tasks'),
]
