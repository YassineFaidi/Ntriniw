from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from django.db import connection
import base64
import bcrypt
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
                cursor.execute("SELECT created_at, user_id, content, image FROM posts ORDER BY created_at DESC")
                posts = cursor.fetchall()
                posts_list = []
                for post in posts:
                    cursor.execute("SELECT username, profileImg from users  WHERE id = %s", [post[1]])
                    user = cursor.fetchone()
                    posts_list.append({"username": str(user[0]), "userImage": base64.b64encode(user[1]).decode() if user[1] else None, "created_at": str(post[0]),"content": str(post[2]), "image": base64.b64encode(post[3]).decode() if post[3] else None})
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
                    return JsonResponse({'success': False, 'error': 'Uknown user'})

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
                cursor.execute("SELECT created_at, user_id, image FROM stories ORDER BY created_at DESC")
                stories = cursor.fetchall()
                stories_list = []
                for story in stories:
                    cursor.execute("SELECT username, profileImg from users  WHERE id = %s", [story[1]])
                    user = cursor.fetchone()
                    stories_list.append({"username": str(user[0]), "userImage": base64.b64encode(user[1]).decode() if user[1] else None, "created_at": str(story[0]), "image": base64.b64encode(story[2]).decode() if story[2] else None})
            return JsonResponse({"success": True, "stories": stories_list})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=500)
    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

