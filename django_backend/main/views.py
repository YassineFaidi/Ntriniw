from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.db import connection
import json

@csrf_exempt
def login_view(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            password = data.get('password')

            with connection.cursor() as cursor:
                cursor.execute("SELECT id, username, email FROM users WHERE email = %s AND password = %s", [email, password])
                user = cursor.fetchone()
                if user:
                    user_data = {
                        'uid': user[0],
                        'username': user[1],
                        'email': user[2],
                    }
                    return JsonResponse({'success': True, 'user': user_data})
                else:
                    return JsonResponse({'success': False, 'error': 'Invalid credentials'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})

    return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)
