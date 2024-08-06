from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from django.db import connection
import datetime
import bcrypt
import base64
import json

@csrf_exempt
def sign_up(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            password = data.get('password')
            username = data.get('username')
            image_base64 = data.get('image')
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT email FROM users WHERE email = %s", [email])
                emails = cursor.fetchone()
                if emails:
                    return JsonResponse({'success': False, 'error': 'Email already exist'})
                    
            hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

            if image_base64:
                image_data = base64.b64decode(image_base64)
            else:
                image_data = None

            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO users (email, password, username, profileImg) VALUES (%s, %s, %s, %s)",
                    [email, hashed_password, username, image_data]
                )
                cursor.execute("SELECT id, username, email, profileImg FROM users WHERE email = %s", [email])
                user = cursor.fetchone()
                if user:
                    user_data = {
                        'uid': user[0],
                        'username': user[1],
                        'email': user[2],
                        'profileImg': base64.b64encode(user[3]).decode() if user[3] else None,
                    }
                    return JsonResponse({'success': True, 'user': user_data})
                else:
                    return JsonResponse({'success': False, 'error': 'User creation failed'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})

    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def sign_in(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            password = data.get('password')

            with connection.cursor() as cursor:
                cursor.execute("SELECT id, username, email, password, profileImg FROM users WHERE email = %s", [email])
                user = cursor.fetchone()
                if user and bcrypt.checkpw(password.encode('utf-8'), user[3].encode('utf-8')):
                    user_data = {
                        'uid': user[0],
                        'username': user[1],
                        'email': user[2],
                        'profileImg': base64.b64encode(user[4]).decode() if user[4] else None,
                    }
                    return JsonResponse({'success': True, 'user': user_data})
                else:
                    return JsonResponse({'success': False, 'error': 'Invalid credentials'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})

    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def new_post(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            userId = data.get('userId')
            content = data.get('content')
            image_base64 = data.get('postImg')
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT id FROM users WHERE id = %s", [userId])
                if not cursor.fetchone():
                    return JsonResponse({'success': False, 'error': 'Uknown user'})

            if image_base64:
                image_data = base64.b64decode(image_base64)
            else:
                image_data = None
            try :
                with connection.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO posts (user_id, content, image) VALUES (%s, %s, %s)",
                        [userId, content, image_data]
                    )
                    return JsonResponse({'success': True, 'message': 'Post created successfully'})
            except Exception as e:
                return JsonResponse({'success': False, 'error': 'Post creation failed'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})

    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

def get_posts(request):
    if request.method == 'GET':
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT created_at, user_id, content, image, id FROM posts ORDER BY created_at DESC")
                posts = cursor.fetchall()
                posts_list = []
                for post in posts:
                    cursor.execute("SELECT username, profileImg from users  WHERE id = %s", [post[1]])
                    user = cursor.fetchone()
                    posts_list.append({"username": str(user[0]), "userImage": base64.b64encode(user[1]).decode() if user[1] else None, "created_at": str(post[0]),"content": str(post[2]), "image": base64.b64encode(post[3]).decode() if post[3] else None, "postId": str(post[4])})
            return JsonResponse({"success": True, "posts": posts_list})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=500)
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def new_story(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            userId = data.get('userId')
            image_base64 = data.get('storyImg')
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT id FROM users WHERE id = %s", [userId])
                if not cursor.fetchone():
                    return JsonResponse({'success': False, 'error': 'isUknown'})
                else:
                    cursor.execute("SELECT id FROM stories WHERE user_id = %s", [userId])
                    if cursor.fetchone():
                        return JsonResponse({'success': False, 'error': 'isStory'})

            if image_base64:
                image_data = base64.b64decode(image_base64)
            else:
                image_data = None
            try :
                with connection.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO stories (user_id, image) VALUES (%s, %s)",
                        [userId, image_data]
                    )
                    return JsonResponse({'success': True, 'message': 'Story created successfully'})
            except Exception as e:
                return JsonResponse({'success': False, 'error': 'Story creation failed'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})

    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

