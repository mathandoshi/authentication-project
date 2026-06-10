@api_view(['POST'])
def login_user(request):
    try:
        username = request.data.get('username')
        password = request.data.get('password')

        print("USERNAME:", username)

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

        print("OTP CREATED")

        send_otp(user.email, otp)

        print("EMAIL SENT")

        return Response({
            "success": True,
            "message": "OTP sent to email",
            "email": user.email
        })

    except Exception as e:
        print("LOGIN ERROR:", str(e))

        return Response({
            "success": False,
            "message": str(e)
        }, status=500)