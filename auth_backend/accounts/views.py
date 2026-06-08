from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken

from .models import EmailOTP
from .utils import generate_otp, send_otp


# -------------------------
# REGISTER
# -------------------------
@api_view(['POST'])
def register_user(request):
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')

    if User.objects.filter(username=username).exists():
        return Response({
            'success': False,
            'message': 'Username already exists'
        })

    if User.objects.filter(email=email).exists():
        return Response({
            'success': False,
            'message': 'Email already exists'
        })

    User.objects.create_user(
        username=username,
        email=email,
        password=password,
        is_active=False
    )

    otp = generate_otp()

    EmailOTP.objects.create(
        email=email,
        otp=otp
    )

    send_otp(email, otp)

    return Response({
        'success': True,
        'message': 'User created. OTP sent to email.'
    })


# -------------------------
# LOGIN
# -------------------------
@api_view(['POST'])
def login_user(request):
    username = request.data.get('username')
    password = request.data.get('password')

    user = authenticate(
        username=username,
        password=password
    )

    if user is None:
        return Response({
            "success": False,
            "message": "Invalid credentials"
        })

    otp = generate_otp()

    EmailOTP.objects.create(
        email=user.email,
        otp=otp
    )

    send_otp(user.email, otp)

    return Response({
        "success": True,
        "message": "OTP sent to email",
        "email": user.email
    })


# -------------------------
# SEND OTP
# -------------------------
@api_view(['POST'])
def send_otp_view(request):
    email = request.data.get('email')

    if not email:
        return Response({
            "success": False,
            "message": "Email is required"
        })

    otp = generate_otp()

    EmailOTP.objects.create(
        email=email,
        otp=otp
    )

    send_otp(email, otp)

    return Response({
        "success": True,
        "message": "OTP sent successfully"
    })


# -------------------------
# VERIFY OTP
# -------------------------
@api_view(['POST'])
def verify_otp_view(request):
    email = request.data.get('email')
    otp = request.data.get('otp')

    if not email or not otp:
        return Response({
            "success": False,
            "message": "Email and OTP are required"
        })

    otp_obj = EmailOTP.objects.filter(
        email=email,
        otp=otp
    ).last()

    if not otp_obj:
        return Response({
            "success": False,
            "message": "Invalid OTP"
        })

    try:
        user = User.objects.get(email=email)

        user.is_active = True
        user.save()

    except User.DoesNotExist:
        return Response({
            "success": False,
            "message": "User not found"
        })

    refresh = RefreshToken.for_user(user)

    return Response({
        "success": True,
        "message": "OTP verified successfully",
        "access": str(refresh.access_token)
    })


# -------------------------
# FORGOT PASSWORD
# -------------------------
@api_view(['POST'])
def forgot_password(request):
    email = request.data.get('email')

    if not email:
        return Response({
            "success": False,
            "message": "Email is required"
        })

    try:
        User.objects.get(email=email)

    except User.DoesNotExist:
        return Response({
            "success": False,
            "message": "User not found"
        })

    otp = generate_otp()

    EmailOTP.objects.create(
        email=email,
        otp=otp
    )

    send_otp(email, otp)

    return Response({
        "success": True,
        "message": "Password reset OTP sent"
    })


# -------------------------
# RESET PASSWORD
# -------------------------
@api_view(['POST'])
def reset_password(request):
    email = request.data.get('email')
    otp = request.data.get('otp')
    password = request.data.get('password')

    if not email or not otp or not password:
        return Response({
            "success": False,
            "message": "Missing fields"
        })

    otp_obj = EmailOTP.objects.filter(
        email=email,
        otp=otp
    ).last()

    if not otp_obj:
        return Response({
            "success": False,
            "message": "Invalid OTP"
        })

    try:
        user = User.objects.get(email=email)

        user.password = make_password(password)
        user.save()

        return Response({
            "success": True,
            "message": "Password updated successfully"
        })

    except User.DoesNotExist:
        return Response({
            "success": False,
            "message": "User not found"
        })