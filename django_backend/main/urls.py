from django.urls import path
from main import views

urlpatterns = [
    path('signIn/', views.sign_in, name='signIn'),
    path('signUp/', views.sign_up, name='signUp'),
    path('newPost/', views.new_post, name='newPost'),
    path('getPosts/', views.get_posts, name='getPosts'),
    path('newStory/', views.new_story, name='newStory'),
    path('getStories/', views.get_stories, name='getStories'),
    path('getLCCount/', views.get_lc_count, name='getLCCount'),
    path('setPostLike/', views.set_post_like, name='setPostLike'),
    path('addPostComment/', views.add_post_comment, name='addPostComment'),
    path('getPostComments/', views.get_post_comments, name='getPostComments'),
    path('getUsers/', views.get_users, name='getUsers'),
    path('sendMsg/', views.send_msg, name='sendMsg'),
    path('getMsgs/', views.get_msgs, name='getMsgs'),
    path('getLatest/', views.get_latest, name='getLatest'),
    path('getPostsById/', views.get_posts_by_id, name='getPostsById'),
    path('deletePost/', views.delete_post, name='deletePost'),
    path('getUserInfo/', views.get_user_info, name='getUserInfo'),
]

