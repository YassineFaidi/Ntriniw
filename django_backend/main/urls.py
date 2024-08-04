from django.urls import path
from main import views

urlpatterns = [
    path('signIn/', views.sign_in, name='signIn'),
    path('signUp/', views.sign_up, name='signUp'),
    path('newPost/', views.new_post, name='newPost'),
    path('getPosts/', views.get_posts, name='getPosts'),
    path('newStory/', views.new_story, name='newStory'),
    path('getStories/', views.get_stories, name='getStories'),
    path('getPostLikesCount/', views.get_post_likes_count, name='getPostLikesCount'),
    path('setPostLike/', views.set_post_like, name='setPostLike'),
    
]
