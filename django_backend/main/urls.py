from django.urls import path
from main import views

urlpatterns = [
    path('login/', views.login_view, name='login'),
]
