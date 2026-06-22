from django.contrib.auth import authenticate, get_user_model
from django.core.exceptions import ValidationError
from django.contrib.auth.password_validation import validate_password
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken

from .models import EmailOTP
from .utils import generate_otp, send_otp

User = get_user_model()


@api_view(['POST'])
def register_user(request):
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')

    if not username or not email or not password:
        return Response({
            'success': False,
            'message': 'Username, email, and password are required.'
        })

    if User.objects.filter(username=username).exists():
        return Response({
            'success': False,
            'message': 'Username already exists.'
        })

    if User.objects.filter(email=email).exists():
        return Response({
            'success': False,
            'message': 'Email already registered.'
        })

    try:
        validate_password(password)
    except ValidationError as exc:
        return Response({
            'success': False,
            'message': ' '.join(exc.messages)
        })

    user = User.objects.create_user(username=username, email=email, password=password)
    return Response({
        'success': True,
        'message': 'User registered successfully.',
        'user': {
            'id': user.id,
            'username': user.username,
            'email': user.email,
        }
    })


@api_view(['POST'])
def login_user(request):
    try:
        username = request.data.get('username')
        password = request.data.get('password')

        if not username or not password:
            return Response({
                'success': False,
                'message': 'Username and password are required.'
            })

        user = authenticate(username=username, password=password)
        if user is None:
            return Response({
                'success': False,
                'message': 'Invalid credentials.'
            })

        otp = generate_otp()
        EmailOTP.objects.create(email=user.email, otp=otp)
        send_otp(user.email, otp)

        return Response({
            'success': True,
            'message': 'OTP sent to email.',
            'email': user.email,
        })
    except Exception as e:
        return Response({
            'success': False,
            'message': str(e)
        }, status=500)


@api_view(['POST'])
def send_otp_view(request):
    email = request.data.get('email')
    if not email:
        return Response({
            'success': False,
            'message': 'Email is required.'
        })

    try:
        User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({
            'success': False,
            'message': 'No user found with this email.'
        })

    otp = generate_otp()
    EmailOTP.objects.create(email=email, otp=otp)
    send_otp(email, otp)

    return Response({
        'success': True,
        'message': 'OTP sent to email.'
    })


@api_view(['POST'])
def verify_otp_view(request):
    email = request.data.get('email')
    otp = request.data.get('otp')

    if not email or not otp:
        return Response({
            'success': False,
            'message': 'Email and OTP are required.'
        })

    otp_record = EmailOTP.objects.filter(email=email, otp=otp).order_by('-created_at').first()
    if otp_record is None:
        return Response({
            'success': False,
            'message': 'Invalid OTP.'
        })

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({
            'success': False,
            'message': 'User not found.'
        })

    refresh = RefreshToken.for_user(user)
    otp_record.delete()

    return Response({
        'success': True,
        'message': 'OTP verified successfully.',
        'access': str(refresh.access_token),
        'refresh': str(refresh)
    })


@api_view(['POST'])
def forgot_password(request):
    email = request.data.get('email')
    if not email:
        return Response({
            'success': False,
            'message': 'Email is required.'
        })

    try:
        User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({
            'success': False,
            'message': 'User not found.'
        })

    otp = generate_otp()
    EmailOTP.objects.create(email=email, otp=otp)
    send_otp(email, otp)

    return Response({
        'success': True,
        'message': 'Password reset OTP sent to email.'
    })


@api_view(['POST'])
def reset_password(request):
    email = request.data.get('email')
    otp = request.data.get('otp')
    new_password = request.data.get('new_password')

    if not email or not otp or not new_password:
        return Response({
            'success': False,
            'message': 'Email, OTP, and new password are required.'
        })

    otp_record = EmailOTP.objects.filter(email=email, otp=otp).order_by('-created_at').first()
    if otp_record is None:
        return Response({
            'success': False,
            'message': 'Invalid OTP.'
        })

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({
            'success': False,
            'message': 'User not found.'
        })

    try:
        validate_password(new_password, user=user)
    except ValidationError as exc:
        return Response({
            'success': False,
            'message': ' '.join(exc.messages)
        })

    user.set_password(new_password)
    user.save()
    otp_record.delete()

    return Response({
        'success': True,
        'message': 'Password has been reset successfully.'
    })
