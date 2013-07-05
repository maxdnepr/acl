-record(user_v1, {uid, login, passwd}).

-record(session_v1, {is_auth = false, login, t_sign_in, t_sign_out, t_endsession}).
