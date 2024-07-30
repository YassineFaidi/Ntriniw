from django.urls import path
from main import views

urlpatterns = [
    path('signIn/', views.sign_in_view, name='signIn'),
    path('signUp/', views.sign_up_view, name='signUp'),
]
