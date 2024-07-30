from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from django.db import connection
import base64
import bcrypt
import json

@csrf_exempt
def sign_up_view(request):
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
def sign_in_view(request):
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