def get_stories(request):
    if request.method == 'GET':
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT id, created_at, user_id, image FROM stories ORDER BY created_at DESC")
                stories = cursor.fetchall()
                stories_list = []
                for story in stories:
                    story_id, created_at, user_id, image = story
                    time_diff = datetime.datetime.now() - created_at
                    if time_diff.total_seconds() > 24 * 3600:
                        cursor.execute("DELETE FROM stories WHERE id = %s", [story_id])
                    else:
                        cursor.execute("SELECT username, profileImg FROM users WHERE id = %s", [user_id])
                        user = cursor.fetchone()
                        stories_list.append({
                            "username": str(user[0]),
                            "userImage": base64.b64encode(user[1]).decode() if user[1] else None,
                            "created_at": str(created_at),
                            "image": base64.b64encode(image).decode() if image else None
                        })
            return JsonResponse({"success": True, "stories": stories_list})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=500)
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def get_lc_count(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        postId = data.get('postId')
        actualUserId = data.get('actualUserId')
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT COUNT(user_id) FROM likes WHERE post_id = %s", [postId])
                likes_count = cursor.fetchone()[0]
                cursor.execute("SELECT user_id FROM likes WHERE post_id = %s and user_id = %s", [postId, actualUserId])
                if cursor.fetchone():
                    isLiked = True
                else:
                    isLiked = False
                cursor.execute("SELECT COUNT(id) FROM comments WHERE post_id = %s", [postId])
                comments_count = cursor.fetchone()[0]
            return JsonResponse({"success": True, "likes_count": str(likes_count), "isLiked": str(isLiked), "comments_count": str(comments_count)})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)})
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def set_post_like(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        postId = data.get('postId')
        userId = data.get('userId')
        isLiked = data.get('isLiked')

        if isLiked == 'true':    
            try:
                with connection.cursor() as cursor:
                    cursor.execute("DELETE FROM likes WHERE post_id = %s and user_id =%s", [postId, userId])
                return JsonResponse({"success": True})
            except Exception as e:
                return JsonResponse({"success": False, "error": str(e)})
        else:   
            try:
                with connection.cursor() as cursor:
                    cursor.execute("INSERT INTO likes (user_id, post_id) VALUES (%s, %s)", [userId, postId])
                return JsonResponse({"success": True})
            except Exception as e:
                return JsonResponse({"success": False, "error": str(e)})
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def add_post_comment(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        postId = data.get('postId')
        userId = data.get('userId')
        comment = data.get('comment')
        try:
            with connection.cursor() as cursor:
                cursor.execute("INSERT INTO comments (post_id, user_id, comment) VALUES (%s, %s, %s)", [postId, userId, comment])
            return JsonResponse({"success": True})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)})
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def get_post_comments(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        postId = data.get('postId')
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT user_id, comment FROM comments WHERE post_id = %s ORDER BY created_at", [postId])
                comments = cursor.fetchall()
                comments_list = []
                for comment in comments:
                    cursor.execute("SELECT username, profileImg from users  WHERE id = %s", [comment[0]])
                    user = cursor.fetchone()
                    comments_list.append({"username": str(user[0]), "userImage": base64.b64encode(user[1]).decode() if user[1] else None, "comment": str(comment[1])})
            return JsonResponse({"success": True, "comments": comments_list})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)})
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

