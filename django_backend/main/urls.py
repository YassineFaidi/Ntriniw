from django.urls import path
from main import views

urlpatterns = [
    path('signIn/', views.sign_in, name='signIn'),
    path('signUp/', views.sign_up, name='signUp'),
    path('newPost/', views.new_post, name='newPost'),
    path('getPosts/', views.get_posts, name='getPosts'),
]
