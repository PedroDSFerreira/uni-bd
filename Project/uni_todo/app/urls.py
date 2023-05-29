from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='pages/index.html', extra_context={'title': 'Home'}), name='index'),
    path('my-tasks/', TemplateView.as_view(template_name='pages/my-tasks.html', extra_context={'title': 'My Tasks'}), name='my-tasks'),
    path('find/', TemplateView.as_view(template_name='pages/find.html', extra_context={'title': 'Find'}), name='find'),
]