def get_users(request):
    if request.method == 'GET':
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT id, username, email, profileImg FROM users ORDER BY username DESC")
                users = cursor.fetchall()
                users_list = []
                for user in users:
                    users_list.append({"uid": str(user[0]), "username": str(user[1]), "email": str(user[2]),"profileImg": base64.b64encode(user[3]).decode() if user[3] else None})
            return JsonResponse({"success": True, "users": users_list})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=500)
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def send_msg(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            senderId = data.get('senderId')
            receiverId = data.get('receiverId')
            content = data.get('content')
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT id FROM users WHERE id = %s", [senderId])
                if not cursor.fetchone():
                    return JsonResponse({'success': False, 'error': 'Uknown user'})
            try :
                with connection.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO messages (sender_id, receiver_id, content) VALUES (%s, %s, %s)",
                        [senderId, receiverId, content]
                    )
                    return JsonResponse({'success': True, 'message': 'Messade sent successfully'})
            except Exception as e:
                return JsonResponse({'success': False, 'error': 'Failed to send message'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})

    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def get_msgs(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        senderId = data.get('senderId')
        receiverId = data.get('receiverId')
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT sender_id, receiver_id, content, created_at FROM messages WHERE (sender_id = %s and receiver_id = %s) or (sender_id = %s and receiver_id = %s) ORDER BY created_at DESC", [senderId, receiverId, receiverId, senderId])
                messages = cursor.fetchall()
                messages_list = []
                for message in messages:
                    messages_list.append({"sender_id": str(message[0]), "receiver_id": str(message[1]), "content": str(message[2]),"created_at": str(message[3])})
            return JsonResponse({"success": True, "messages": messages_list})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)})
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def get_latest(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        senderId = data.get('senderId')
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT DISTINCT sender_id, receiver_id FROM messages WHERE (sender_id = %s or receiver_id = %s) ORDER BY created_at DESC", [senderId, senderId])
                latests = cursor.fetchall()
                latests_list = []
                help_me = []
                for latest in latests:
                    if senderId == str(latest[0]) and latest[1] not in help_me:
                        help_me.append(latest[1])
                        cursor.execute("SELECT username, profileImg from users  WHERE id = %s", [latest[1]])
                        user = cursor.fetchone()
                        cursor.execute("SELECT content, created_at FROM messages WHERE (sender_id = %s and receiver_id = %s) or (sender_id = %s and receiver_id = %s) ORDER BY created_at DESC LIMIT 1", [latest[1], latest[0], latest[0], latest[1]])
                        msg = cursor.fetchone()
                        latests_list.append({"receiver_username": str(user[0]), "receiver_img": base64.b64encode(user[1]).decode() if user[1] else None, "last_msg": str(msg[0]),"created_at": str(msg[1]), "receiver_id": str(latest[1])})
                    elif senderId != str(latest[0]) and latest[0] not in help_me:
                        help_me.append(latest[0])
                        cursor.execute("SELECT username, profileImg from users  WHERE id = %s", [latest[0]])
                        user = cursor.fetchone()
                        cursor.execute("SELECT content, created_at FROM messages WHERE (sender_id = %s and receiver_id = %s) or (sender_id = %s and receiver_id = %s) ORDER BY created_at DESC LIMIT 1", [latest[1], latest[0], latest[0], latest[1]])
                        msg = cursor.fetchone()
                        latests_list.append({"receiver_username": str(user[0]), "receiver_img": base64.b64encode(user[1]).decode() if user[1] else None, "last_msg": str(msg[0]),"created_at": str(msg[1]), "receiver_id": str(latest[0])})
            return JsonResponse({"success": True, "latests": latests_list})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)})
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def get_posts_by_id(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        userID = data.get('userID')
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT created_at, user_id, content, image, id FROM posts WHERE user_id = %s ORDER BY created_at DESC", [userID])
                posts = cursor.fetchall()
                posts_list = []
                for post in posts:
                    cursor.execute("SELECT username, profileImg from users  WHERE id = %s", [post[1]])
                    user = cursor.fetchone()
                    posts_list.append({"username": str(user[0]), "userImage": base64.b64encode(user[1]).decode() if user[1] else None, "created_at": str(post[0]),"content": str(post[2]), "image": base64.b64encode(post[3]).decode() if post[3] else None, "postId": str(post[4])})
            return JsonResponse({"success": True, "posts": posts_list})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=500)
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def delete_post(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            postId = data.get('postId')

            try :
                with connection.cursor() as cursor:
                    cursor.execute(
                        "DELETE FROM posts WHERE id = %s", [postId])
                    return JsonResponse({'success': True, 'message': 'Post deleted successfully'})
            except Exception as e:
                return JsonResponse({'success': False, 'error': 'Post creation failed'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})

    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

@csrf_exempt
def get_user_info(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            postId = data.get('postId')

            with connection.cursor() as cursor:
                cursor.execute("SELECT user_id FROM posts WHERE id = %s", [postId])
                userid = cursor.fetchone()[0]
                cursor.execute("SELECT id, username, email, profileImg FROM users WHERE id = %s", [userid])
                user = cursor.fetchone()
                user_data = [user[0],user[1],user[2],base64.b64encode(user[3]).decode() if user[3] else None]
                return JsonResponse({'success': True, 'user': user_data})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})

    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)