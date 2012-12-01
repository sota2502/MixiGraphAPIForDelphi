program MixiGraphAPI;

{$APPTYPE CONSOLE}











{%DotNetAssemblyCompiler 'libeay32.dll'}
{%DotNetAssemblyCompiler 'ssleay32.dll'}

uses
    SysUtils,
    Classes,
    IdHttp,
    IdSSLOpenSSL,
    IdSSLOpenSSLHeaders in 'lib\IdSSLOpenSSLHeaders.pas',
    superobject in 'lib\superobject.pas',
    superxmlparser in 'lib\superxmlparser.pas';

var
    http: TIdHttp;
    params: TStringList;
    ssl: TIdSSLIOHandlerSocketOpenSSL;
    token_res, profile_res, code, profile_endpoint: String;
    token_json, profile_json: ISuperObject;

const
    CONSUMER_KEY    = '[YOUR CONSUMER KEY]';
    CONSUMER_SECRET = '[YOUR CONSUMER SECRET]';
    REDIRECT_URI    = '[YOUR REDIRECT URI]';

    HTTP_TIMEOUT    = 300;
    TOKEN_ENDPOINT  = 'https://secure.mixi-platform.com/2/token';
    API_ENDPOINT    = 'http://api.mixi-platform.com/2';
begin
    WriteLn('Please input redirest url''s "code" parameter :');
    ReadLn(code);

    if ( code = '' ) then
    begin
        Exit;
    end;


    http   := TIdHttp.Create;
    ssl    := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    params := TStringList.Create;

    try
        //SSLの設定
        ssl.SSLOptions.Method      := sslvTLSv1;
        ssl.SSLOptions.Mode        := sslmUnassigned;
        ssl.SSLOptions.VerifyMode  := [];
        ssl.SSLOptions.VerifyDepth := 0;

        //Timeoutを設定しないとエラーになる
        http.ReadTimeout      := HTTP_TIMEOUT;
        http.ConnectTimeout   := HTTP_TIMEOUT;
        http.IOHandler        := ssl;

        //Token取得用のリクエストパラメータの設定
        params.Values['grant_type']    := 'authorization_code';
        params.Values['client_id']     := CONSUMER_KEY;
        params.Values['client_secret'] := CONSUMER_SECRET;
        params.Values['code']          := code;
        params.Values['redirect_uri']  := REDIRECT_URI;

        //Tokenのリクエストを取得
        token_res := http.Post(TOKEN_ENDPOINT, params);

        //レスポンスのJSONをパースしてaccess_tokenを取り出す
        token_json := SO(token_res);
        WriteLn(token_json['access_token'].AsString);

        //プロフィールの取得
        profile_endpoint := API_ENDPOINT
            + '/people/@me/@self?oauth_token='
            + token_json['access_token'].AsString;

        profile_res  := http.Get(profile_endpoint);
        profile_json := SO(profile_res)['entry'];

        //プロフィールの表示
        WriteLn('id:' + profile_json['id'].AsString);
        WriteLn('displayName:' + Utf8ToAnsi(profile_json['displayName'].AsString)); //文字化け対策
        WriteLn('profileUrl:' + profile_json['profileUrl'].AsString);
        WriteLn('thumbnailUrl:' + profile_json['thumbnailUrl'].AsString);
    finally
        http.Free;
        ssl.Free;
        params.Free;
    end;
end.
