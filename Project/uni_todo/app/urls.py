from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='pages/index.html', extra_context={'title': 'Home'}), name='index'),
    path('applicants/', TemplateView.as_view(template_name='pages/applicants.html', extra_context={'title': 'Applicants'}), name='applicants'),
    path('applicants/<int:pk>/', TemplateView.as_view(template_name='pages/profile.html', extra_context={'title': 'Applicant profile'}), name='profile'),
    path('roles/', TemplateView.as_view(template_name='pages/roles.html', extra_context={'title': 'Roles'}), name='roles')
]
